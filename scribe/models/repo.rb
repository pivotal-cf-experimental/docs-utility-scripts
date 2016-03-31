class Repo
	
  attr_accessor :path, :status, :branch, :docs_dir

  @status
  @path
  @branch
  @docs_dir

  def initialize path
    @path = path
  end

end