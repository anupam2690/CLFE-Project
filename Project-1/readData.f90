! read input data from the input file

logical function readData(name,num_roots,lowerBound,upperBound,stepW,preci,stepW_dx,itx,x0,outputFile)
    implicit none

    character(*)::name          ! 90 version
    character(*)::outputFile    ! 90 version
    real(8)::x0                 ! starting value
    integer::num_roots          ! maximum number of roots
    real(8)::lowerBound         ! lower bound of the search interval
    real(8)::upperBound         ! upper bound of the interval
    real(8)::temp               ! helper variable
    real(8)::stepW              ! step width for the starting position x0
    real(8)::preci              ! precision for finding the roots
    real(8)::stepW_dx           ! derivative step width
    integer::itx                ! maximum number of iterations (!!!)
    integer::io = 10            ! channel to read
    integer::ioerr              ! return information of the open
    integer::errors = 0         ! error counter

    ! Opening of file and checking if there is any error in opening
    open(io,file=name,status='old',iostat=ioerr)
    if (ioerr /= 0) then
        write(*,'(a,a,a)') "*** Error: ",name(1:len_trim(name))," not found"
        readData = .False.
        return
    end if

! Reading first line of input file
    read(io,*,iostat=ioerr) num_roots
    if (ioerr /= 0) then                                            ! ioerr > 0: read error, data error
        write (*,*) '***I/O error in reading first line:',ioerr     ! ioerr < 0: end of file
        readData = .False.
        return
    end if

    ! Checking the input for maximum number of roots
    ! 1. if number of roots to be found is less than zero
    ! Corrections if it is less than zero
    if (num_roots<=0) then
        write (*,'(a,i3,a)') '***Error: Maximum roots to be found=',num_roots
        errors = errors +1
        if (num_roots==0) then
            num_roots = 1
        else if (num_roots<0) then
            num_roots=num_roots*(-1)
        end if
            write (*,'(3x,a)') 'Possible correction:'
            write (*,'(4x,a,i3,/)') 'The number of roots to be found=',num_roots
    end if

! Reading second line of input file
    read(io,*,iostat=ioerr) lowerBound,upperBound,stepW
    if (ioerr /= 0) then                                            ! ioerr > 0: read error, data error
        write (*,*) '***I/O error in reading second line:',ioerr    ! ioerr < 0: end of file
        readData = .False.
        return
    end if

    ! Setting the starting position of x
    x0=lowerBound

    ! Checking the input
    ! 2. if value of lower bound is greater than upper bound
    if (lowerBound>upperBound) then
        write (*,'(a)') '***Error: Lower bound of search interval is greater than upper bound'
        errors = errors +1
        temp = lowerBound
        lowerBound = upperBound
        upperBound = temp
        x0 = lowerBound
        write (*,'(3x,a)') 'Possible correction:'
        write (*,'(4x,a,f10.4)') 'Lower bound=',lowerBound
        write (*,'(4x,a,f10.4,/)') 'Upper bound=',upperBound
    end if

    ! 3. if value of lower bound is equal to upper bound
    if (lowerBound==upperBound) then
        write (*,'(a)') '***Error: Lower bound and upper bound are same. No interval is specified.'
        errors = errors +1
        write(*,'(i2,a,/)') errors,' error(s) found in input file'
        readData = .False.
        return
    ! 4. if step width value for starting value is zero
    else if (stepW==0.00) then
        write (*,'(a)') '***Error: Step width for starting position x0 is 0'
        errors = errors +1
        if (x0==lowerBound) then
            stepW=0.01
        elseif (x0==upperBound) then
            stepW=-0.01
        end if
        write (*,'(3x,a)') 'Possible correction:'
        write (*,'(4x,a,f10.4,/)') 'Step width=',stepW
    ! 5. if step width is bigger than the search interval
    else if (dabs(stepW)>=dabs(upperBound-lowerBound)) then
        write (*,'(a)') '***Error: Step width for starting position x0 is greater than the search interval.'
        errors = errors +1
        if (x0==lowerBound) then
            stepW=0.01
        elseif (x0==upperBound) then
            stepW=-0.01
        end if
        write (*,'(3x,a)') 'Possible correction:'
        write (*,'(4x,a,f10.4,/)') 'Step width for the starting position x0 =',stepW
    end if

