! developed library
!
! read matrix dimensions
!                            |channel
!                                  |number of matrix
integer function iReadNumMat(io,nMat)
    implicit none
    integer::io                                     ! channel
    integer::nMat                                   ! number of matrix
    integer::ioerr                                  ! error status

    ! read data
    read(io,*,iostat=ioerr) nMat
    if (ioerr /= 0) then
        iReadNumMat = 1
        return
    end if

    ! check input
    if (nMat < 2) then
        iReadNumMat = 2
        return
    endif

    iReadNumMat = 0
end function

! read matrix dimensions
!                            |channel
!                                  |dimensions
integer function iReadMatDim(io,nDim)
    implicit none
    integer::io                                     ! channel
    integer,dimension(2)::nDim                      ! matrix dimension
    integer::ioerr                                  ! error status

    ! read data
    read(io,*,iostat=ioerr) nDim(1),nDim(2)
    if (ioerr /= 0) then
        iReadMatDim = 1
        return
    end if

    ! check input ioOut
    if (nDim(1) < 1 .or. nDim(2) < 1 ) then
        iReadMatDim = 2
        return
    endif

    iReadMatDim = 0
end function

! read matrix data
!                         |channel
!                            |dimensions
integer function iReadMat(io,nDim,mat)
    implicit none
    integer::io                                     ! channel
    integer,dimension(2)::nDim                      ! matrix dimension
    real(8),dimension(nDim(1),nDim(2))::mat         ! matrix
    integer::i,j,ioerr

    ! over the rows
    do i = 1,nDim(1)
        read(io,*,iostat=ioerr) (mat(i,j),j=1,nDim(2))
        if (ioerr /= 0) then
            iReadMat = 1
            return
        end if
    end do

    iReadMat = 0
end function

! write matrix data into the output file
!                   | channel
!                       | title of matrix
!                            | dimension of matrix
!                                 | matrix data
!                                    | number of matrix
subroutine listMat(io,title,nDim,mat,k)
    implicit none
    integer::io                                     ! channel
    character(*)::title                             ! title
    integer,dimension(2)::nDim                      ! dimension
    real(8),dimension(nDim(1),nDim(2))::mat
    integer::i,j,k

    character(64)::ofmt                             ! dynamical format

    write(ofmt,'(a,i4,a)') "(",nDim(2),"(1x,f12.2))"

    ! write on the screen and in output file
    if (title=="Result1") then
        write(*,'(/,a)') "Result of Matrix multiplication by developed library function:"
        write(io,'(/,a)') "Result of Matrix multiplication by developed library function:"
    elseif (title=="Result2") then
        write(*,'(/,a)') "Result of Matrix multiplication by intrinsic function (matmul):"
        write(io,'(/,a)') "Result of Matrix multiplication by intrinsic function (matmul):"
    else
        write(*,'(a,i3,a)') title,k,":"
        write(io,'(a,i3,a)') title,k,":"
    end if

    ! printing matrix over all rows
    do i=1,nDim(1)
        ! On consol window
        write(*,ofmt) (mat(i,j),j=1,nDim(2))
        ! In output file
        write(io,ofmt) (mat(i,j),j=1,nDim(2))
    end do
end subroutine

! matrix product C = A*B
integer function iMatMult(A,B,C,nDimA,nDimB)
    implicit none

    integer,dimension(2)::nDimA                     ! dimension of matrix 1
    integer,dimension(2)::nDimB                     ! dimension of matrix 2

    ! declaration of matrix
    real(8),dimension(nDimA(1),nDimA(2))::A
    real(8),dimension(nDimB(1),nDimB(2))::B
    real(8),dimension(nDimA(1),nDimB(2))::C

     integer i,j,k                                  ! loop index variables

    ! Dimension check
    if (nDimA(2) /= nDimB(1)) then
        iMatMult = 1
        return
    end if

!     classical implementation
!     over the rows
    do i = 1,nDimA(1)
        ! over the columns
        do j = 1,nDimB(2)
            C(i,j) = 0.
            do k = 1,nDimA(2)
                C(i,j) = C(i,j) + A(i,k)*B(k,j)
            end do
        end do
    end do

     iMatMult = 0
end function



