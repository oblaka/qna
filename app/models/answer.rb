class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :body, presence: true, length: { in: 17..512 }
  validates :question, :user, presence: true

  scope :best, -> { where(best: true) }
  scope :solution_first, -> { order(best: :desc) }

  def is_solution
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end