! Reading third line of input file
    read(io,*,iostat=ioerr) preci,stepW_dx,itx
    if (ioerr /= 0) then                                            ! ioerr > 0: read error, data error
        write (*,*) '***I/O error in reading third line:',ioerr     ! ioerr < 0: end of file
        readData = .False.
        return
    end if

    ! 6. if precision is other than 1.e-7
    if (preci<=0.0 .or. preci>=1.e-7) then
        write (*,'(a)') '***Error: Wrong input for precision for newton algorithm.'
        errors = errors +1
        preci=1.e-7
        write (*,'(3x,a)') 'Possible correction:'
        write (*,'(4x,a,e10.2,/)') 'Precision for newtons algorithm=',preci
    end if

    ! 7. if step width for derivative is zero
    if (stepW_dx==0.00) then
        write (*,'(a)') '***Error: Step width for derivative is 0'
        errors = errors +1
        stepW_dx=0.01
        write (*,'(3x,a)') 'Possible correction:'
        write (*,'(4x,a,f10.4,/)') 'Step width for derivative=',stepW_dx
    ! 8. if step width for derivative is bigger than the search interval
    else if (dabs(stepW_dx)>=dabs(upperBound-lowerBound)) then
        write (*,'(a)') '***Error: Step width for derivative is greater than the search interval.'
        errors = errors +1
        stepW_dx=0.01
        write (*,'(3x,a)') 'Possible correction:'
        write (*,'(4x,a,f10.4,/)') 'Step width for derivative=',stepW_dx
    end if

    ! 9. if number of iteration is less than zero
    if (itx<0) then
        write (*,'(a,i4)') '***Error: Maximum number of iteration=',itx
        errors = errors +1
        itx=itx*(-1)
        write (*,'(3x,a)') 'Possible correction:'
        write (*,'(4x,a,i4,/)') 'Maximum number of iteration=',itx
    ! 10. if number of iteration is zero
    else if(itx==0) then
        write (*,'(a,i4)') '***Error: Maximum number of iteration  for one root search=',itx
        errors = errors +1
        itx=100
        write (*,'(3x,a)') 'Possible correction:'
        write (*,'(4x,a,i4,/)') 'Maximum number of iteration for one root search=',itx
    end if

    ! Close the file
    ! status='keep'   -> do not delete
    ! status='delete' -> delete file
    close(io,status='keep')     ! Closing input file

    ! Writing input data to the window
    write(*,'(x,a,i3,a,//)') '-->',errors,' error(s) found in the input file'
    write(*,'(x,a)')          '*******************************************************************'
    write(*,'(x,4x,a)')               'INPUT data / Corrected INPUT data'
    write(*,'(x,a)')          '*******************************************************************'
    write(*,'(x,a,x,i4)')     'Maximum number roots to be found..................:', num_roots
    write(*,'(x,a,f10.4)')    'Lower bound of search interval....................:', lowerBound
    write(*,'(x,a,f10.4)')    'Upper bound of search interval....................:', upperBound
    write(*,'(x,a,f10.4)')    'Step width for the starting position x0...........:',stepW
    write(*,'(x,a,4x,e10.4)') 'Precision for the newton algorithm................:',preci
    write(*,'(x,a,f10.4)')    'Step width for derivative.........................:',stepW_dx
    write(*,'(x,a,x,i4)')     'Maximum number of iteration for one root search...:',itx
    write(*,'(x,a,///)')        '*******************************************************************'
    readData = .True.

    ! Opening the log file
    open(io,file=outputFile,status='replace',iostat=ioerr)

    if (ioerr /= 0) then
        write(*,'(a,a,a)') "*** Error: ",outputFile(1:len_trim(outputFile))," not created"
    end if

    ! Writing input data to the log file
    write(io,'(x,a,i3,a,//)') '-->',errors,' error(s) found in input file'
    write(io,'(x,a)')          '*******************************************************************'
    write(io,'(x,5x,a)')               'INPUT data / Corrected INPUT data'
    write(io,'(x,a)')          '*******************************************************************'
    write(io,'(x,a,x,i4)')     'Maximum number roots to be found..................:', num_roots
    write(io,'(x,a,f10.4)')    'Lower bound of search interval....................:', lowerBound
    write(io,'(x,a,f10.4)')    'Upper bound of search interval....................:', upperBound
    write(io,'(x,a,f10.4)')    'Step width for the starting position x0...........:',stepW
    write(io,'(x,a,4x,e10.4)') 'Precision for the newton algorithm................:',preci
    write(io,'(x,a,f10.4)')    'Step width for derivative.........................:',stepW_dx
    write(io,'(x,a,x,i4)')     'Maximum number of iteration for one root search...:',itx
    write(io,'(x,a,///)')          '*******************************************************************'
    close(io,status='keep')     ! Close the log file
end function

