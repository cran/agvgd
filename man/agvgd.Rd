% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/agvgd.R
\name{agvgd}
\alias{agvgd}
\title{Align-GVGD (A-GVGD)}
\usage{
agvgd(
  alignment,
  poi,
  sub,
  mode = c("recycle", "expand_grid"),
  sort = FALSE,
  keep_self = TRUE,
  digits = 2L
)
}
\arguments{
\item{alignment}{A character matrix or an alignment object obtained with
\code{\link[=read_alignment]{read_alignment()}}. Rows are expected to be sequences of single characters
(protein residues), and columns the alignment positions. The first row must
be the reference sequence, i.e. the sequence whose substitutions will be
evaluated against.}

\item{poi}{A whole number indicating the position of interest (POI).}

\item{sub}{A character vector of protein residue substitutions to be
classified. The amino acids must be provided as one-letter symbols.}

\item{mode}{If both \code{poi} and \code{sub} contain more than one element, \code{mode}
specifies how these two inputs are combined. If \code{mode = 'recycle'} the
shortest vector is recycled to match the length of the longest. If \code{mode = 'expand_grid'}, all combinations between elements of \code{poi} and \code{sub} are
combined.}

\item{sort}{Whether to sort the output by \code{gd}, or not. Default is \code{FALSE}.}

\item{keep_self}{Whether to keep those results in the output that correspond
to residues being the same in \code{ref} and \code{sub}. Default is \code{TRUE}. But it
will be useful to change it to \code{FALSE} if want to compare the results with
those provided by \url{http://agvgd.hci.utah.edu/} that filters them out.}

\item{digits}{Integer indicating the number of decimal places to be used in
rounding \code{gv} and \code{gd} values. Default is \code{2}. Note that the calculation of
the \code{prediction} variable won't be affected by rounding of \code{gv} and \code{gd},
as it is calculated prior to the rounding.}
}
\value{
A \link[tibble:tibble-package]{tibble} whose observations refer to the
combination alignment position and amino acid substitution; consists of
seven variables:
\describe{
\item{res}{Position of the amino acid residue in the reference protein
(first sequence in the alignment). This position corresponds to \code{poi} minus
the gaps in the alignment.}
\item{poi}{Position of interest, i.e. the alignment position at which the
amino acid substitution is being assessed.}
\item{ref}{Reference amino acid, i.e. the amino acid in the first sequence
of the alignment, at the position of interest.}
\item{sub}{Amino acid substitution being assessed.}
\item{gv}{Grantham variation score.}
\item{gd}{Grantham difference score.}
\item{prediction}{Predicted effect of the amino acid substitution. This is
classed as C0, C15, C25, C35, C45, C55, or C65, with C65 most likely to
interfere with function and C0 least likely.}
}
}
\description{
This function implements the Align-GVGD (A-GVGD) method described in
Tavtigian \emph{et al.} (2006).

A-GVGD combines multiple sequence alignment of orthologous sequences with the
Grantham distance to classify missense variants, i.e. to distinguish human
disease susceptibility missense changes from changes of little clinical
significance.

The biochemical variation at each alignment position is converted to a
Grantham Variation score (GV) and the difference between these properties and
those of the variant amino acid being assessed are calculated and a Grantham
Difference score generated (GD).  The predicted effect is classed as C0, C15,
C25, C35, C45, C55, or C65, with C65 most likely to interfere with function
and C0 least likely.
}
\examples{
# Read an alignment into R, e.g. the alignment for gene ATM.
alignment_ATM <- read_alignment(gene = 'ATM')

# Predict the impact of changing the first residue (Met) to a Serine (S).
agvgd(alignment = alignment_ATM, poi = 1, sub = 'S')

# `poi` can be a vector of positions, e.g., 3 thru 10, allow for prediction
# of multiple positions at once.
agvgd(alignment = alignment_ATM, poi = 3:10, sub = 'S')

# `poi` expects a position in the frame of reference of the alignment, i.e.
# an alignment position (a column index). However, if you know instead
# the residue position in the reference sequence (first sequence in the
# alignment), then you may use the function `res_to_poi()`
# to convert from residue position to alignment position.
#
# Example: The second residue in the reference sequence of the ATM alignment
# is a Serine, after a Methionine. In the alignment, there is a gap between
# the two residues, so the alignment is 3 but the residue position on the
# protein is 2.
(poi2 <- res_to_poi(alignment_ATM, 2))
agvgd(alignment = alignment_ATM, poi = poi2, sub = 'A')

# Because changes are context-dependent, i.e. they depend on the residue
# variation observed at a given alignment position, the same reference
# residue when replaced with the same substitution will in general have
# a different predicted impact.
agvgd(alignment = alignment_ATM, poi = 9:10, sub = 'S')

# Use the ancillary function `amino_acids()` to get a vector of one-letter
# residue substitutions if you want to quickly assess the impact of all
# possible substitutions.
agvgd(alignment = alignment_ATM, poi = 1, sub = amino_acids())

# Parameter `mode` gives you flexibility on how to combine `poi` and `sub`.
agvgd(alignment = alignment_ATM, poi = 3:4, sub = c('A', 'V'))

# Use 'expand_grid' for all combinations.
agvgd(alignment = alignment_ATM, poi = 3:4, sub = c('A', 'V'), mode = 'expand_grid')

}
\references{
\itemize{
\item Tavtigian, S.V., Deffenbaugh, A. M., Yin, L., Judkins, T., Scholl, T.,
Samollow, P.B., de Silva, D., Zharkikh, A., Thomas, A. \emph{Comprehensive
statistical study of 452 BRCA1 missense substitutions with classification of
eight recurrent substitutions as neutral}. Journal of Medical Genetics 43,
295--305 (2006). \doi{10.1136/jmg.2005.033878}.
\item Mathe, E., Olivier, M., Kato, S., Ishioka, C., Hainaut, P., Tavtigian, S.V.
\emph{Computational approaches for predicting the biological effect of p53
missense mutations: a comparison of three sequence analysis based methods}.
Nucleic Acids Research 34, 1317--1325 (2006). \doi{10.1093/nar/gkj518}.
}
}
