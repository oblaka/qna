require 'rails_helper'

shared_examples 'voting' do

  let( :votable_klass ) { described_class.controller_name.singularize.underscore.to_sym }
  let( :votable ) { create( votable_klass ) }

  describe 'POST #revoke' do

    context 'authorized user' do
      context 'on existing' do
        context 'good vote' do
          let(:vote) { create(:vote, votable: votable, rate: 1) }
          before { sign_in vote.user }
          it 'decreases votable rating' do
            post :revoke, id: votable, format: :json
            expect { votable.reload }.to change(votable, :rating).by -1
          end

          it 'delete vote from db' do
            expect { post :revoke, id: votable, format: :json }.to change(Vote, :count).by -1
          end
        end

        context 'shit vote' do
          let(:vote) { create(:vote, votable: votable, rate: -1) }
          before { sign_in vote.user }
          it 'increases votable rating' do
            post :revoke, id: votable, format: :json
            expect { votable.reload }.to change(votable, :rating).by 1
          end

          it 'delete vote from db' do
            expect { post :revoke, id: votable, format: :json }.to change(Vote, :count).by -1
          end
        end
      end

      context 'on builded vote' do
        before { sign_in user }
        it 'not change votes count in db' do
          expect { post :revoke, id: votable, format: :json }.to_not change(Vote, :count)
        end

        it 'not increases votable rating' do
          post :revoke, id: votable, format: :json
          expect { votable.reload }.to_not change(votable, :rating)
        end
      end
    end

    context 'unauthenticated user' do
      it 'response 401 unauthorized' do
        post :revoke, id: votable, format: :json
        expect( response ).to have_http_status( 401 )
      end

      it 'not change votes count in db' do
        expect { post :revoke, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'not increases votable rating' do
        post :revoke, id: votable, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end
    end
  end

  describe 'POST #good' do
    context 'authorized user' do
      context 'vote not yet exist' do
        before { sign_in user }
        it 'increases votable rating' do
          post :good, id: votable, format: :json
          expect { votable.reload }.to change(votable, :rating).by 1
        end
        it 'create vote in db' do
          expect { post :good, id: votable, format: :json }.to change(Vote, :count).by 1
        end
      end

      context 'vote already exists and positive' do
        before do
          create(:vote, votable: votable, user: user, rate: 1)
          sign_in user
        end

        it 'not increases votable rating' do
          post :good, id: votable, format: :json
          expect { votable.reload }.to_not change(votable, :rating)
        end

        it 'not change votes count in db' do
          expect { post :good, id: votable, format: :json }.to_not change(Vote, :count)
        end
      end

      context 'vote already exists and negative' do
        before do
          @vote = create(:vote, votable: votable, user: user, rate: -1)
          sign_in user
        end

        it 'not increases votable rating' do
          post :good, id: votable, format: :json
          expect { votable.reload }.to_not change(votable, :rating)
        end

        it 'not change votes count in db' do
          expect { post :good, id: votable, format: :json }.to_not change(Vote, :count)
        end

        it 'not increases vote rate' do
          post :good, id: votable, format: :json
          expect { @vote.reload }.to_not change(@vote, :rate)
        end
      end

      it 'response 200 ok' do
        sign_in user
        post :good, id: votable, format: :json
        expect( response ).to have_http_status( 200 )
      end
    end

    context 'votable author' do
      before { sign_in votable.user }

      it 'not increases votable rating' do
        post :good, id: votable, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end
      it 'not change votes count in db' do
        expect { post :good, id: votable, format: :json }.to_not change(Vote, :count)
      end
      it 'response 403 forbidden' do
        post :good, id: votable, format: :json
        expect( response ).to have_http_status( 403 )
      end
    end

    context 'unauthenticated user' do
      it 'not increases votable rating' do
        post :good, id: votable, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end
      it 'not change votes count in db' do
        expect { post :good, id: votable, format: :json }.to_not change(Vote, :count)
      end
      it 'response 401 unauthorized' do
        post :good, id: votable, format: :json
        expect( response ).to have_http_status( 401 )
      end
    end
  end

  describe 'POST #shit' do
    context 'authorized user' do
      context 'vote not yet exist' do
        before do
          sign_in user
        end
        it 'decreases votable rating' do
          post :shit, id: votable, format: :json
          expect { votable.reload }.to change(votable, :rating).by -1
        end
        it 'create vote in db' do
          expect { post :shit, id: votable, format: :json }.to change(Vote, :count).by 1
        end
      end

      context 'vote already exists and positive' do
        before do
          create(:vote, votable: votable, user: user, rate: 1)
          sign_in user
        end
        it 'not decreases votable rating' do
          post :shit, id: votable, format: :json
          expect { votable.reload }.to_not change(votable, :rating)
        end
        it 'not change votes count in db' do
          expect { post :shit, id: votable, format: :json }.to_not change(Vote, :count)
        end
      end

      context 'vote already exists and negative' do
        before do
          @vote = create(:vote, votable: votable, user: user, rate: -1)
          sign_in user
        end
        it 'not decreases votable rating' do
          post :shit, id: votable, format: :json
          expect { votable.reload }.to_not change(votable, :rating)
        end
        it 'not change votes count in db' do
          expect { post :shit, id: votable, format: :json }.to_not change(Vote, :count)
        end
        it 'not decreases vote rate' do
          post :shit, id: votable, format: :json
          expect { @vote.reload }.to_not change(@vote, :rate)
        end
      end

      it 'response 200 ok' do
        sign_in user
        post :shit, id: votable, format: :json
        expect( response ).to have_http_status( 200 )
      end
    end

    context 'votable author' do
      before do
        sign_in votable.user
      end
      it 'not decreases votable rating' do
        post :shit, id: votable, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end
      it 'not change votes count in db' do
        expect { post :shit, id: votable, format: :json }.to_not change(Vote, :count)
      end
      it 'response 403 forbidden' do
        post :shit, id: votable, format: :json
        expect( response ).to have_http_status( 403 )
      end
    end

    context 'unauthenticated user' do
      it 'not decreases votable rating' do
        post :shit, id: votable, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end
      it 'not change votes count in db' do
        expect { post :shit, id: votable, format: :json }.to_not change(Vote, :count)
      end
      it 'response 401 unauthorized' do
        post :shit, id: votable, format: :json
        expect( response ).to have_http_status( 401 )
      end
    end
  end
end
