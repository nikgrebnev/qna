shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq(401).or eq(403)
      expect(response.body).to be_empty
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '111' }, headers: headers)
      expect(response.status).to eq(401).or eq(403)
      expect(response.body).to be_empty
    end
  end
end

shared_examples_for 'Status OK' do
  it 'returns status OK' do
    request
    expect(response).to be_successful
  end
end

shared_examples_for 'Check public fields' do
  it 'check fields list' do
    request
    fields.each do |attr|
      expect(resource_response[attr]).to eq reference.send(attr).as_json
    end
  end
end
