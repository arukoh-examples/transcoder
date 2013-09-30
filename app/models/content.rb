class Content < ActiveRecord::Base
  attr_accessible :bucket, :link, :mime_type, :name, :object_key, :size

  has_one :transcode

  validates_presence_of :bucket, :name, :link, :object_key
  validates_uniqueness_of :object_key

  after_create  :start_transcode
  after_destroy :delete_object

  def download_url
#    AWS::S3.new.buckets[bucket].objects[object_key].url_for(:read).to_s
    "http://#{bucket}.s3.amazonaws.com/#{object_key}"
  end

  private

  require 'elastic_transcoder'
  def start_transcode
    response = ::ElasticTranscoder.create_job(self)
    Transcode.start self, response[:preset], response[:job]
  rescue => e
    logger.error e.message
    logger.error e.backtrace[0..5].join("\n")
  end

  def delete_object
    AWS::S3.new.buckets[bucket].objects[object_key].delete
  end
end
