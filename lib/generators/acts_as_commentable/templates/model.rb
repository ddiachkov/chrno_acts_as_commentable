# encoding: utf-8

##
# Сущность "комментарий".
#
class Comment < ActiveRecord::Base
  include ActsAsCommentable::CommentBase
end