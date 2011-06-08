# encoding: utf-8
require "rails"
require "active_record"

module ActsAsCommentable
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path( "../templates", __FILE__ )
    desc "installs model, controller and views"

    def make_migration
      migration_template "migration.rb", "db/migrate/create_comments"
    end

    def make_model
      copy_file "model.rb", File.join( "app", "models", "comment.rb" )
    end

    def make_controller
      copy_file "controller.rb", File.join( "app", "controllers", "comments_controller.rb" )
    end

    def make_views
      directory "views", "app/views/comments"
    end

    def make_route
      route "resources :comments, except: [ :index ]"
    end

    private

    include Rails::Generators::Migration

    # Код взят из генератора моделей
    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      if ActiveRecord::Base.timestamped_migrations
        [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
      else
        "%.3d" % next_migration_number
      end
    end
  end
end