# encoding: utf-8
module ActsAsCommentable
  class Engine < Rails::Engine
    initializer "acts_as_commentable.initialization" do
      # Загрузка в AR
      ActiveSupport.on_load( :active_record ) do
        puts "--> load acts_as_commentable"
        extend ActsAsCommentable::ARExtension
      end
    end
  end
end