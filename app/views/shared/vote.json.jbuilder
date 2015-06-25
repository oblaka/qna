json.rating_id "#rating_#{@vote.votable.class.name.downcase}_#{@vote.votable.id}"
json.rating @vote.rating
json.good_id "#good_#{@vote.votable.class.name.downcase}_#{@vote.votable.id}"
json.good signed_in? && current_user != @vote.votable.user && @vote.rate < 1
json.shit_id "#shit_#{@vote.votable.class.name.downcase}_#{@vote.votable.id}"
json.shit signed_in? && current_user != @vote.votable.user && @vote.rate > -1