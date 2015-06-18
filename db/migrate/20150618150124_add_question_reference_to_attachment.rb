class AddQuestionReferenceToAttachment < ActiveRecord::Migration
  def change
    add_reference :attachments, :question, index: true, foreign_key: true
  end
end
