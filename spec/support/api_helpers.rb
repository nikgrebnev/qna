module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
    # pp @json
    # @json
  end
end