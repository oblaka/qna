class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :body, :title, :rating, :user_id, :created_at, :updated_at
  has_many :comments
  has_many :attachments
end
