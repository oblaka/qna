module ApplicationHelper
  def collection_cache_key_for(model) # model must be :symbol
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def voting_cache_key(votable) # votable must be :symbol
    name = votable.class.name
    if signed_in?
      good = "#{policy(@question).good?}"
      shit = "#{policy(@question).shit?}"
      revoke = "#{policy(@question).revoke?}"
      "#{name}-#{votable.id}/voting-#{good}-#{shit}-#{revoke}-#{votable.updated_at}"
    else
      "#{name}-#{votable.id}/voting-false-false-false-#{votable.updated_at}"
    end
  end
end
