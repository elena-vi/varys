class Result

  attr_reader :title, :url, :description

  def initialize(params = {})
    @title = params.fetch(:title, '')
    @url = params.fetch(:url, '')
    @description = params.fetch(:description, '')
  end
end
