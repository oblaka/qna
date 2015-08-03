require 'rails_helper'

describe 'Answers API' do
  let( :user ) { create :user }
  let(:access_token ) { create :access_token, resource_owner_id: user.id }
  let!(:answers) { create_list :answer, 3 }
  let!(:answer) { answers.first }
  let(:question) { answer.question }
  let!(:comment) { create :comment, commentable: answer }
  let!(:attach) { create :attachment, attachable: answer }
  let(:object_symbol) { :answer }

  describe 'POST #create' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:channel) { channel = "/question/#{question.id}/answers" }

    it_behaves_like 'api unprocessable'
    it_behaves_like 'api unauthorized'
    it_behaves_like 'api success'
    it_behaves_like 'api publishable'

    context 'authorized' do
      context 'valid params' do
        before do
          do_request access_token: access_token.token
        end

        %w( id body best user_id created_at updated_at  ).each do |attr|
          it "contains #{attr} with correct value" do
            expect( response.body ).to be_json_eql( Answer.last.send( attr.to_sym ).to_json )
            .at_path( "answer/#{attr}" )
          end
        end
      end
    end

    def do_request(params={})
      post api_path, { answer: attributes_for(:answer), format: :json }.merge(params)
    end
  end

  describe 'GET #show' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'api unauthorized'
    it_behaves_like 'api success'

    context 'authorized' do
      before { answers }
      before { do_request access_token: access_token.token }

      it 'contain answer with comments' do
        expect( response.body ).to have_json_path( 'answer/comments' )
      end

      context 'attachments' do
        it 'included in each answer' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'contains name' do
          expect(response.body).to be_json_eql(attach.file.filename.to_json)
          .at_path('answer/attachments/0/name')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attach.file.url.to_json)
          .at_path('answer/attachments/0/url')
        end
      end

      context 'comments' do
        it 'included in each answer' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w( id body user_id created_at updated_at  ).each do |attr|
          it "contains #{attr} with correct value" do
            expect( response.body ).to be_json_eql( comment.send( attr.to_sym ).to_json )
            .at_path( "answer/comments/0/#{attr}" )
          end
        end
      end
    end

    def do_request(params={})
      get api_path, { format: :json }.merge(params)
    end
  end
end
