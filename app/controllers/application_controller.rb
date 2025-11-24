class ApplicationController < ActionController::Base
  # Only allow modrn browsers supporting webp images, web push, badges, import maps, CSS nesting and CSS :has.
  allow_browser versions: :modern
end