# encoding: utf-8
require "acts_as_commentable/comment_base"
require "acts_as_commentable/ar_extension"
require "acts_as_commentable/version"

module ActsAsCommentable
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