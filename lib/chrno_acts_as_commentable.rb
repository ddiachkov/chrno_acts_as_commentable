# encoding: utf-8
module ActsAsCommentable
  extend ActiveSupport::Autoload

  autoload :ARExtension, "acts_as_commentable/ar_extension"
  autoload :CommentBase, "acts_as_commentable/comment_base"
  autoload :VERSION,     "acts_as_commentable/version"
end

require "acts_as_commentable/engine"