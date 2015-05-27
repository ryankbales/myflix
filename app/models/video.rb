class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews
  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(title)
    if title
      return [] if title.blank?
      where("title LIKE ?", "%#{title}%").order("created_at DESC")
    else
      self.all
    end
  end

end