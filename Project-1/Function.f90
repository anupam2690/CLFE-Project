! Calculation of the functions

! return type
real(8) function myF(x)     ! Input function
    implicit none
    real(8):: x



     myF = (((2*x)-(8*sin(2*x)))*(tan(x)))/(1-x**2)                              ! Trigonometric function
!    myF = ((x**6)/7)+((x**5)/2)-(2*x**4)+(2*x**2)-(10*x)-3                      ! Polynomial  function
!    myF = ((1-x)*exp(-x/2)*(1-(2*cos(x/2))))-((1+x)*exp(x/2)*(1+(2*cos(x/2))))  ! Exponential function

end function
