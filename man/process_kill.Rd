% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kill.R
\name{process_kill}
\alias{process_kill}
\title{Kill a process}
\usage{
process_kill(self, private, grace)
}
\arguments{
\item{self}{this}

\item{private}{this.private}

\item{grace}{Numeric scalar, grace period between sending a TERM
  and a KILL signal, in seconds.

The process might not be running any more, but \code{tools::pskill}
does not seem to care about whether it could actually kill the
process or not. To be sure, that this workds on all platforms,
we put it in a `tryCatch()`

A killed process can be restarted.}
}
\description{
Kill a process
}
\keyword{internal}

