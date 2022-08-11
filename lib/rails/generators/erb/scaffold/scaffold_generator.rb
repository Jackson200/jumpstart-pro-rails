require File.join(Gem::Specification.find_by_name("railties").full_gem_path, "lib/rails/generators/erb/scaffold/scaffold_generator")

module Erb
  module Generators
    class ScaffoldGenerator
      # Enhance the Rails scaffold generator

      def index_partial
        template "index_partial.html.erb", File.join("app/views", controller_file_path, "_index.html.erb")
      end

      def add_to_navigation
        append_to_file "app/views/shared/_left_nav.html.erb" do
          "<%= nav_link_to \"#{plural_table_name.titleize}\", #{index_helper(type: :path)}, class: \"nav-link\" %>\n"
        end
      end
    end
  end
end
