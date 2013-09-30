class Transcode < ActiveRecord::Base
  attr_accessible :bucket, :content_id, :created_at, :job_id, :object_key, :preset_detail, :preset_id, :thumbnail_key_prefix

  def download_url
#    AWS::S3.new.buckets[bucket].objects[object_key].url_for(:read).to_s
    AWS::S3.new.buckets[bucket].objects[object_key].acl = :public_read
    "http://#{bucket}.s3.amazonaws.com/#{object_key}"
  end

  def thumbnail_urls
    AWS::S3.new.buckets[bucket].objects.with_prefix(thumbnail_key_prefix).map do |o|
      o.acl = :public_read
      o.url_for(:read).to_s
    end
  end

  def properties
    AWS::S3.new.buckets[bucket].objects[object_key].head
  end

  def self.start content, preset, job
    thumbnail_pattern = job[:output][:thumbnail_pattern]
    Transcode.create!(
      content_id:           content.id,
      job_id:               job[:id],
      preset_id:            preset[:id],
      preset_detail:        preset.to_json,
      bucket:               Settings.aws.encoded.bucket,
      object_key:           job[:output][:key],
      thumbnail_key_prefix: thumbnail_pattern[0..(thumbnail_pattern.index("{resolution}-{count}")-1)] #TODO
    )
  end
end
