# frozen_string_literal: true

# rubocop:disable Rails/FilePath
class Download
  def initialize(user, place, fav_place)
    @user = user
    @place = place
    @fav_place = fav_place
  end

  def to_pdf
    kit = PDFKit.new(as_html)
    kit.to_file("#{Rails.root}/public/user.pdf")
  end

  def filename
    "Statistics #{Time.zone.now}.pdf"
  end

  def render_attributes
    {
      template: 'users/pdf',
      layout: 'user_pdf',
      locals: { user: user, place: place, fav_place: fav_place }
    }
  end

  private

  attr_reader :user, :place

  def as_html
    renderer = ::ActionController::Base.renderer.new
    renderer.render(template: 'users/pdf.html.erb',
                    layout: 'user_pdf.html.erb',
                    locals: { user: @user, place: @place, fav_place: @fav_place })
  end
end
# rubocop:enable Rails/FilePath
