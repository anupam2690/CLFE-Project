! numerical calculation of the derivative

logical function CheckDuplicateRoots(x,roots,nfroots,h,f,eps)
    implicit none
    real(8)::x
    real(8),dimension(nfroots)::roots   ! Dynamical array to store roots
    integer::nfroots                    ! Number of found roots
    real(8)::h                          ! Derivative step width
    real(8)::eps                        ! Precision for calculating roots
    real(8)::ep                         ! Precision for checking duplicate roots
    real(8)::ep_bar                     ! Precision correction as per the slope
    real(8)::ep_l = 1.e-5               ! Lower limit
    real(8)::ep_up = 1.e-4              ! Upper limit
    real(8),external::f                 ! Function
    real(8),external::fp                ! Derivative
    integer::i
    CheckDuplicateRoots=.False.

    if (ep_l < eps) then
        ep_l = eps
    end if

    ep = f(x)

    ep_bar = 2*ep / dabs(fp(f,x,h))

    if (ep_bar < ep_l) then
            ep_bar = ep_l
    elseif (ep_bar > ep_up) then
        ep_bar = ep_up
    end if

   do i=1,nfroots
        if (dabs(roots(i)-x)<ep_bar) then
            CheckDuplicateRoots=.True.
            return
        end if
    end do

end function

