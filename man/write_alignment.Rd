% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_alignment.R
\name{write_alignment}
\alias{write_alignment}
\title{Export an alignment to FASTA}
\usage{
write_alignment(alignment, file)
}
\arguments{
\item{alignment}{An alignment. It may be a simple matrix or an object
obtained with \code{read_alignment()}.}

\item{file}{A file path.}
}
\value{
This function is run for its side effect of writing a file. But it
returns the file path passed in \code{file}.
}
\description{
This function takes an alignment and exports it to a FASTA file.
}
\examples{
\dontshow{
.old_wd <- setwd(tempdir())
}
alignment <- matrix(
  c('P', 'M', 'I',
    'P', 'I', 'I',
    'P', 'L', 'I'),
  nrow = 3,
  byrow = TRUE
)

# Export an alignment based on a matrix
write_alignment(alignment, "my_alignment.fasta")
cat(readLines("my_alignment.fasta"), sep = "\n")

# Export one of the bundled alignments
write_alignment(read_alignment(gene = 'BRCA1'), "BRCA1.fasta")
cat(readLines("BRCA1.fasta")[1:10], sep = "\n")

\dontshow{
setwd(.old_wd)
}
}
