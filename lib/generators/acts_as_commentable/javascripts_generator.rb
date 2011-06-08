# encoding: utf-8
require "rails"

module ActsAsCommentable
  class JavascriptsGenerator < Rails::Generators::Base
    source_root File.expand_path( "../../../../vendor/assets/javascripts", __FILE__ )
    desc "installs js helper"

    def make_js
      copy_file "comments-helper.js", File.join( "app", "assets", "javascripts", "comments-helper.js")
    end
  end
end