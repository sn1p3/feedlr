require 'faraday'
require 'faraday_middleware'
require_relative 'request'
require_relative 'response'
require_relative 'factory'
require_relative 'error'

module Feedlr
  # Do all http requests and call the mapper
  module HTTP
    ENDPOINT = 'http://cloud.feedly.com'
    SANDBOX_ENDPOINT = 'http://sandbox.feedly.com'
    API_VERSION = '/v3'

    private

    # Run an HTTP request and map the response to a domain class
    # @param [Hash] request_attributes request options
    # @option request_attributes [Symbol] :method
    # @option request_attributes [String] :path
    # @option request_attributes [String] :params
    # @option request_attributes [String] :headers
    # @return [Faraday::Response]
    def request_with_object(request_attributes)
      response = Request.new(request_attributes.merge(client: self)).perform
      Factory.create(response.body)
    end

    %w(post put).each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(path, params, headers)
              request(:#{method}, path, headers) do |request|
                if !headers || headers[:"Content-Type"].nil?
                  params = MultiJson.dump(input_to_payload(params))
                end
                request.body = params if params
              end
          end
      RUBY
    end

    %w(get delete).each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(path, params, headers)
              request(:#{method}, path, headers) do |request|
                request.params.update(input_to_params(params)) if params
              end
          end
      RUBY
    end

    # Convert input to consumable payload
    # @param input [#to_hash, #to_ary]
    # @return [Hash,Array]
    def input_to_payload(input)
      case input
      when ->(data) { data.respond_to?(:to_hash) }
        input.to_hash
      when ->(data) { data.respond_to?(:to_ary) }
        input.to_ary
      else
        fail TypeError, "#{input.inspect} to payload"
      end
    end

    # Convert input to consumable payload
    # @param input [#to_ary]
    # @return [Array]
    def input_to_params(input)
      case input
      when ->(data) { data.respond_to?(:to_hash) }
        input.to_hash
      else
        fail TypeError, "#{input.inspect} to params"
      end
    end

    # Initiate and memoize the HTTP connection object
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(end_point, connection_options)
    end

    # Build and memoize the connection options
    # @return [Hash]
    def connection_options
      @connection_options ||=  {
        builder: middleware,
        headers: request_headers,
        request:  {
          open_timeout: 10,
          timeout: 30
        }
      }
    end

    # Build the rack middleware for the requests
    # @return [Faraday::RackBuilder]
    def middleware
      Faraday::RackBuilder.new do |faraday|
        faraday.request :url_encoded
        # Add logging
        faraday.response(:logger, logger)
        # Parse XML
        faraday.response :xml, content_type: /\bxml$/
        # Parse JSON
        faraday.response :json, content_type: /\bjson$/

        faraday.adapter :net_http
      end
    end

    # Run the desired HTTP request and raise excpetions in
    # case of failure, otherwise return the response
    # @param method [String] HTTP method
    # @param path [String]
    # @param headers [Hash]
    # @return [Feedlr::Response]
    def request(method, path, headers, &block)
      response = run_request(method, path, headers, &block)
      response.raise_http_errors
      response
    rescue Faraday::Error::TimeoutError, Timeout::Error => error
      raise(Feedlr::Error::RequestTimeout.new, error.message)
    rescue Faraday::Error::ClientError, JSON::ParserError => error
      raise(Feedlr::Error.new, error.message)
    end

    # Run the actual request and logs it
    # @param method [String] HTTP method
    # @param path [String]
    # @param headers [Hash]
    # @return [Feedlr::Response]
    def run_request(method, path, headers)
      faraday_response = connection.send(method) do |request|
        request.url(API_VERSION + path)
        request.headers.update(headers) if headers
        yield(request) if block_given?
      end
      logger.debug(faraday_response.inspect)
      Feedlr::Response.new(faraday_response.status.to_i,
                           faraday_response.headers,
                           faraday_response.body)
    end

    
    # Build the initial request headers
    # @return [Hash]
    def request_headers
      @headers = { :"Accept" => 'application/json',
                   :"Content-Type" => 'application/json',
                   :user_agent => user_agent
                   }
      @headers[:Authorization] =
        "OAuth #{oauth_access_token}" if oauth_access_token
      @headers
    end

    # Build and memoize the user agent
    # @return [String]
    def user_agent
      @user_agent ||= "Feedlr Ruby Gem #{Feedlr::Version}"
    end

    # Build and memoize the endpoint
    # @return [String]
    def end_point
      @end_point ||= (sandbox ? SANDBOX_ENDPOINT : ENDPOINT)
    end
  end
end