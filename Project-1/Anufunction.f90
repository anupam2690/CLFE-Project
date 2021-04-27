! Derivative  of the given function

real(8) function fp(f,x,h)
    implicit none
    real(8),external::f     ! function
    real(8)::x              ! position of the  slope
    real(8)::h              ! step width

    fp = (f(x+h/2.d0) - f(x-h/2.d0))/h      ! Numerical derivative of the function

end function
