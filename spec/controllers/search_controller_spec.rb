require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:answer) { create :answer }
  let(:comment) { create :comment, body: 'unique query and bla-bla-bla' }
  let(:question) { create :question, body: 'unique query and bla-bla-bla' }

  describe 'get #show' do
    context 'search everywhere' do
      it 'assign found objects to @result' do
        expect(ThinkingSphinx).to receive(:search)
          .with('unique query')
          .and_return( [question, comment] )
        xhr :get, :show, search: { context: 'Any', query: 'unique query' }, format: :js
        expect(assigns(:results)).to match_array [question, comment]
      end
    end

    %w( Question Answer Comment User ).each do |klass|
      context "search in #{klass.downcase.pluralize}" do
        let!(:subject) { create klass.downcase.to_sym }
        it "assign found #{klass.downcase.pluralize} to @result" do
          expect( subject.class ).to receive(:search)
            .with('unique query')
            .and_return( [subject] )
          xhr :get, :show, format: :js, search: { context: klass, query: 'unique query' }
          expect(assigns(:results)).to match_array [subject]
        end
      end
    end
  end
end
