! implementation of Newton's algorithm

logical function newton(f,x,p,itx,s,h,pd)
    implicit none
    ! parameters
    real(8),external::f     ! Function to give input function whose roots are need to be found
    real(8),external::fp    ! derivative function
    real(8)::x              ! starting value -> result
    real(8)::p              ! precision
    integer::itx            ! maximum iteration
    real(8)::s              ! step for a new start
    real(8)::h              ! step width for slope calculation.
    real(8)::pd             ! minimal slope

    ! helpers
    integer::i              ! loop counter
    real(8)::fx             ! current function value
    real(8)::fpx            ! current derivative

    ! loop over all tries
    do i=1,itx
        fx = f(x)
        ! 'dabs' calculates absolute value of the argument
        ! success exit: root found and exit function
        if (dabs(fx) < p) then
            newton = .true.
            return
        end if

        ! check the derivative
        fpx = fp(f,x,h)            ! Slope at x
        ! - newton step
        if (dabs(fpx) > pd) then
            x = x -fx/fpx
        ! - new starting value
        else
            x = x + s              ! Determine the x value for the successive iterations.
        endif
    end do
    newton = .false.
end function

