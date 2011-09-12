# encoding: utf-8
module ActsAsCommentable
  module CommentsHelper
    ##
    # Отображает ссылку на форму создания комментария.
    #
    # @param [Hash] options параметры
    #   @option options [#comments] :for комментируемый объект
    #
    # @example
    #   link_to_new_comment "New comment", for: @post
    #
    def link_to_new_comment( *args, &block )
      if block_given?
        options      = args.first || {}
        html_options = args.second
        link_to_new_comment capture( &block ), options, html_options
      else
        name    = args[ 0 ]
        options = ( args[ 1 ] || {} ).merge( args[ 2 ] || {} )

        # Комментируемый объект
        commentable = options.delete :for

        # Добавляем data атрибуты
        options[ :data ] ||= {}
        options[ :data ][ "commentable-id"   ] = commentable.id
        options[ :data ][ "commentable-type" ] = commentable.class.name

        if options[ :placeholder ]
          options[ :data ][ "placeholder" ] = options.delete :placeholder || ".comments"
        end

        # Добавляем класс
        options[ :class ] ||= ""
        options[ :class ] << " new-comment-link"
        options[ :class ].strip!

        link_to name, new_comment_path, options
      end
    end

    ##
    # Отображает ссылку на редактирование комментария.
    #
    # @param [Hash] options параметры
    #   @option options [#comments] :for комментируемый объект
    #
    # @example
    #   link_to_edit_comment "Edit", @comment
    #
    def link_to_edit_comment( *args, &block )
      if block_given?
        comment      = args[ 0 ]
        options      = args[ 1 ] || {}
        html_options = args[ 2 ]
        link_to_edit_comment capture( &block ), comment, options, html_options
      else
        name    = args[ 0 ]
        comment = args[ 1 ]
        options = ( args[ 2 ] || {} ).merge( args[ 3 ] || {} )

        raise ArgumentError, "expected Comment, got: #{comment.inspect}" unless comment.is_a? Comment

        # Сохраняем ID удаляемого комментария
        options[ :data ] ||= {}
        options[ :data ][ "comment-id" ] = comment.id

        # Добавляем класс
        options[ :class ] ||= ""
        options[ :class ] << " edit-comment-link"
        options[ :class ].strip!

        link_to name, edit_comment_path( comment ), options
      end
    end

    ##
    # Отображает ссылку на удаление комментария.
    #
    # @example
    #   link_to_delete_comment "Delete", @comment
    #
    def link_to_delete_comment( *args, &block )
      if block_given?
        comment      = args[ 0 ]
        options      = args[ 1 ] || {}
        html_options = args[ 2 ]
        link_to_delete_comment capture( &block ), comment, options, html_options
      else
        name    = args[ 0 ]
        comment = args[ 1 ]
        options = ( args[ 2 ] || {} ).merge( args[ 3 ] || {} )

        raise ArgumentError, "expected Comment, got: #{comment.inspect}" unless comment.is_a? Comment

        # Сохраняем ID удаляемого комментария
        options[ :data ] ||= {}
        options[ :data ][ "comment-id" ] = comment.id

        # Добавляем класс
        options[ :class ] ||= ""
        options[ :class ] << " remove-comment-link"
        options[ :class ].strip!

        options[ :remote ] = true
        options[ :method ] = :delete

        link_to name, comment, options
      end
    end

    ##
    # Отображает комментарии 1 уровня к объекту.
    #
    # @param [Hash] options параметры
    #   @option options [#comments] :for комментируемый объект
    #
    # @example
    #   display_comments for: @post
    #
    def display_comments( options )
      # Комментируемый объект
      commentable = options.delete :for

      render partial: "comments/comment",
             collection: commentable.comments
    end
  end
end