class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password

  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items, -> { order('position asc') }
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"

  before_create :generate_token

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(a_user)
    following_relationships.map(&:leader).include?(a_user)
  end

  def can_follow?(a_leader)
    if follows?(a_leader) || self == a_leader
      false
    else
      true
    end
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end