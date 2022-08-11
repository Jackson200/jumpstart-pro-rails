class ActionText::EmbedsController < ApplicationController
  before_action :authenticate_user!

  def create
    @embed = ActionText::Embed.from_url(params[:id])
    if @embed
      content = render_to_string(
        partial: @embed.to_trix_content_attachment_partial_path,
        object: @embed,
        as: :embed,
        formats: [:html]
      )

      render json: {
        sgid: @embed.attachable_sgid,
        content: content
      }
    else
      head :not_found
    end
  end

  def patterns
    render json: ActionText::Embed::PATTERNS
  end
end
