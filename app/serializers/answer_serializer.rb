class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :best, :body, :user_id, :created_at, :updated_at
  has_many :comments
  has_many :attachments
end
