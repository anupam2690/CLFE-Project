
program MatMult90
    implicit none

    ! channel numbers
    integer::ioinp = 10
    integer::ioOut = 11

    ! default file name
    character(256)::inpFile = "anupaminput.in"
    character(256)::outFile = "anupamoutput.out"

    ! declare dynamical arrays
    !                             |1st Index
    !                               |2nd Index
    real(8),allocatable,dimension(:,:)::A
    real(8),allocatable,dimension(:,:)::B
    real(8),allocatable,dimension(:,:)::C
    real(8),allocatable,dimension(:,:)::D

    ! dimension arrays
    integer,dimension(2)::nDimA
    integer,dimension(2)::nDimB
    integer,dimension(2)::nDimC
    integer,dimension(2)::nDimD
    integer::NumMat

    ! function returns
    integer::iReadNumMat, iReadMatDim, iReadMat, iMatMult

    ! helper variables
    integer::ioErr
    ! helper variable for reading matrix
    integer::i=1

    ! check command line parameters
    ! matmult90 [input file] [output file]

    ! iargc: number of command line parameters
    ! get input file name
    if (iargc() > 0) then
        call getarg(1,inpFile)
    end if
    ! get output file name
    if (iargc() > 1) then
        call getarg(2,outFile)
    end if

    ! show file names on screen
    write(*,*)"input file name: ",InpFile(1:len_trim(inpFile))
    write(*,*)"output file name: ",OutFile(1:len_trim(outFile))

    ! write file names in output file
    write(ioOut,*)"input file name: ",InpFile(1:len_trim(inpFile))
    write(ioOut,*)"output file name: ",OutFile(1:len_trim(outFile))


    ! open the input file
    !    |channel
    !                        |status: old
    !                                 new
    !                                 unknown (not standard) new, delete the old and create new
    open(ioInp,file=inpFile,status='old',iostat=ioErr)
    if (ioErr .ne. 0) then
      write(*,'(/,a)') "***Error: input file '", &
                 inpFile(1:len_trim(inpFile)), &
                 "' not found"
      stop 1
    endif

    ! open the output file and delete old content
    !        |channel
    !
    !                       |status: old
    !                                new
    !                                unknown (not standard) new, delete the old and create new
    !                                replace (F90)  open an existing file of create a new one
    open(ioOut,file=outFile,status='replace',iostat=ioErr)
    if (ioErr .ne. 0) then
      write(*,'(/,a)') "*** Error: output file '", &
                 outFile(1:len_trim(outFile)), &
                 "' not found"
      stop 2
    endif

    ! Title on screen
    write(*,'(/,a)')       "*******************************************************************************************************"
    write(*,'(35x,a)')     "Matrix multiplication"
    write(*,'(a)')         "*******************************************************************************************************"

    ! Title in output file
    write(ioOut,'(/,a)')   "*******************************************************************************************************"
    write(ioOut,'(35x,a)') "Matrix multiplication"
    write(ioOut,'(a)')     "*******************************************************************************************************"

    ! read number of matrix to be multiplied
    if(iReadNumMat(ioInp,NumMat) /= 0) then
        write(*,'(/,a)') "***Error in input of number of matrix."       ! Error message
        goto 900
    end if

    ! number of matrix and required multiplications
    write(*,'(a,i3)') "Number of matrix to be multiplied.......:",NumMat
    write(*,'(a,i3,/)') "Number of multiplications...............:",NumMat-1
    write(ioOut,'(a,i3)') "Number of matrix to be multiplied.......:",NumMat
    write(ioOut,'(a,i3,/)') "Number of multiplications...............:",NumMat-1

    do i=1,NumMat
        ! read dimensions of matrix
        if(iReadMatDim(ioInp,nDimB) /= 0) then
            write(*,'(/,a,i3,a,i3,i3)') "Dimensions of matrix",i,"...:",nDimB(1),nDimB(2)
            write(*,'(/,a,i3,a,i3,i3)') "***Error in reading dimension or any matrix dimension is improper."
            goto 900
        end if

        ! writing matrix dimensions on screen and in output file
        write(*,'(/,a,i3,a,i3,i3)') "Dimensions of matrix",i,"...:",nDimB(1),nDimB(2)
        write(ioOut,'(/,a,i3,a,i3,i3)') "Dimensions of matrix",i,"...:",nDimB(1),nDimB(2)

        ! allocate array for next matrix
        allocate(B(nDimB(1),nDimB(2)),stat=ioerr)
        if (ioerr /=0) then
            write(*,'(/,a,i3)')"***Error: Allocating matrix",i
            goto 900
        end if

        ! check allocation of array
        if (.not. allocated(B)) then
            write(*,'(/,a,i3,a)') "Array for matrix",i,"is not allocated!"
        end if

        ! read the matrix
        if (iReadMat(ioInp,nDimB,B) /= 0) goto 900

        ! print matrix
        call listMat(ioOut,"Matrix",nDimB,B,i)

        ! If it is 1st matrix it will be stored to matrix A and the current loop will be canceled
        if (i == 1) then
            A = B
            nDimA=nDimB
            deallocate(B)
            cycle
        end if

        ! matrix product
        if (nDimA(2) /= nDimB(1)) then
            write(*,'(/,a)') "***Error: Inner dimension of matrix does not match!"
            goto 900
        end if

        ! matrix multiplication with the help of intrinsic function 'matmult'
        if (i == 2) then
            D = matmul(A,B)
            nDimD(1) = nDimA(1)
            nDimD(2) = nDimB(2)
        else
            D = matmul(D,B)
            nDimD(2) = nDimB(2)
        end if

        ! allocate array for resultant matrix (matrix C)
        nDimC(1) = nDimA(1)
        nDimC(2) = nDimB(2)
        allocate(C(nDimC(1),nDimC(2)),stat=ioerr)
        if (ioerr /=0) then
            write(*,'(/,a,i3)')"***Error: Allocating result matrix"
            goto 900
        end if

        ! matrix multiplication with developed library function
        if(iMatMult(A,B,C,nDimA,nDimB) /= 0) then
            write(*,'(/,a)') "***Error: Inner dimension of matrix does not match!"
            goto 900
        end if

        ! deallocate the arrays
        deallocate(A)
        deallocate(B)

        ! assign result matrix C to matrix A
        A = C
        nDimA=nDimC
        deallocate(C)

    enddo

    ! print result
    write(*,'(/,a)')       "***************************************************************************************************"
    write(*,'(35x,a)')     " Resultant Product of Matrices"
    write(*,'(a)')         "***************************************************************************************************"
    write(*,'(/,a,i3,i3)') "Dimensions of resultant matrix...:",nDimC(1),nDimC(2)
    write(ioOut,'(/,a)')   "***************************************************************************************************"
    write(ioOut,'(35x,a)') "Resultant Product of Matrices"
    write(ioOut,'(a)')     "***************************************************************************************************"
    write(ioOut,'(/,a,i3,i3)') "Dimensions of resultant matrix...:",nDimC(1),nDimC(2)

    ! printing result matrix
    call listMat(ioOut,"Result1",nDimC,A,i)
    call listMat(ioOut,"Result2",nDimD,D,i)


    ! jump to the end
    goto 999

    ! Error handler
900 continue
    write(*,'(/,a,/,3x,a)') "***Fatal error!","Program stopped."

    ! closing all files
999 continue
    close(ioInp)
    close(ioOut)

end
