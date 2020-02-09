class GistService

  def initialize(client: nil)
    @client = client || Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end

  def call(gist_id)
    resource = @client.gist(gist_id)
    resource.files.first[1][:content]
  end
end