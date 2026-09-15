# 1. Создание S3 Bucket
resource "aws_s3_bucket" "website" {
  bucket        = "cmtr-z53rb65y-bucket-1789493478"
  force_destroy = true
}

# 2. Настройка статического хостинга сайтов
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

# 3. Отключение блокировки публичного доступа
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Политика S3 bucket для разрешения публичного чтения
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website.id
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

