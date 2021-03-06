#' Compute a frequency-specific version of CVcom or CVcomip
#' 
#' Compute a frequency-specific version of CVcom or CVcomip.
#' 
#' @param X A matrix with counts or densities arranged in species by time step
#' @param type If \code{com}, calculate a frequency-specific CVcom2. If \code{comip}, calculate a 
#' frequency-specific CVcomip2. See the vignette for definitions of these quantities.
#'
#' @return \code{cv2f} returns an object of type list consisting of
#' \item{frequency}{a vector from 0 to 1 (not including 0 and 1)}
#' \item{cv2}{A vector of frequency-specific population or community variability}
#' 
#' @author Shaopeng Wang, \email{shaopeng.wang@@pku.edu.cn}; Lei Zhao, \email{lei.zhao@@cau.edu.cn}; Daniel Reuman, \email{reuman@@ku.edu}
#' 
#' @references 
#' Zhao et al, (In prep) Decomposition of the variance ratio illuminates timescale-specific
#' population and community variability.
#' 
#' @seealso \code{\link{tsvreq_classic}}, \code{\link{cv2}}, \code{browseVignettes("tsvr")}
#' 
#' @examples
#' X<-matrix(runif(200,1,100), 10, 20) 
#' ans<-cv2f(X, type="com")
#' 
#' @export

cv2f <- function(X, type){
  errcheck_data(X,"cv2f")

  meanSp <- rowMeans(X)
  cosp<-cospect(X)
  freq<-cosp[[1]][-1]
  covSp <- cosp[[2]][,,-1]  # cospectrum
  mean.comm <- sum(meanSp)
  
  if (type=="com")
  {     
    var.comm <- apply(covSp, 3, sum)
    cv2 <- var.comm/mean.comm^2
    return(list(frequency=freq,cv2=cv2))
  }
  if (type=="comip")
  {
    cv2 <- apply(covSp, 3, function(x){
      var.sp <- sum(diag(x))
      cv2 <- var.sp/mean.comm^2   
      return(cv2)
    })
    return(list(frequency=freq,cv2=cv2))
  }
  
  stop("Error in cv2f: type must be com, comip")
}
