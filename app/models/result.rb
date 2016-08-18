class Result

  attr_reader   :id, :title, :url, :description, :clicks
  attr_accessor :rank

  def initialize(params)
    @id = params.fetch(:id, 0)
    @title = params.fetch(:title, "")
    @url = params.fetch(:url, "")
    @description = params.fetch(:description, "")
    @rank = params.fetch(:rank, 0)
    @clicks = params.fetch(:clicks, 0)
  end

end
