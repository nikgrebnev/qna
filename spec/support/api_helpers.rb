module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
    pp @json
    @json
  end

  def do_request(method, path, options = {})
    send method, path, options
  end
end