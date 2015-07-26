@votable.reload.vote_for current_user

json.rating_id "#rating_#{@votable.class.name.downcase}_#{@votable.id}"
json.rating @votable.reload.rating
json.good_id "#good_#{@votable.class.name.downcase}_#{@votable.id}"
json.good policy(@votable).good?
json.revoke_id "#revoke_#{@votable.class.name.downcase}_#{@votable.id}"
json.revoke policy(@votable).revoke?
json.shit_id "#shit_#{@votable.class.name.downcase}_#{@votable.id}"
json.shit policy(@votable).shit?
