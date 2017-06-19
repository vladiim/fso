extract.example <- function() {
  data(diamonds)
  write.csv(diamonds, 'data/example.csv')
}
