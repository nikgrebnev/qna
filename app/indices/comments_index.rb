ThinkingSphinx::Index.define :comment, with: :active_record do
  # indexed fields
  indexes body
  indexes user.email, as: :author, sortable: true

  # attributes
  has user_id, created_at, updated_at
end
