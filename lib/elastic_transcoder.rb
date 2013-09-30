module ElasticTranscoder
  extend self

  def create_job content
    key         = content.object_key
    pipeline_id = Settings.aws.transcode.pipeline_id
    preset_id   = Settings.aws.transcode.preset_id

    client = AWS::ElasticTranscoder.new.client
    preset = client.read_preset(id: preset_id)
    key_prefix = key.sub(/#{File.extname(key)}$/, '')
    job = client.create_job(
      pipeline_id: pipeline_id,
      input: {
        key:          key,
        frame_rate:   'auto',
        resolution:   'auto',
        aspect_ratio: 'auto',
        interlaced:   'auto',
        container:    'auto',
      },
      output: {
        key:               "#{key_prefix}/#{preset[:preset][:id]}.#{preset[:preset][:container]}",
        thumbnail_pattern: "#{key_prefix}/thumbnail_{resolution}-{count}",
        rotate:            'auto',
        preset_id:         preset_id,
      }
    )
    { preset: preset[:preset], job: job[:job] }
  end
end
