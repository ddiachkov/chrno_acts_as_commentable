# encoding: utf-8
require "active_record"

module ActsAsCommentable

  ##
  # Модуль с методами экземпляра комментариев.
  #
  module CommentInstanceMethods
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
  end # module CommentInstanceMethods

  ##
  # Возвращает расширение для комментариев.
  #
  # @param [Hash] options
  #   @option options [String] :author_class ("User") класс пользователей
  #
  # @return [Module]
  #
  def self.CommentBase( options = {} )
    # Настройки по умолчанию
    options = options.reverse_merge author_class: "User"

    Module.new do
      # Сохраняем параметры в переменную, т.к. мы выходим из области
      # видимости CommentBase
      class_variable_set :@@_options, options

      def self.included( comment_class )
        # Подключаем методы экземпляра для комментариев
        comment_class.send :include, CommentInstanceMethods

        comment_class.class_eval do
          # Комментарий может цепляться к произвольным объектам
          belongs_to :commentable,
                     :polymorphic => true,
                     :touch       => true

          # Автор комментария
          belongs_to :author, class_name: @@_options[ :author_class ]

          # Комментируемый объект, текст и автор должны быть заполнены
          validates :commentable, presence: true
          validates :body, presence: true
          validates :author, presence: true

          # Сортировка по умолчанию
          default_scope order( :created_at )

          # Комментарии можно комментировать
          acts_as_commentable
        end # class_eval
      end # def included
    end # Module.new
  end # def self.CommentBase

end # module ActsAsCommentable