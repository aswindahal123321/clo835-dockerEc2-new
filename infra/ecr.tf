resource "aws_ecr_repository" "app" {
  name = var.app_repo
}

resource "aws_ecr_repository" "db" {
  name = var.db_repo
}
