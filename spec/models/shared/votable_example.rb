require 'rails_helper'

shared_examples 'votable' do

  it { should have_many(:votes).dependent(:delete_all) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  let(:users) { create_list(:user, 3) }

  describe '#good' do
    context 'not voted yet' do
      it 'create vote in db' do
        expect { votable.vote_good_by user }.to change(Vote, :count).by 1
      end
      it 'increases votable rating' do
        expect { votable.vote_good_by user;
                 votable.reload }.to change(votable, :rating).by 1
      end
    end
    context 'already voted' do
      before { votable.vote_good_by user;
               votable.reload }
      it 'not change votes count in db' do
        expect { votable.vote_good_by user }.to_not change(Vote, :count)
      end
      it 'not change votable rating' do
        expect { votable.vote_good_by user;
                 votable.reload }.to_not change(votable, :rating)
      end
    end
  end
  describe '#shit' do
    context 'not voted yet' do
      it 'create vote in db' do
        expect { votable.vote_shit_by user }.to change(Vote, :count).by 1
      end
      it 'decreases votable rating' do
        expect { votable.vote_shit_by user;
                 votable.reload }.to change(votable, :rating).by -1
      end
    end
    context 'already voted' do
      before { votable.vote_shit_by user;
               votable.reload }
      it 'not change votes count in db' do
        expect { votable.vote_shit_by user }.to_not change(Vote, :count)
      end
      it 'not change votable rating' do
        expect { votable.vote_shit_by user;
                 votable.reload }.to_not change(votable, :rating)
      end
    end
  end
  describe '#revoke' do
    context 'not voted yet' do
      it 'not change votes count in db' do
        expect { votable.vote_revoke_by user }.to_not change(Vote, :count)
      end
      it 'not change votable rating' do
        expect { votable.vote_revoke_by user;
                 votable.reload }.to_not change(votable, :rating)
      end
    end
    context 'already voted' do
      context 'good' do
        before { votable.vote_good_by user;
                 votable.reload }
        it 'delete vote from db' do
          expect { votable.vote_revoke_by user }.to change(Vote, :count).by -1
        end
        it 'decreases votable rating' do
          expect { votable.vote_revoke_by user;
                   votable.reload }.to change(votable, :rating).by -1
        end
      end
      context 'shit' do
        before { votable.vote_shit_by user;
                 votable.reload }
        it 'delete vote from db' do
          expect { votable.vote_revoke_by user }.to change(Vote, :count).by -1
        end
        it 'increases votable rating' do
          expect { votable.vote_revoke_by user;
                   votable.reload }.to change(votable, :rating).by 1
        end
      end
    end
  end

  describe '#vote_for' do
    it 'find or initialize vote for user' do
      vote = votable.vote_for user
      expect(vote.user).to eq(user)
    end
  end

  describe '#rating' do
    it 'return votable rating' do
      users.each do |u|
        votable.vote_good_by(u)
      end
      votable.reload
      expect(votable.rating).to eq(3)
    end
  end

end
