module Feedlr
  module Gateway
    # Enterprise Collections API
    #
    # @see https://developer.feedly.com/v3/enterprisecollections/
    module Collections

      # Get the list of enterprise collections (Enterprise only)
      #
      # @see https://developer.feedly.com/v3/enterprisecollections/#get-the-list-of-enterprise-collections-enterprise-only
      # @return [Feedlr::Collection]
      def enterprise_collections
        request_with_object(method: :get,
                            path: '/enterprise/collections')
      end
    end
  end
end
