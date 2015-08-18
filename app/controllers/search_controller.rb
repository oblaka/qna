class SearchController < ApplicationController
  SEARCHING_SOURCES = %w( Question Answer Comment User )

  def show
    @results = finder.search search_params[:query] unless search_params[:query].empty?
    @search = Search.new(search_params)
  end

  private

  def search_params
    params.require(:search).permit( :context, :query )
  end

  def finder
    if SEARCHING_SOURCES.include? search_params[:context]
      search_params[:context].constantize
    else
      ThinkingSphinx
    end
  end
end
