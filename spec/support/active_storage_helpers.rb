module ActiveStorageHelpers
  def create_file(file)
    ActiveStorage::Blob.create_after_upload! io: File.open("#{Rails.root}/#{file}"), filename: "#{file}", content_type: 'text/plain'
  end
end