module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', "User #{current_user&.id} #{current_user&.email}"
    end

    def disconnect
    end

    protected

    def find_verified_user
      if verified_user = env['warden'].user
        verified_user
=begin
      else
        reject_unauthorized_connection
=end
      end
    end
  end
end
