% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dbhelpers.R
\name{listEnsDbs}
\alias{listEnsDbs}
\title{List EnsDb databases in a MariaDB/MySQL server}
\usage{
listEnsDbs(dbcon, host, port, user, pass)
}
\arguments{
\item{dbcon}{A \code{DBIConnection} object providing access to a
MariaDB/MySQL database. Either \code{dbcon} or all of the other
arguments have to be specified.}

\item{host}{Character specifying the host on which the MySQL server is
running.}

\item{port}{The port of the MariaDB/MySQL server (usually \code{3306}).}

\item{user}{The username for the MariaDB/MySQL server.}

\item{pass}{The password for the MariaDB/MySQL server.}
}
\value{
A \code{data.frame} listing the database names, organism name
    and Ensembl version of the EnsDb databases found on the server.
}
\description{
The \code{listEnsDbs} function lists EnsDb databases in a
MariaDB/MySQL server.
}
\details{
The use of this function requires the \code{RMariaDB} package
to be installed. In addition user credentials to access a MySQL server
(with already installed EnsDb databases), or with write access are required.
For the latter EnsDb databases can be added with the \code{\link{useMySQL}}
method. EnsDb databases in a MariaDB/MySQL server follow the same naming
conventions than EnsDb packages, with the exception that the name is all
lower case and that each \code{"."} is replaced by \code{"_"}.
}
\examples{
\dontrun{
library(RMariaDB)
dbcon <- dbConnect(MariaDB(), host = "localhost", user = my_user, pass = my_pass)
listEnsDbs(dbcon)
}
}
\seealso{
\code{\link{useMySQL}}
}
\author{
Johannes Rainer
}
