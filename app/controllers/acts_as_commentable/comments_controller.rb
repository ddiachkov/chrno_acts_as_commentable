# encoding: utf-8
module ActsAsCommentable
  ##
  # Создание и редактирование комментариев.
  #
  class CommentsController < ApplicationController
    # Имя класса комментариев
    class_attribute :comment_class_name
    self.comment_class_name = "Comment"

    # Загружаем комментарий
    before_filter :load_comment, except: [ :new, :create ]

    # Загружаем комментируемый объект
    before_filter :load_commentable, only: [ :new, :create ]

    # Мы всегда пользуемся AJAX'ом
    layout false

    respond_to :html

    # Форма создания комментария
    def new
      @comment = comment_class.new
      @comment.commentable = @commentable
      @comment.author = current_user

      respond_with @comment, template: "comments/edit"
    end

    # Записать комментарий
    def create
      @comment = comment_class.new params[ :comment ]
      @comment.commentable = @commentable
      @comment.author = current_user
      @comment.save

      respond_with @comment
    end

    # Показать единичный комментарий
    # (этот action нужен потому что по умолчанию Responder перенаправляет на
    # него после успешного создания/изменения записи)
    def show
      respond_with @comment
    end

    # Редактировать комментарий
    def edit
      respond_with @comment
    end

    # Записать изменения
    def update
      @comment.update_attributes params[ :comment ]
      respond_with @comment
    end

    # Удалить комментарий
    def destroy
      @comment.destroy
      respond_with @comment, template: "comments/show"
    end

    protected

    # Возвращает класс комментариев
    def comment_class
      @comment_class ||= ActiveRecord::Base.send( :compute_type, self.class.comment_class_name )
    end

    # Загрузка комментария
    def load_comment
      @comment = comment_class.find params[ :id ]
    end

    # Загрузка комментируемого объекта
    def load_commentable
      commentable_type, commentable_id = nil, nil

      if params[ :comment ]
        commentable_type = params[ :comment ][ :commentable_type ]
        commentable_id = params[ :comment ][ :commentable_id ]
      else
        commentable_type = params[ :commentable_type ]
        commentable_id = params[ :commentable_id ]
      end

      @commentable =
        if commentable_type and commentable_id
          # Грузим объект из параметров
          klass = ActiveRecord::Base.send( :compute_type, commentable_type )
          klass.find( commentable_id )
        else
          nil
        end
    end
  end
end