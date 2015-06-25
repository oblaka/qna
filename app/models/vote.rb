class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :voter, polymorphic: true

  validates :votable, :voter, presence: true

  delegate :rating, to: :votable

  def increase
    if rate < 1
      transaction do
        self.increment! :rate
        overall.increment! :rate
      end
    else
      false
    end
  end

  def decrease
    if rate > -1
      transaction do
        self.decrement! :rate
        overall.decrement! :rate
      end
    else
      false
    end
  end

  def rating
    overall.rate
  end

  protected

  def overall
    Vote.find_or_initialize_by(votable: votable, voter: votable)
  end

end
