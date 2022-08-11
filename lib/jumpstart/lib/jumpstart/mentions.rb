module Jumpstart
  module Mentions
    extend ActiveSupport::Concern

    class_methods do
      # Searches a rich text content object for attachments matching class
      #
      # For example:
      #   has_rich_text_mentions :body
      #
      # Defines `body_mentions(type=User)`
      #   `type` - Class to search for, defaults to `User` class
      #
      # @post.body_mentions #=> [User, User]
      # @post.body_mentions(Discussion) #=> [Discussion, Discussion]
      def has_rich_text_mentions(rich_text)
        define_method "#{rich_text}_mentions" do |type = User|
          send(rich_text).body.attachables.grep(type)
        end
      end
    end
  end
end
