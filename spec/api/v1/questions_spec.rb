require 'rails_helper'

describe 'Questions API' do
  let( :user ) { create :user }
  let(:access_token ) { create :access_token, resource_owner_id: user.id }
  let!(:questions) { create_list :question, 3 }
  let!(:question) { questions.first }
  let!(:attach) { create :attachment, attachable: question }
  let!(:comment) { create :comment, commentable: question }
  let(:object_symbol) { :question }

  describe 'GET #index' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'api unauthorized'
    it_behaves_like 'api success'

    context 'authorized' do
      before { get api_path, format: :json, access_token: access_token.token }

      it 'returnes question collection' do
        expect(response.body).to have_json_size(3).at_path 'questions'
      end

      %w( id title body rating user_id created_at updated_at  ).each do |attr|
        it "contains #{attr} with correct value" do
          expect( response.body ).to be_json_eql( question.send( attr.to_sym ).to_json )
          .at_path( "questions/0/#{attr}" )
        end
      end

      context 'attachments' do
        it 'included in each question' do
          expect(response.body).to have_json_size(1).at_path('questions/0/attachments')
        end

        it 'contains name' do
          expect(response.body).to be_json_eql(attach.file.filename.to_json)
          .at_path('questions/0/attachments/0/name')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attach.file.url.to_json)
          .at_path('questions/0/attachments/0/url')
        end
      end

      context 'comments' do
        it 'included in each question' do
          expect(response.body).to have_json_size(1).at_path('questions/0/comments')
        end

        %w( id body user_id created_at updated_at  ).each do |attr|
          it "contains #{attr} with correct value" do
            expect( response.body ).to be_json_eql( comment.send( attr.to_sym ).to_json )
            .at_path( "questions/0/comments/0/#{attr}" )
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'api unauthorized'
    it_behaves_like 'api success'

    context 'authorized' do
      before { questions }
      before { do_request access_token: access_token.token }

      it 'contain question with comments' do
        expect( response.body ).to have_json_path( 'question/comments' )
      end

      context 'attachments' do
        it 'included in each answer' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'contains name' do
          expect(response.body).to be_json_eql(attach.file.filename.to_json)
          .at_path('question/attachments/0/name')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attach.file.url.to_json)
          .at_path('question/attachments/0/url')
        end
      end

      context 'comments' do
        it 'included in each question' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w( id body user_id created_at updated_at  ).each do |attr|
          it "contains #{attr} with correct value" do
            expect( response.body ).to be_json_eql( comment.send( attr.to_sym ).to_json )
            .at_path( "question/comments/0/#{attr}" )
          end
        end
      end
    end
  end

  describe 'GET #answers' do
    let(:answer) { create :answer, question: question }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'api unauthorized'
    it_behaves_like 'api success'


    context 'authorized' do
      let!(:ans_comment) { create :comment, commentable: answer }
      let!(:ans_attach) { create :attachment, attachable: answer }

      before { do_request access_token: access_token.token }

      it 'returnes answers collection' do
        expect(response.body).to have_json_size(1).at_path 'answers'
      end

      %w( id body best user_id created_at updated_at  ).each do |attr|
        it "contains #{attr} with correct value" do
          expect( response.body ).to be_json_eql( answer.send( attr.to_sym ).to_json )
          .at_path( "answers/0/#{attr}" )
        end
      end

      context 'attachments' do
        it 'included in each answer' do
          expect(response.body).to have_json_size(1).at_path('answers/0/attachments')
        end

        it 'contains name' do
          expect(response.body).to be_json_eql(ans_attach.file.filename.to_json)
          .at_path('answers/0/attachments/0/name')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(ans_attach.file.url.to_json)
          .at_path('answers/0/attachments/0/url')
        end
      end

      context 'comments' do
        it 'included in each question' do
          expect(response.body).to have_json_size(1).at_path('answers/0/comments')
        end

        %w( id body user_id created_at updated_at  ).each do |attr|
          it "contains #{attr} with correct value" do
            expect( response.body ).to be_json_eql( ans_comment.send( attr.to_sym ).to_json )
            .at_path( "answers/0/comments/0/#{attr}" )
          end
        end
      end
    end
  end

  describe 'POST #create' do
    let(:api_path) { '/api/v1/questions' }
    let(:channel) { channel = "/questions" }

    it_behaves_like 'api unprocessable'
    it_behaves_like 'api unauthorized'
    it_behaves_like 'api success'
    it_behaves_like 'api publishable'

    context 'authorized' do
      context 'valid params' do
        before do
          do_request access_token: access_token.token
        end

        it 'contain question with comments' do
          expect( response.body ).to have_json_path( 'question/comments' )
        end

        %w( id title body rating user_id created_at updated_at  ).each do |attr|
          it "contains #{attr} with correct value" do
            expect( response.body ).to be_json_eql( Question.last.send( attr.to_sym ).to_json )
            .at_path( "question/#{attr}" )
          end
        end
      end
    end

    def do_request(params={})
      post api_path, { question: attributes_for(:question), format: :json }.merge(params)
    end
  end

  def do_request(params={})
    get api_path, { format: :json }.merge(params)
  end
end
