\name{select}
\Rdversion{1.1}
\alias{select}
\alias{select,EnsDb-method}
\alias{columns,EnsDb-method}
\alias{keys,EnsDb-method}
\alias{keytypes,EnsDb-method}
\alias{mapIds,EnsDb-method}

\title{Integration into the AnnotationDbi framework}
\description{
  Several of the methods available for \code{AnnotationDbi} objects are
  also implemented for \code{EnsDb} objects. This enables to extract
  data from \code{EnsDb} objects in a similar fashion than from objects
  inheriting from the base annotation package class
  \code{AnnotationDbi}.
  In addition to the \emph{standard} usage, the \code{select} and
  \code{mapIds} for \code{EnsDb} objects support also the filter
  framework of the ensembdb package and thus allow to perform more
  fine-grained queries to retrieve data.
}
\usage{

\S4method{columns}{EnsDb}(x)
\S4method{keys}{EnsDb}(x, keytype, filter,...)
\S4method{keytypes}{EnsDb}(x)
\S4method{mapIds}{EnsDb}(x, keys, column, keytype, ..., multiVals)
\S4method{select}{EnsDb}(x, keys, columns, keytype, ...)

}
\arguments{

  (In alphabetic order)

  \item{column}{
    For \code{mapIds}: the column to search on, i.e. from which values
    should be retrieved.
  }

  \item{columns}{
    For \code{select}: the columns from which values should be
    retrieved. Use the \code{columns} method to list all possible
    columns.
  }

  \item{keys}{
    The keys/ids for which data should be retrieved from the
    database. This can be either a character vector of keys/IDs, a
    single filter object extending
    \code{\link[AnnotationFilter]{AnnotationFilter}}, an combination of
    filters \code{\link[AnnotationFilter]{AnnotationFilterList}} or a
    \code{formula} representing a filter expression (see
    \code{\link[AnnotationFilter]{AnnotationFilter}} for more details).
  }

  \item{keytype}{
    For \code{mapIds} and \code{select}: the type (column) that matches
    the provided keys. This argument does not have to be specified if
    argument \code{keys} is a filter object extending
    \code{AnnotationFilter} or a \code{list} of such objects.

    For \code{keys}: which keys should be returned from the database.
  }

  \item{filter}{
    For \code{keys}: either a single object extending
    \code{AnnotationFilter} or a list of such object to
    retrieve only specific keys from the database.
  }

  \item{multiVals}{
    What should \code{mapIds} do when there are multiple values that
    could be returned? Options are: \code{"first"} (default), \code{"list"},
    \code{"filter"}, \code{"asNA"}. See
    \code{mapIds} in the \code{AnnotationDbi} package  
    for a detailed description.
  }

  \item{x}{
    The \code{EnsDb} object.
  }

  \item{...}{
    Not used.
  }

}
\section{Methods and Functions}{
  \describe{

    \item{columns}{
      List all the columns that can be retrieved by the \code{mapIds}
      and \code{select} methods. Note that these column names are
      different from the ones supported by the \code{\link{genes}},
      \code{\link{transcripts}} etc. methods that can be listed by the
      \code{\link{listColumns}} method.

      Returns a character vector of supported column names.
    }

    \item{keys}{
      Retrieves all keys from the column name specified with
      \code{keytype}. By default (if \code{keytype} is not provided) it
      returns all gene IDs. Note that \code{keytype="TXNAME"} will
      return transcript ids, since no transcript names are available in
      the database.

      Returns a character vector of IDs.
    }

    \item{keytypes}{
      List all supported key types (column names).

      Returns a character vector of key types.
    }

    \item{mapIds}{
      Retrieve the mapped ids for a set of keys that are of a particular
      keytype. Argument \code{keys} can be either a character vector of
      keys/IDs, a single filter object extending
      \code{AnnotationFilter} or a list of such objects. For
      the latter, the argument \code{keytype} does not have to be
      specified. Importantly however, if the filtering system is used,
      the ordering of the results might not represent the ordering of
      the keys.

      The method usually returns a named character vector or, depending
      on the argument \code{multiVals} a named list, with names
      corresponding to the keys (same ordering is only guaranteed if
      \code{keys} is a character vector).
    }

    \item{select}{
      Retrieve the data as a \code{data.frame} based on parameters for
      selected \code{keys}, \code{columns} and \code{keytype}
      arguments. Multiple matches of the keys are returned in one row
      for each possible match. Argument \code{keys} can be either a
      character vector of keys/IDs, a single filter object extending
      \code{AnnotationFilter} or a list of such objects. For
      the latter, the argument \code{keytype} does not have to be
      specified.

      Note that values from a column \code{"TXNAME"} will be the same
      than for a column \code{"TXID"}, since internally no database
      column \code{"tx_name"} is present and the column is thus mapped
      to \code{"tx_id"}.

      Returns a \code{data.frame} with the column names corresponding to
      the argument \code{columns} and rows with all data matching the
      criteria specified with \code{keys}.

      The use of \code{select} without filters or keys and without
      restricting to specicic columns is strongly discouraged, as the
      SQL query to join all of the tables, especially if protein
      annotation data is available is very expensive.
    }

  }
}

\value{
  See method description above.
}
\author{
  Johannes Rainer
}
\seealso{
  \code{\link{listColumns}}
  \code{\link{transcripts}}
}
\examples{

library(EnsDb.Hsapiens.v86)
edb <- EnsDb.Hsapiens.v86

## List all supported keytypes.
keytypes(edb)

## List all supported columns for the select and mapIds methods.
columns(edb)

## List /real/ database column names.
listColumns(edb)

## Retrieve all keys corresponding to transcript ids.
txids <- keys(edb, keytype = "TXID")
length(txids)
head(txids)

## Retrieve all keys corresponding to gene names of genes encoded on chromosome X
gids <- keys(edb, keytype = "GENENAME", filter = SeqNameFilter("X"))
length(gids)
head(gids)

## Get a mapping of the genes BCL2 and BCL2L11 to all of their
## transcript ids and return the result as list
maps <- mapIds(edb, keys = c("BCL2", "BCL2L11"), column = "TXID",
               keytype = "GENENAME", multiVals = "list")
maps

## Perform the same query using a combination of a GeneNameFilter and a
## TxBiotypeFilter to just retrieve protein coding transcripts for these
## two genes.
mapIds(edb, keys = list(GeneNameFilter(c("BCL2", "BCL2L11")),
                        TxBiotypeFilter("protein_coding")), column = "TXID",
       multiVals = "list")

## select:
## Retrieve all transcript and gene related information for the above example.
select(edb, keys = list(GeneNameFilter(c("BCL2", "BCL2L11")),
                        TxBiotypeFilter("protein_coding")),
       columns = c("GENEID", "GENENAME", "TXID", "TXBIOTYPE", "TXSEQSTART",
                   "TXSEQEND", "SEQNAME", "SEQSTRAND"))

## Get all data for genes encoded on chromosome Y
Y <- select(edb, keys = "Y", keytype = "SEQNAME")
head(Y)
nrow(Y)

## Get selected columns for all lincRNAs encoded on chromosome Y. Here we use
## a filter expression to define what data to retrieve.
Y <- select(edb, keys = ~ seq_name == "Y" & gene_biotype == "lincRNA",
            columns = c("GENEID", "GENEBIOTYPE", "TXID", "GENENAME"))
head(Y)
nrow(Y)

}
\keyword{classes}





