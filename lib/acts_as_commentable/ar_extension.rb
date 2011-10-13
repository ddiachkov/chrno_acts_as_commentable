# encoding: utf-8
require "active_support/callbacks"

module ActsAsCommentable
  # Расширения для Active Record
  module ARExtension
    ##
    # Макрос acts_as_commentable добавляет в модель комментарии.
    #
    def acts_as_commentable
      # Цепляем комментарии
      has_many :comments,
               :class_name => "Comment",
               :as         => :commentable,
               :dependent  => :destroy

      include InstanceMethods
    end
  end

  ##
  # Модуль подмешивается в модель при вызове {#acts_as_commentable}
  #
  module InstanceMethods
    ##
    # Возвращает общее кол-во комментариев вместе с подкомментариями (PG only).
    # @return [Fixnum]
    #
    def total_comments_count
      self.comments.count_by_sql %Q{
        WITH RECURSIVE all_comments (commentable_id) AS (
          SELECT id
            FROM comments
           WHERE commentable_id = #{self.id}
             AND commentable_type = '#{self.class.name}'

           UNION

          SELECT c.id
            FROM comments c
               , all_comments ac
           WHERE c.commentable_id = ac.commentable_id
             AND c.commentable_type = 'Comment'
        )

        SELECT count(*) FROM all_comments
      }
    end
  end
end