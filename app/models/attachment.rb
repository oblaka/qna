class Attachment < ActiveRecord::Base

  mount_uploader :file, FileUploader

  belongs_to :attachable, polymorphic: true

  validates :file, presence: true

  delegate :identifier, :url, to: :file

  def title
    file.identifier unless file.nil?
  end

end
