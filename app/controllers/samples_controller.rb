require 'filters/sample_filter'

class SamplesController < ApplicationController
  def index
    @filter = Pigeon::Filters::SampleFilter.new params[:filter]
    samples = Sample.where(:issue_id => Issue.viewable(claims))
    @current_page, @page_size, @samples = @filter.paginate(@filter.filter(samples), params[:p])
  end
end
