require 'rails_helper'

describe 'Answers API' do
  let( :user ) { create :user }
  let(:access_token ) { create :access_token, resource_owner_id: user.id }
  let!(:answers) { create_list :answer, 3 }
  let!(:answer) { answers.first }
  let(:question) { answer.question }
  let!(:comment) { create :comment, commentable: answer }
  let!(:attach) { create :attachment, attachable: answer }

  describe 'GET #index' do
  end

  describe 'POST #create' do
    let(:url) { "/api/v1/questions/#{question.id}/answers" }
    context 'unauthorized' do
      it 'returnes 401 if no access_token' do
        post url, answer: attributes_for(:answer), format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returnes 401 if invalid access_token' do
        post url, answer: attributes_for(:answer), format: :json, access_token: 'someshit'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized' do
      context 'valid params' do
        before do
          post url, format: :json, access_token: access_token.token,
                    answer: attributes_for(:answer)
        end

        it 'returnes 200' do
          expect( response ).to be_success
        end

        %w( id body best user_id created_at updated_at  ).each do |attr|
          it "contains #{attr} with correct value" do
            expect( response.body ).to be_json_eql( Answer.last.send( attr.to_sym ).to_json )
              .at_path( "answer/#{attr}" )
          end
        end
      end

      context 'invalid params' do
        before do
          post url, format: :json, access_token: access_token.token,
                    answer: { body: nil }
        end

        it 'returnes 422' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'contain errors ' do
          expect( response.body ).to have_json_path( 'errors/body' )
        end
      end
    end
  end

  describe 'GET #show' do
    let(:url) { "/api/v1/answers/#{answer.id}" }
    context 'unauthorized' do
      it 'returnes 401 if no access_token' do
        get url, format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returnes 401 if invalid access_token' do
        get url, format: :json, access_token: 'someshit'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized' do
      before { answers }
      before { get url, format: :json, access_token: access_token.token }

      it 'returnes 200' do
        expect( response ).to be_success
      end

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
  end
end
