class VoteUserValidator < ActiveModel::Validator
  def validate(record)
    if record.user_id == record.votable&.user_id
      record.errors[:base] << "Author can not vote for his resource"
    end
  end
end
