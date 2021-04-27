! implementation of Newton's algorithm

integer function ScanForRoots(f,lb,ub,sw,eps,h,itx,roots,nmaxroots)
    implicit none

    ! declaration of functions
    real(8),external::f                         ! Function to give input function whose roots are supposed to be found
    logical,external::newton                    ! Function to find roots of the input function
    logical,external::CheckDuplicateRoots

    ! parameters
    real(8)::x0                         ! starting value
    real(8)::x                          ! root value of the function (result)
    real(8)::eps                        ! precision
    integer::itx                        ! maximum iteration
    real(8)::sw                         ! step for a new start
    real(8)::h                          ! step width for slope calculation
    real(8)::lb                         ! lower bound for search interval
    real(8)::ub                         ! upper bound for search interval
    integer::nmaxroots                  ! maximum number of roots
    real(8),dimension(nmaxroots)::roots ! a dynamical array to store roots
    integer::nfroots = 0                ! number of found roots
    real(8)::pd = 1.d-4                 ! miniaml slope

    x0 = lb                             ! starting position

    do while (nfroots<nmaxroots .and. x0<=ub)
        x = x0                                                          ! initialization of starting position @ every loop
        if(newton(f,x,eps,itx,sw,h,pd)) then                            ! if roots is found
            if (lb<=x .and. x<=ub) then                                 ! if found root is within the interval
                if (CheckDuplicateRoots(x,roots,nfroots,h,f,eps)) then  ! duplicate check for the roots
                    x0 = x0 + sw                                        ! increment to the starting position
                else
                    nfroots = nfroots + 1                               ! increment to the number of roots found
                    roots(nfroots) = x                                  ! allocating the root
                    x0 = x0 + sw                                        ! increment to the starting position
                end if
            else
                x0 = x0 + sw                                            ! increment to the starting position
            end if
        else
            x0 = x0 + sw                                                ! increment to the starting position
        end if
    end do
    ScanForRoots = nfroots
end function


