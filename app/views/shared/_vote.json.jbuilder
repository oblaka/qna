@vote = @votable.reload.vote_for current_user

json.rating_id "#rating_#{@votable.class.name.downcase}_#{@votable.id}"
json.rating @votable.reload.rating
json.good_id "#good_#{@votable.class.name.downcase}_#{@votable.id}"
json.good signed_in? && current_user != @votable.user && @vote.new_record?
json.revoke_id "#revoke_#{@votable.class.name.downcase}_#{@votable.id}"
json.revoke signed_in? && current_user == @vote.user && @vote.persisted?
json.shit_id "#shit_#{@votable.class.name.downcase}_#{@votable.id}"
json.shit signed_in? && current_user != @votable.user && @vote.new_record?