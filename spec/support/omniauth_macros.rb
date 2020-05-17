module OmniauthMacros
  def mock_auth_hash_github
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = {
        'provider' => 'github',
        'uid' => '123545',
        'info' => {
            'email' => 'test@test.com'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
    }
  end
  def mock_auth_hash_google_oauth2
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:google_oauth2] = {
        'provider' => 'google_oauth2',
        'uid' => '123545',
        'info' => {
            'email' => 'test@test.com'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
    }
  end
  def mock_auth_hash_vkontakte
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:vkontakte] = {
        'provider' => 'vkontakte',
        'uid' => '123545',
        'info' => {
            'email' => 'test@test.com'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
    }
  end
  def mock_auth_hash_facebook
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:facebook] = {
        'provider' => 'facebook',
        'uid' => '123545',
        'info' => {
            'email' => 'test@test.com'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
    }
  end
end