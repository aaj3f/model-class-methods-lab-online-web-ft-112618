class Captain < ActiveRecord::Base
  has_many :boats
  # has_many :classifications, through: :boats
  # has_many :boat_classifications, through: :boats
  # has_many :classifications, through: :boat_classifications

  def self.catamaran_operators
    boats_names = Boat.includes(:classifications).where('classifications.name = ?', 'Catamaran').pluck(:name).uniq
    self.includes(:boats).where(boats: {name: boats_names}).distinct
  end

  def self.sailors
    boats_names = Boat.includes(:classifications).where('classifications.name = ?', 'Sailboat').pluck(:name).uniq
    self.includes(:boats).where(boats: {name: boats_names}).distinct
  end

  def self.talented_seafarers
    where("name in (?)", self.sailors.pluck(:name) & self.includes(boats: :classifications).where(classifications: { name: "Motorboat"}).pluck(:name))
  end

  def self.non_sailors
    self.where.not("name in (?)", self.sailors.pluck(:name))
  end
end
