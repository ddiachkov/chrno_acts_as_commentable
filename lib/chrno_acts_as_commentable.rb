# encoding: utf-8
module ActsAsCommentable
  extend ActiveSupport::Autoload

  autoload :ARExtension, "acts_as_commentable/ar_extension"
  autoload :CommentBase, "acts_as_commentable/comment_base"
  autoload :VERSION,     "acts_as_commentable/version"

  class Engine < Rails::Engine
    initializer "acts_as_commentable.initialization" do
      # Загрузка в AR
      ActiveSupport.on_load( :active_record ) do
        Rails.logger.debug "--> load acts_as_commentable"
        extend ActsAsCommentable::ARExtension
      end
    end
  end
end