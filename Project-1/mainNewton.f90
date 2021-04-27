! testing environment for the newton's method implementation

program mainNewton

    implicit none
    !=============================================Section-1==============================================================
    ! declaration of functions
    real(8),external::myF                               ! Function to give input function whose roots are need to be found
    real(8),external::fp                                ! Function to find the derivative of the input function
    logical,external::newton                            ! Function to find roots of the input function
    logical,external::readData                          ! Function to read the input data and check its validity
    integer,external::ScanForRoots                      ! Function for finding the roots of input function
    logical,external::funcToWriteResult                 ! Function to write result

    ! declaration of variables
    real(8)::x0                                         ! Starting value
    real(8)::eps                                        ! Precision for Newton algorithm (!!!)
    integer::maxit                                      ! Maximum number of iterations for one root search (!!!)
    real(8)::sw                                         ! Step aside for the starting position x0
    real(8)::h                                          ! Derivative step width
    real(8)::lb                                         ! Lower bound for search interval
    real(8)::ub                                         ! Upper bound for search interval
    integer::maxroots                                   ! Maximum number of roots to be find
    real(8),allocatable,dimension(:)::roots             ! A dynamical array to store roots
    integer::memstat                                    ! Status variable for memory allocation
    integer::io=10                                      ! Channel number for opening & closing a file
    character(256)::inpFile = "ScanForRoots.inp"        ! Input file name
    character(256)::logFile = "newtonlogfile.txt"       ! Log file name
    integer::ioerr
    integer::numargs
    integer::i
    integer::nFRoots
    character(256)::arg

!   analyse the commandline parameters
    numargs = iargc()
    do i=0,numargs
        !           |index of parameter
        !           | |value of the parameter
        call getarg(i,arg)

        ! set input file name
        if (i==1) then
            inpFile = arg
        end if
    end do

    !=============================================Section-2==============================================================
    ! Read input data
    if (.not. readData(inpFile,maxroots,lb,ub,sw,eps,h,maxit,x0,logFile)) then
        write(*,*) '*** fatal error: stop'
        return
    end if

    ! Dynamic array allocation
    allocate(roots(maxroots),stat=memstat)
    if (memstat/=0) then
        write(*,*) '***Error: Array is not allocatable'
        return
    end if

    ! Function for finding the roots
    nFRoots = ScanForRoots(myF,lb,ub,sw,eps,h,maxit,roots,maxroots)

    ! Function for writing results (roots)
    open(io,file=logFile,status='old',position='append',iostat=ioerr)
    if (ioerr /= 0) then
        write(*,'(a,a,a)') "*** Error: ",logFile(1:len_trim(logFile))," not opened"
        write(*,'(a)') "Solution is not written to the log file"
    end if
    if (nFRoots>0) then
        write(*,'(x,a)') '*******************************************************************'
        write(*,'(x,5x,a)') 'Solution found'
        write(*,'(x,a)') '*******************************************************************'

        write(io,'(x,a)') '*******************************************************************'
        write(io,'(x,5x,a)') 'Solution found'
        write(io,'(x,a)') '*******************************************************************'

        if (.not. funcToWriteResult(nFRoots,roots)) then
            write(*,*) '***Error: result is not written'
            return
        end if
        close(io,status='keep')
    elseif (nFRoots==0) then
        write(*,'(x,a)') ''
        write(*,'(x,a)') ''
        write(*,'(x,a)') '*******************************************************************'
        write(*,'(x,5x,a)') 'No solution found'
        write(*,'(x,a)') '*******************************************************************'

        write(io,'(x,a)') ''
        write(io,'(x,a)') ''
        write(io,'(x,a)') '*******************************************************************'
        write(io,'(x,5x,a)') 'No solution found'
        write(io,'(x,a)') '*******************************************************************'
        close(io,status='keep')
        return
    endif

end

