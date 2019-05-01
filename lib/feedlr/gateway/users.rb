module Feedlr
  module Gateway
    # Tags API
    #
    # @see http://developer.feedly.com/v3/tags/
    module Users
      # Get the list of tags created by the user
      #
      # @see http://developer.feedly.com/v3/tags/#get-the-list-of-tags-created-by-the-user
      # @return [Feedlr::Collection]
      def users
        request_with_object(method: :get,
                            path: '/enterprise/users')
      end

    end
  end
end
