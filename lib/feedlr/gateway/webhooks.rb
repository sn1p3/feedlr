module Feedlr
  module Gateway
    # Triggers API
    #
    # @see https://developer.feedly.com/v3/enterpriseTriggers/
    module Webhooks
      # Get the List of Webhooks (enterprise only)
      #
      # @see https://developer.feedly.com/v3/enterpriseTriggers/#get-the-list-of-webhooks-enterprise-only
      # @return [Feedlr::Collection]
      def webhooks
        request_with_object(method: :get,
        path: '/enterprise/triggers')
      end
      alias_method :triggers, :webhooks

      # Create or Update a Webhook (enterprise only)
      #
      # @see https://developer.feedly.com/v3/enterpriseTriggers/#create-or-update-a-webhook-enterprise-only
      # @return [Feedlr::Base]
      def webhooks_update(webhook)
        request_with_object(method: :post,
                            path: '/enterprise/triggers',
                            params: webhook)
      end
      alias_method :triggers_update, :webhooks_update

      # Delete a Webhook (enterprise only)
      #
      # @see https://developer.feedly.com/v3/enterpriseTriggers/#delete-a-webhook-enterprise-only
      # @return [Feedlr::Success]
      def webhooks_delete(webhook_id)
        request_with_object(method: :delete,
                            path: "/enterprise/triggers/#{webhook_id}")
      end
      alias_method :triggers_delete, :webhooks_delete
    end
  end
end
