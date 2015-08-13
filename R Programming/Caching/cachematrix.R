# The code below defines two functions that handles inversion of matrixes...
#
# The first one, makeCacheMatrix, creates object with functions that stores, in the 
# parent environment (assignment operator <<-), the matrix passed as "x" parameter, 
# and also the "inversedMatrix" passed to the "setInversedMatrix()" function.
#
# The second function, cacheSolve, is used to work with the object that is created using  
# the first function. Basically, it checks if the object has already a inversed matrix 
# computed. If positive, it returns the computed inversed matrix. If not, it computes the 
# inverse matrix, and asks the first object to store it in the cache (via setInversedMatrix())
# and returns the computed inversed matrix.

  
## This function just handles the cache. It doesn't make any computations...
makeCacheMatrix <- function(x = matrix()) {
  iMatrix <<- NULL
  set <- function(matrix) {
    x <<- matrix
    iMatrix <<- NULL
  }
  get <- function() x
  setInversedMatrix <- function(inversedMatrix) iMatrix <<- inversedMatrix
  getInversedMatrix <- function() iMatrix
  list(set = set, get = get,
       setInversedMatrix = setInversedMatrix,
       getInversedMatrix = getInversedMatrix)
}

## This function gets a object from the makeCacheMatrix function.
## Before trying compute the inverse of the matrix, it checks if
## it isn't already computed.
cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
  iMatrix <- x$getInversedMatrix()
  if(!is.null(iMatrix)) {
    message("getting cached data")
    return(iMatrix)
  }else{
    message("calculating reversed matrix")
    x$setInversedMatrix(solve(x$get()))
    return(x$getInversedMatrix())
  }
}


## For testing the functions....
c=rbind(c(1, -1/4), c(-1/4, 1))
cm <- makeCacheMatrix(c)

# first time, it computes...
print (cacheSolve(cm))

# second time, it grabes from the cache...
print (cacheSolve(cm))

#that's all folks...



