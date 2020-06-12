# frozen_string_literal: true

class DownloadsController < ApplicationController
  before_action :admin
  def show
    respond_to do |format|
      format.pdf { send_user_pdf }

      format.html { render_sample_html } if Rails.env.development?
    end
  end

  private

  def admin
    redirect_to root_path unless signed_in? && current_user.is_admin?
  end

  def user
    User.all
  end

  def place
    Place.all
  end

  def fav_place
    FavPlace.all
  end

  def download
    Download.new(user, place, fav_place)
  end

  def send_user_pdf
    send_file download.to_pdf, download_attributes
  end

  def render_sample_html
    render download.render_attributes
  end

  def download_attributes
    {
      filename: download.filename,
      type: 'application/pdf',
      disposition: 'attachment'
    }
  end
end
