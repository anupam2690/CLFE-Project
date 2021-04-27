! Writing the results - roots to the output window as well as output file

logical function funcToWriteResult(nFroots,roots)

    implicit none

    integer::nFroots                            ! Number of found roots
    real(8),dimension(nFroots)::roots           ! Array of roots
    integer,allocatable,dimension(:)::ind       ! Dynamical array for sorting the results
    real(8)::buffer                             ! Helper variable
    integer::memstat                            ! Memory status
    integer::io=10                              ! In/out put channel
    integer::i                                  ! Variable for loop

    ! Sorting of the roots
    do i=1,nFroots
        allocate(ind(nFroots-i+1),stat=memstat)
        if (memstat/=0) then
            write(*,*) '***Error: Array is not allocatable'
            funcToWriteResult=.False.
            return
        end if

        ind=minloc(roots(i:nFroots))            ! Minloc gives the index of lowest value (most negative) in the array

        if (ind(1)==1) then
            deallocate(ind)
            cycle
        else
            buffer=roots(ind(1)+i-1)
            roots(ind(1)+i-1)=roots(i)
            roots(i)=buffer
        end if
        deallocate(ind)
    end do

    ! Writing the results/output to the window
    write(*,'(x,a)')    '******************************'
    write(*,'(x,a,i4)') 'Number of roots found:', nFRoots
    write(*,'(x,a)')    '******************************'
    write(*,'(2x,a)')   'No.          Roots(x)'
    write(*,'(x,a)')    '******************************'

    ! Writing the results to the output file
    write(io,'(x,a)')    '******************************'
    write(io,'(x,a,i4)') 'Number of roots found:', nFRoots
    write(io,'(x,a)')    '******************************'
    write(io,'(2x,a)')   'No.          Roots(x)'
    write(io,'(x,a)')    '******************************'

    do i=1,nFroots
        write(*,'(x,i3,a,f10.4)') i,'       ',roots(i)
        write(io,'(x,i3,a,f10.4)') i,'       ',roots(i)
    end do

    write(*,'(x,a)')    '******************************'
    write(io,'(x,a)')   '******************************'

    funcToWriteResult=.True.

end function

