require 'rails_helper'

shared_examples 'voting' do

  let( :votable_klass ) { described_class.controller_name.singularize.underscore.to_sym }
  let( :votable ) { create( votable_klass ) }

  describe 'POST #good' do

    context 'authorized user' do
      context 'vote neutral' do
        before do
          @vote = create(:vote, votable: votable, voter: user, rate: 0)
          sign_in user
        end
        it 'increases votable rating' do
          expect( votable.rating ).to eq 0
          expect { post :good, id: votable, format: :json }.to change(votable, :rating).by 1
        end
        it 'increases vote rate' do
          post :good, id: votable, format: :json
          expect { @vote.reload }.to change(@vote, :rate).by 1
        end
      end

      context 'vote already positive' do
        before do
          @vote = create(:vote, votable: votable, voter: user, rate: 1)
          sign_in user
        end
        it 'not increases votable rating' do
          expect { post :good, id: votable, format: :json }.to_not change(votable, :rating)
        end
        it 'not increases vote rate' do
          post :good, id: votable, format: :json
          expect { @vote.reload }.to_not change(@vote, :rate)
        end
      end

      context 'vote already negative' do
        before do
          @vote = create(:vote, votable: votable, voter: user, rate: -1)
          sign_in user
        end
        it 'increases votable rating' do
          expect( votable.rating ).to eq 0
          expect { post :good, id: votable, format: :json }.to change(votable, :rating).by 1
        end
        it 'increases vote rate' do
          post :good, id: votable, format: :json
          expect { @vote.reload }.to change(@vote, :rate).by 1
        end

        it 'increases votable rating twice' do
          expect( votable.rating ).to eq 0
          expect { post :good, id: votable, format: :json }.to change(votable, :rating).by 1
          expect { post :good, id: votable, format: :json }.to change(votable, :rating).by 1
        end
        it 'increases vote rate twice' do
          post :good, id: votable, format: :json
          post :good, id: votable, format: :json
          expect { @vote.reload }.to change(@vote, :rate).by 2
        end
      end

      it 'response ok' do
        sign_in user
        votable
        post :good, id: votable, format: :json
        expect( response ).to have_http_status( 200 )
      end
    end

    context 'votable author' do
      before do
        @vote = create(:vote, votable: votable, voter: votable.user, rate: 0)
        sign_in votable.user
      end

      it 'not increases votable rating' do
        expect { post :good, id: votable, format: :json }.to_not change(votable, :rating)
      end

      it 'not increases vote rate' do
        post :good, id: votable, format: :json
        expect { @vote.reload }.to_not change(@vote, :rate)
      end

      it 'response ok' do
        sign_in user
        votable
        post :good, id: votable, format: :json
        expect( response ).to have_http_status( 200 )
      end
    end

    context 'unauthorized user' do
      it 'response forbidden' do
        post :good, id: votable, format: :json
        expect( response ).to have_http_status( 401 )
      end

      it 'response forbidden' do
        post :good, id: votable, format: :json
        expect( response ).to have_http_status( 401 )
      end
    end
  end

  describe 'POST #shit' do

    context 'authorized user' do
      context 'vote neutral' do
        before do
          @vote = create(:vote, votable: votable, voter: user, rate: 0)
          sign_in user
        end

        it 'decreases votable rating' do
          expect( votable.rating ).to eq 0
          expect { post :shit, id: votable, format: :json }.to change(votable, :rating).by -1
        end

        it 'decreases vote rate' do
          post :shit, id: votable, format: :json
          expect { @vote.reload }.to change(@vote, :rate).by -1
        end
      end

      context 'vote already positive' do
        before do
          @vote = create(:vote, votable: votable, voter: user, rate: 1)
          sign_in user
        end

        it 'decreases votable rating' do
          expect { post :shit, id: votable, format: :json }.to change(votable, :rating).by -1
        end

        it 'decreases vote rate' do
          post :shit, id: votable, format: :json
          expect { @vote.reload }.to change(@vote, :rate).by -1
        end

        it 'decreases votable rating twice' do
          expect { post :shit, id: votable, format: :json }.to change(votable, :rating).by -1
          expect { post :shit, id: votable, format: :json }.to change(votable, :rating).by -1
        end

        it 'decreases vote rate twice' do
          post :shit, id: votable, format: :json
          post :shit, id: votable, format: :json
          expect { @vote.reload }.to change(@vote, :rate).by -2
        end
      end

      context 'vote already negative' do
        before do
          @vote = create(:vote, votable: votable, voter: user, rate: -1)
          sign_in user
        end

        it 'not decreases votable rating' do
          expect { post :shit, id: votable, format: :json }.to_not change(votable, :rating)
        end

        it 'not decreases vote rate' do
          post :shit, id: votable, format: :json
          expect { @vote.reload }.to_not change(@vote, :rate)
        end
      end

      it 'response ok' do
        sign_in user
        votable
        post :shit, id: votable, format: :json
        expect( response ).to have_http_status( 200 )
      end
    end

    context 'votable author' do
      before do
        @vote = create(:vote, votable: votable, voter: votable.user, rate: 0)
        sign_in votable.user
      end

      it 'not decreases votable rating' do
        expect { post :shit, id: votable, format: :json }.to_not change(votable, :rating)
      end

      it 'not decreases vote rate' do
        post :shit, id: votable, format: :json
        expect { @vote.reload }.to_not change(@vote, :rate)
      end

      it 'response ok' do
        sign_in user
        votable
        post :shit, id: votable, format: :json
        expect( response ).to have_http_status( 200 )
      end
    end

    context 'unauthorized user' do
      it 'response forbidden' do
        post :shit, id: votable, format: :json
        expect( response ).to have_http_status( 401 )
      end

      it 'response forbidden' do
        post :shit, id: votable, format: :json
        expect( response ).to have_http_status( 401 )
      end
    end
  end
end
