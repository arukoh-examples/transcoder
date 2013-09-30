module ContentsHelper
  def upload_params
    acl                   = 'public-read'#'private'
    success_action_status = 201
    policy = upload_policy(acl, success_action_status)
    {
      "key"                   => "${filename}",
      "AWSAccessKeyId"        => "#{Settings.aws.access_key_id}",
      "acl"                   => "#{acl}",
      "policy"                => "#{policy}",
      "signature"             => "#{signature(Settings.aws.secret_access_key, policy)}",
      "success_action_status" => "#{success_action_status}"
    }
  end

  def upload_url
    "http://#{Settings.aws.upload.bucket}.s3.amazonaws.com/"
  end

  private

  EXPIRATION_FORMAT = '%Y-%m-%dT%H:%M:%S.000Z'

  def upload_policy acl, success_action_status
    policy = "{
      'expiration': '#{Settings.aws.upload.expires.to_f.from_now.utc.strftime EXPIRATION_FORMAT}',
      'conditions': [
        {'bucket': '#{Settings.aws.upload.bucket}'},
        ['starts-with', '$key', ''],
        {'acl': '#{acl}'},
        {'success_action_status': '#{success_action_status}'},
        ['starts-with', '$Filename', ''],
        ['content-length-range', 0, #{Settings.aws.upload.max_filesize}]
      ]
    }"
    Base64.encode64(policy).gsub(/\n|\r/, '') 
  end

  def signature secret_access_key, policy
    signed = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_access_key, policy)
    Base64.encode64(signed).gsub("\n","")  
  end
end
