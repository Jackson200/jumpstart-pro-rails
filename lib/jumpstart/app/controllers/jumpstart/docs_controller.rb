require "pagy/extras/array"

module Jumpstart
  class DocsController < ::ApplicationController
    def icons
      @icons = Dir.chdir(Rails.root.join("app/assets/images")) {
        Dir.glob("icons/*.svg").sort
      }
    end

    def pagination
      @pagy, _ = pagy_array([nil] * 1000)
    end
  end
end
