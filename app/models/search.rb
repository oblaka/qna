class Search
  include ActiveModel::AttributeMethods
  include ActiveModel::Model

  attr_accessor :query, :context

  def self.context_list
    %w( Everywhere Question Answer Comment User )
  end
end
