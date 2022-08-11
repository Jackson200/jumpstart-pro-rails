namespace :active_storage do
  desc "Purges orphaned unattached blobs from ActiveStorage. Run this regularly."
  task cleanup: :environment do
    ActiveStorage::Blob.unattached.where("active_storage_blobs.created_at <= ?", 2.days.ago).each do |blob|
      blob.purge_later
    end
  end
end
