class Classification < ActiveRecord::Base
  has_many :boat_classifications
  has_many :boats, through: :boat_classifications

  def self.my_all
    self.all
  end

  def self.longest
    big_boat_id = Boat.order(length: :desc).limit(1).pluck(:id).first
    self.includes(:boats).where('boats.id = ?', big_boat_id)
  end
end
