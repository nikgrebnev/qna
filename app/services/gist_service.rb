class GistQuestionService

# c = GistQuestionService.new(Question.first, User.first).call
# JSON.parse(c.body)["html_url"]

#c=Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
#g=c.gist('743f9367caa1039874af5a2244e1b44c')
#g.files.first[1][:content]
# => "puts 'Hello, world!\""
#g.url
# => "https://api.github.com/gists/743f9367caa1039874af5a2244e1b44c"

def initialize(client: nil)
    @client = client || Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end

  def call(gist_id)
    resource = @client.gist(gist_id)
    resource.files.first[1][:content]
  end
end