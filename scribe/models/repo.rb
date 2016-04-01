class Repo
	
  attr_accessor :path, :status, :branch, :docs_dir, :status_report

  @status
  @path
  @branch
  @docs_dir
  @staus_report

  def initialize path
    @path = path
    @status_report = ""
  end

end