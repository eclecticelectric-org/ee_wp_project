#!/usr/bin/env sh

AWS=/usr/local/bin/aws
LOCAL_UPLOADS=PATH_TO_LOCAL_UPLOADS_DIR
AWS_S3_BUCKET=s3://AWS_S3_BUCKET_URI

current_time=$(date "+%Y-%m-%d:%H.%M.%S")
# sync local uploads to S3 
echo "[$current_time] PROJECT_NAME sync $LOCAL_UPLOADS to $AWS_S3_BUCKET"
$AWS s3 sync "$LOCAL_UPLOADS" $AWS_S3_BUCKET
