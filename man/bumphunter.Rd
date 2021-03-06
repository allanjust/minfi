\name{bumphunter-methods}
\docType{methods}
\alias{bumphunter,GenomicRatioSet-method}

\title{Methods for function \code{bumphunter} in Package \pkg{minfi}}

\description{
  Estimate regions for which a genomic profile deviates from its baseline
  value. Originally implemented to detect differentially methylated
  genomic regions between two populations, but can be applied to any CpG-level 
  coefficient of interest.
  
}
\usage{
\S4method{bumphunter}{GenomicRatioSet}(object, design, cluster=NULL,
          coef=2,  cutoff=NULL, pickCutoff=FALSE, pickCutoffQ=0.99, 
          maxGap=500,  nullMethod=c("permutation","bootstrap"),
          smooth=FALSE, smoothFunction=locfitByCluster,
          useWeights=FALSE,   B=ncol(permutations), permutations=NULL,
          verbose=TRUE, type = c("Beta","M"), \dots)
}

\arguments{
  \item{object}{An object of class GenomicRatioSet.}
  \item{design}{Design matrix with rows representing samples and columns
    representing covariates. Regression is applied to each row of mat.}
  \item{cluster}{The clusters of locations that are to be analyzed
    together.  In the case of microarrays, the clusters are many times
    supplied by the manufacturer. If not available the function
    \code{\link{clusterMaker}} can be used to cluster nearby locations.}
  \item{coef}{An integer denoting the column of the design matrix
    containing the covariate of interest. The hunt for bumps will be
    only be done for the estimate of this coefficient.}
  \item{cutoff}{A numeric value. Values of the estimate of the genomic
    profile above the cutoff or below the negative of the cutoff will be
    used as candidate regions.  It is possible to give two separate
    values (upper and lower bounds).  If one value is given, the lower
    bound is minus the value.}
  \item{pickCutoff}{Should bumphunter attempt to pick a cutoff using the
    permutation distribution?}
  \item{pickCutoffQ}{The quantile used for picking the cutoff using the
    permutation distribution.}
  \item{maxGap}{ If cluster is not provided this maximum location gap
    will be used to define cluster via the  \code{\link{clusterMaker}}
    function.}
  \item{nullMethod}{
    Method used to generate null candidate regions, must be one of \sQuote{boots
      trap} or
    \sQuote{permutation} (defaults to \sQuote{permutation}).
    However, if covariates in addition to the 
    outcome of interest are included in the design matrix
    (ncol(design)>2), the \sQuote{permutation} approach is not
    recommended. See vignette and original paper for more information.}
  \item{smooth}{
    A logical value. If TRUE the estimated profile will be smoothed with the
    smoother defined by \code{smoothFunction}}
  \item{smoothFunction}{
    A function to be used for smoothing the estimate of the genomic
    profile. Two functions are provided by the package: \code{loessByCluster}
    and \code{runmedByCluster}.}
  \item{useWeights}{
    A logical value. If \code{TRUE} then the standard errors of the
   point-wise estimates of the profile function will be used as weights
   in the loess smoother \code{loessByCluster}. If the 
   \code{runmedByCluster} smoother is used this argument is ignored.}
\item{B}{An integer denoting the number of resamples to use when computing
   null distributions. This defaults to 0. If \code{permutations} is
  supplied that defines the number of permutations/bootstraps and \code{B} is
  ignored.}
\item{permutations}{ is a matrix with columns providing indexes to be used to
  scramble the data and create a null distribution when
  \code{nullMethod} is set to  permutations. If the bootstrap approach is used this argument is
  ignored. If this matrix is not supplied and \code{B}>0 then
  these indexes are created using the function \code{sample}. }
\item{verbose}{
    logical value. If \code{TRUE}, it writes out some messages
    indicating progress. If \code{FALSE} nothing should be printed.
  }
  \item{type}{
    Should bumphunting be performed on M-values ("M") or Beta values
    ("Beta")?}
  \item{\dots}{
    further arguments to be passed to the smoother functions.
}
}
\details{
  See help file for \code{\link[bumphunter]{bumphunter}} method in the
  \code{bumphunter} package for for details. 
}

\value{
An object of class \code{bumps} with the following components:
\item{tab}{The table with candidate regions and annotation for these.}
\item{coef}{The single loci coefficients.}
\item{fitted}{The estimated genomic profile used to determine the
  regions.}
\item{pvaluesMarginal}{marginal p-value for each genomic location.}
\item{null}{The null distribution.}
\item{algorithm}{details on the algorithm.}
}

\references{
AE Jaffe, P Murakami, H Lee, JT Leek, MD Fallin, AP Feinberg, and RA
Irizarry.
\emph{Bump hunting to identify differentially methylated regions in
  epigenetic epidemiology studies.}
International Journal of Epidemiology (2012) 41(1):200-209.
doi:\href{http://www.dx.doi.org/10.1093/ije/dyr238}{10.1093/ije/dyr238}
}

\seealso{\code{\link[bumphunter]{bumphunter}}}

\author{
  Rafael A. Irizarry, Martin J. Aryee and Kasper D. Hansen
}


\examples{
if(require(minfiData)) {
  gmSet <- preprocessQuantile(MsetEx)
  design <- model.matrix(~ gmSet$status)
  bumps <- bumphunter(gmSet, design = design, B = 0,
                      type = "Beta", cutoff = 0.25)
}
}


