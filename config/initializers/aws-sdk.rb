Aws.config.update(
  credentials: Aws::Credentials.new(ENV['S3_ACCESS_KEY'], ENV['S3_SECRET_KEY']),
  region: 'us-east-1',
)