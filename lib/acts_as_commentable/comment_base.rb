# encoding: utf-8
require "active_record"

module ActsAsCommentable

  ##
  # Расширения для комментариев.
  #
  module CommentBase
    extend ActiveSupport::Concern

    included do |comment_class|
      comment_class.class_eval do
        # Комментарий может цепляться к произвольным объектам
        belongs_to :commentable,
                   :polymorphic => true,
                   :touch       => true

        # Автор комментария
        belongs_to :author, class_name: "User"

        # Комментируемый объект, текст и автор должны быть заполнены
        validates :commentable, presence: true
        validates :body, presence: true
        validates :author, presence: true

        # Сортировка по умолчанию
        default_scope order( :created_at )

        # Комментарии можно комментировать
        acts_as_commentable

        ##
        # Послать сообщение к родительскому объекту.
        #
        after_create do |comment|
          comment.commentable.run_callbacks( :after_comment_create, comment )
        end

        ##
        # Сработает при комментировании комментария.
        #
        after_comment_create do |comment|
          # Перенаправить событие на корневой объект
          comment.commentable.run_callbacks( :after_comment_create, comment )
        end
      end
    end

    module InstanceMethods
      ##
      # Возвращает самый верхний комментарий в ветке.
      # @return [Comment]
      #
      def top_comment
        if self.commentable.is_a? self.class
          self.commentable.top_comment
        else
          self
        end
      end

      ##
      # Возвращает объект, к которому привязана ветка комментариев.
      #
      def root
        top_comment.commentable
      end

      ##
      # Возвращает глубину вложенности комментария.
      # @return [Fixnum]
      #
      def depth
        if self.commentable.is_a? self.class
          1 + self.commentable.depth
        else
          0
        end
      end

      ##
      # Возвращает название класса комментируемого объекта.
      # @return [String]
      #
      def commentable_type
        commentable ? commentable.class.name : nil
      end

      ##
      # Возвращает ID комментируемого объекта.
      # @return [Fixnum]
      #
      def commentable_id
        commentable ? commentable.id : nil
      end
    end
  end
end