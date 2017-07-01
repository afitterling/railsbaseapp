class Image < ActiveRecord::Base
  belongs_to :log_datum

  has_attached_file :image

  validates_attachment_presence :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def image_url
    image.url
  end
end
