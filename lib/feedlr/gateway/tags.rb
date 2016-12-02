module Feedlr
  module Gateway
    # Tags API
    #
    # @see http://developer.feedly.com/v3/tags/
    module Tags
      # Get the list of tags created by the user
      #
      # @see http://developer.feedly.com/v3/tags/#get-the-list-of-tags-created-by-the-user
      # @return [Feedlr::Collection]
      def user_tags
        request_with_object(method: :get,
                            path: '/tags')
      end

      # Enterprise Tags API
      #
      # @see https://developer.feedly.com/v3/enterprisetags/
      #
      # Get the list of enterprise tags (Enterprise only)
      #
      # @see https://developer.feedly.com/v3/enterprisetags/#get-the-list-of-enterprise-tags-enterprise-only
      # @return [Feedlr::Collection]
      def enterprise_tags
        request_with_object(method: :get,
                            path: '/enterprise/tags')
      end

      # Tag an existing entry
      #
      # @see tag_entries
      # @param entry_id [String]
      # @param tags_ids [#to_ary] list of tags ids
      # @return [Feedlr::Success]
      def tag_entry(entry_id, tags_ids)
        tag_entries([entry_id], tags_ids)
      end

      # Tag multiple entries
      #
      # @see http://developer.feedly.com/v3/tags/#tag-multiple-entries
      # @param entries_ids [#to_ary] list of entries ids
      # @param tags_ids [#to_ary] list of tags ids
      # @return [Feedlr::Success]
      def tag_entries(entries_ids, tags_ids)
        tags_query = join_ids(tags_ids)
        request_with_object(method: :put,
                            path: "/tags/#{tags_query}",
                            params: { entryIds: entries_ids.to_ary })
      end

      # Untag an existing entry
      #
      # @see untag_entries
      # @param entry_id [String]
      # @param tags_ids [#to_ary] list of tags ids
      # @return [Feedlr::Success]
      def untag_entry(entry_id, tags_ids)
        untag_entries([entry_id], tags_ids)
      end

      # Untag multiple entries
      #
      # @see http://developer.feedly.com/v3/tags/#untag-multiple-entries
      # @param entries_ids [#to_ary] list of entries ids
      # @param tags_ids [#to_ary] list of tags ids
      # @return [Feedlr::Success]
      def untag_entries(entries_ids, tags_ids)
        tags_query = join_ids(tags_ids)
        entries_query = join_ids(entries_ids)
        request_with_object(method: :delete,
                            path: "/tags/#{tags_query}/#{entries_query}")
      end

      # Change a tag label
      #
      # @see http://developer.feedly.com/v3/tags/#change-a-tag-label
      # @param tag_id [String]
      # @param new_value [String] label's new value
      # @return [Feedlr::Success]
      def change_tag_label(tag_id, new_value)
        request_with_object(method: :post,
                            path: "/tags/#{CGI.escape(tag_id)}",
                            params: { label: new_value })
      end

      # Delete a tag
      #
      # @see delete_tags
      # @param tag_id [String]
      # @return [Feedlr::Success]
      def delete_tag(tag_id)
        delete_tags([tag_id])
      end

      # Delete tags
      #
      # @see http://developer.feedly.com/v3/tags/#delete-tags
      # @param tags_ids [#to_ary] list of ids
      # @return [Feedlr::Success]
      def delete_tags(tags_ids)
        tags_query = join_ids(tags_ids)
        request_with_object(method: :delete,
                            path: "/tags/#{tags_query}")
      end

    end
  end
end
