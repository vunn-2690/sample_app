class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, ->{order created_at: :desc}
  has_one_attached :image
  validates :content, presence: true, length: {maximum: Settings.length.max_140}
  validates :image, content_type: {
    in: Settings.format.img,
    message: t("users.micropost.must_valid_image")
  }, size: {
    less_than: Settings.bytes.less_5.megabytes,
    message: t("users.micropost.size_valid_image")
  }

  def display_image
    image.variant resize_to_limit: [
      Settings.size.limit_image_500,
      Settings.size.limit_image_500
    ]
  end
end
