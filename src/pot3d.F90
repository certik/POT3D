module ident
      implicit none
      character(*), parameter :: idcode='POT3D'
      character(*), parameter :: vers  ='4.3.1'
      character(*), parameter :: update='12/05/2024'
end module
module number_types
      use iso_fortran_env
      implicit none
      integer, parameter :: KIND_REAL_4=REAL32
      integer, parameter :: KIND_REAL_8=REAL64
      integer, parameter :: KIND_REAL_16=max(REAL128,REAL64)
      integer, parameter :: r_typ=KIND_REAL_8
end module
module number_types_pc
      use number_types
      use iso_fortran_env
      implicit none
      integer, parameter :: r_typ_pc=REAL32
end module
module constants
      use number_types
      implicit none
      real(r_typ), parameter :: pi=3.1415926535897932_r_typ
end module
module global_dims
      implicit none
      integer :: nr_g,nrm1_g
      integer :: nt_g,ntm1_g
      integer :: np_g,npm1_g
      logical :: axisymmetric=.false.
end module
module local_dims
      implicit none
      logical :: rb0,rb1,tb0,tb1
      integer :: nr,nrm1
      integer :: nt,ntm1
      integer :: np,npm1
      integer :: nrm
      integer :: ntm
      integer :: npm
      integer :: i0_g,i1_g
      integer :: j0_g,j1_g
      integer :: k0_g,k1_g
end module
module global_mesh
      use number_types
      use constants
      implicit none
      real(r_typ), dimension(:), allocatable :: r_g
      real(r_typ), dimension(:), allocatable :: t_g,th_g
      real(r_typ), dimension(:), allocatable :: p_g,ph_g,dph_g
      real(r_typ), parameter, private :: one=1._r_typ
      real(r_typ), parameter, private :: two=2._r_typ
      real(r_typ) :: r0=1._r_typ
      real(r_typ), parameter :: t0=0.
      real(r_typ), parameter :: t1=pi
      real(r_typ), parameter :: p0=0.
      real(r_typ), parameter :: p1=two*pi
      real(r_typ), parameter :: pl=p1-p0
      real(r_typ), parameter :: pl_i=one/pl
end module
module local_mesh
      use number_types
      implicit none
      real(r_typ), dimension(:), allocatable :: r,r2,rh,dr
      real(r_typ) :: dr1,drn
      real(r_typ), dimension(:), allocatable :: t,th,dt
      real(r_typ), dimension(:), allocatable :: p,ph,dp,dph
      real(r_typ), dimension(:), allocatable :: st,ct
      real(r_typ), dimension(:), allocatable :: sp,cp,sph
      real(r_typ), dimension(:), allocatable :: st_i
end module
module mpidefs
      use mpi
      implicit none
      integer :: nproc
      integer :: nprocsh
      integer :: iprocw
      integer :: iprocsh
      logical :: iamp0
      integer :: comm_all
      integer :: iproc
      integer :: iproc0
      integer :: comm_phi
      integer :: comm_shared
      integer :: comm_r
      integer :: iproc_r,iproc_t,iproc_p
      integer :: iproc_rm,iproc_rp
      integer :: iproc_tm,iproc_tp
      integer :: iproc_pm,iproc_pp
      integer :: nproc_r,nproc_t,nproc_p
      integer :: ntype_real
end module
module decomposition_params
      implicit none
      integer, dimension(3) :: nprocs=(/-1,-1,-1/)
end module
module meshdef
      use number_types
      implicit none
      integer, parameter :: nmseg=30
end module
module fields
      use number_types
      implicit none
      real(r_typ), dimension(:,:,:), allocatable :: phi
      real(r_typ), dimension(:,:,:), allocatable :: x_ax
      real(r_typ), dimension(:,:), allocatable :: br0
      real(r_typ), dimension(:,:), allocatable :: br1
      real(r_typ), dimension(:), allocatable :: sum0,sum1
      real(r_typ), dimension(:,:,:), allocatable :: br,bt,bp
end module

module vars
      use number_types
      implicit none
      character(256) :: br0file='br_input_tiny_bin.bin'
      character(3) :: fmt='h5'
end module
program POT3D
      use ident
      use mpidefs
      implicit none
      integer :: ierr
      call init_mpi
      if (iamp0) then
        write (*,*)
        write (*,*) idcode,' Version ',vers,', updated on ',update
      end if
      call read_input_file
      call check_proc_topology
      call allocate_global_arrays
      call allocate_local_arrays_r
      call set_flux
      call endrun (.false.)
end program pot3d
subroutine read_input_file
            use global_dims
            use global_mesh
            use mpidefs
            use meshdef
            use vars
            use decomposition_params
            implicit none
            integer :: nr=63
            integer :: nt=91
            integer :: np=225
            nr_g=nr
            nt_g=nt
            np_g=np
            nrm1_g=nr_g-1
            ntm1_g=nt_g-1
            npm1_g=np_g-1
end subroutine
subroutine endrun (ifstop)
      use mpidefs
      implicit none
      logical :: ifstop
      integer :: ierr
      call MPI_Finalize (ierr)
      if (ifstop) then
        stop
      end if
end subroutine
subroutine init_mpi
      use number_types
      use mpidefs
      implicit none
      integer :: ierr,tcheck
      real(r_typ) :: def_real
      call MPI_Init_thread (MPI_THREAD_FUNNELED,tcheck,ierr)
      call MPI_Comm_size (MPI_COMM_WORLD,nproc,ierr)
      call MPI_Comm_rank (MPI_COMM_WORLD,iprocw,ierr)
      call MPI_Comm_split_type (MPI_COMM_WORLD,MPI_COMM_TYPE_SHARED,0, &
                                MPI_INFO_NULL,comm_shared,ierr)
      call MPI_Comm_size (comm_shared,nprocsh,ierr)
      call MPI_Comm_rank (comm_shared,iprocsh,ierr)
      iamp0=.true.
      ntype_real=MPI_REAL8
end subroutine
subroutine set_proc_topology
      use mpidefs
      use decomposition_params
      use number_types
      use global_dims
      implicit none
      real(r_typ), parameter :: one=1.0_r_typ
      real(r_typ), parameter :: zero=0.0_r_typ
      real(r_typ), parameter :: bigval=HUGE(1.0_r_typ)
      integer, dimension(:), allocatable :: factors
      integer, dimension(:,:), allocatable :: rank_factors
      real(r_typ), dimension(:,:), allocatable :: nperrank
      real(r_typ), dimension(:), allocatable :: penalty
      integer :: i,j,k,num_fac,num_rank_fac,best_idx
      integer :: fr=1,ft=1,fp=1
      real(r_typ) :: a12,a13,a23
      nproc_r=nprocs(1)
      nproc_t=nprocs(2)
      nproc_p=nprocs(3)
      if(nproc_r.ne.-1.and.nproc_t.ne.-1.and.nproc_p.ne.-1) return
      i=1
      num_fac=0
      do while(i.le.nproc)
        if (MOD(nproc,i).eq.0) then
          num_fac=num_fac+1
        endif
        i=i+1
      enddo
      allocate (factors(num_fac))
      i=1
      num_fac=0
      do while(i.le.nproc)
        if (MOD(nproc,i).eq.0) then
          num_fac=num_fac+1
          factors(num_fac)=i
        endif
        i=i+1
      enddo
      a12=one
      a13=one
      a23=one
      if (nproc_r.ne.-1) then
        fr=nproc_r
        a12=zero
        a13=zero
      end if
      if (nproc_t.ne.-1) then
        ft=nproc_t
        a12=zero
        a23=zero
      end if
      if (nproc_p.ne.-1) then
        fp=nproc_p
        a13=zero
        a23=zero
      end if
      num_rank_fac=0
      do k=1,num_fac
        do j=1,num_fac
          do i=1,num_fac
            if(nproc_r.eq.-1) fr=factors(i)
            if(nproc_t.eq.-1) ft=factors(j)
            if(nproc_p.eq.-1) fp=factors(k)
            if (fr*ft*fp.eq.nproc) then
              num_rank_fac=num_rank_fac+1
            end if
          enddo
        enddo
      enddo
      allocate(rank_factors(num_rank_fac,3))
      allocate(nperrank(num_rank_fac,3))
      allocate(penalty(num_rank_fac))
      rank_factors(:,:)=-1
      penalty(:)=bigval
      num_rank_fac=0
      do k=1,num_fac
        do j=1,num_fac
          do i=1,num_fac
            if(nproc_r.eq.-1) fr=factors(i)
            if(nproc_t.eq.-1) ft=factors(j)
            if(nproc_p.eq.-1) fp=factors(k)
            if (fr*ft*fp.eq.nproc) then
              num_rank_fac=num_rank_fac+1
              rank_factors(num_rank_fac,1)=fr
              rank_factors(num_rank_fac,2)=ft
              rank_factors(num_rank_fac,3)=fp
            end if
          enddo
        enddo
      enddo
      nperrank(:,1)=real(nr_g)/rank_factors(:,1)
      nperrank(:,2)=real(nt_g)/rank_factors(:,2)
      nperrank(:,3)=real(np_g)/rank_factors(:,3)
      penalty(:)=a12*(nperrank(:,1)-nperrank(:,2))**2 &
                +a23*(nperrank(:,2)-nperrank(:,3))**2 &
                +a13*(nperrank(:,3)-nperrank(:,1))**2
      do i=1,num_rank_fac
        if (nperrank(i,1).lt.4) penalty(i)=bigval
        if (nperrank(i,2).lt.4) penalty(i)=bigval
        if (nperrank(i,3).lt.3) penalty(i)=bigval
      enddo
      best_idx=MINLOC(penalty,1)
      nprocs(1)=rank_factors(best_idx,1)
      nprocs(2)=rank_factors(best_idx,2)
      nprocs(3)=rank_factors(best_idx,3)
      deallocate(factors)
      deallocate(rank_factors)
      deallocate(nperrank)
      deallocate(penalty)
end subroutine
subroutine check_proc_topology
      use mpidefs
      use decomposition_params
      implicit none
      integer :: i,nreq
      call set_proc_topology
      nreq=nprocs(1)*nprocs(2)*nprocs(3)
end subroutine
subroutine allocate_global_arrays
      use global_dims
      use global_mesh
      implicit none
      allocate (r_g (nrm1_g))
      allocate (t_g (ntm1_g))
      allocate (th_g (nt_g))
      allocate (p_g  (np_g))
      allocate (ph_g (np_g))
      allocate (dph_g(np_g))
end subroutine
subroutine allocate_local_arrays_r
      use local_dims
      use local_mesh
      use fields
      implicit none
      allocate (r (nrm))
      allocate (r2 (nrm))
      allocate (dr(nrm))
      allocate (rh (nr))
      allocate (phi(nr,nt,np))
      allocate (x_ax(nr,nt,np))
      phi(:,:,:)=0.
      x_ax(:,:,:)=0.
      allocate (sum0(nr))
      allocate (sum1(nr))
      sum0(:)=0.
      sum1(:)=0.
      allocate (br(nrm,nt,np))
      allocate (bt(nr,ntm,np))
      allocate (bp(nr,nt,npm))
      br(:,:,:)=0.
      bt(:,:,:)=0.
      bp(:,:,:)=0.
end subroutine
subroutine set_flux
      use number_types
      use global_dims
      use global_mesh
      use local_dims
      use local_mesh
      use fields
      use vars
      use mpidefs
      implicit none
      real(r_typ), dimension(:,:), allocatable :: br0_g
      integer :: j,k,ierr
      allocate (br0_g(nt_g,np_g))
      call readbr (br0file,br0_g,ierr)
      deallocate(br0_g)
end subroutine
subroutine readbr (fname,br0_g,ierr)
      use number_types
      use global_dims
      use global_mesh
      use vars
      use rdhdf_2d_MOD
      implicit none
      character(*) :: fname
      real(r_typ), dimension(nt_g,np_g) :: br0_g
      integer :: ierr
      real(r_typ), parameter :: two=2._r_typ
      real(r_typ), dimension(:,:), pointer :: bn
      real(r_typ), dimension(:), pointer :: tn,pn
      integer :: ntn,npn,j,k
      logical :: scale
      real(r_typ) :: sum0,sum1,da
      ierr=0
      call rdhdf_2d (fname,scale,ntn,npn,bn,tn,pn,ierr)
      call intrp2d (ntn,npn,tn,pn,bn, &
                    nt_g-2,np_g-2,th_g(2:ntm1_g),ph_g(2:npm1_g), &
                    br0_g(2:ntm1_g,2:npm1_g),ierr)
      deallocate (bn)
      deallocate (tn)
      deallocate (pn)
      br0_g(:,1)=br0_g(:,npm1_g)
      br0_g(:,np_g)=br0_g(:,2)
      sum0=sum(br0_g(     2,2:npm1_g)*dph_g(2:npm1_g))*pl_i
      sum1=sum(br0_g(ntm1_g,2:npm1_g)*dph_g(2:npm1_g))*pl_i
      br0_g(1   ,:)=two*sum0-br0_g(     2,:)
      br0_g(nt_g,:)=two*sum1-br0_g(ntm1_g,:)
end subroutine
subroutine intrp2d (nxi,nyi,xi,yi,fi,nx,ny,x,y,f,ierr)
      use number_types
      implicit none
      integer :: nxi,nyi
      real(r_typ), dimension(nxi) :: xi
      real(r_typ), dimension(nyi) :: yi
      real(r_typ), dimension(nxi,nyi) :: fi
      integer :: nx,ny
      real(r_typ), dimension(nx) :: x
      real(r_typ), dimension(ny) :: y
      real(r_typ), dimension(nx,ny) :: f
      integer :: ierr
      real(r_typ), parameter :: zero=0._r_typ
      real(r_typ), external :: flint
      integer :: i,j,ii,jj
      real(r_typ) :: dum(1)=0.
      real(r_typ) :: dummy,xv,yv,ax,ay
      ierr=0
      dummy=flint(zero,nxi,xi,dum,1,ierr)
      if (ierr.ne.0) go to 900
      dummy=flint(zero,nyi,yi,dum,1,ierr)
      if (ierr.ne.0) go to 900
      do j=1,ny
        yv=y(j)
        if (yv.lt.yi(1).or.yv.gt.yi(nyi)) then
          go to 910
        end if
        call interp (yi,nyi,yv,jj,ay)
        do i=1,nx
          xv=x(i)
          if (xv.lt.xi(1).or.xv.gt.xi(nxi)) then
            go to 910
          end if
          call interp (xi,nxi,xv,ii,ax)
          f(i,j)= (1.-ax)*((1.-ay)*fi(ii  ,jj  )+ay*fi(ii  ,jj+1)) &
                 +    ax *((1.-ay)*fi(ii+1,jj  )+ay*fi(ii+1,jj+1))
        enddo
      enddo
      return
  900 continue
      write (*,*)
      write (*,*) '### ERROR in INTRP2D:'
      write (*,*) '### Scales are not monotonically increasing.'
      ierr=1
      return
  910 continue
      write (*,*)
      write (*,*) '### ERROR in INTRP2D:'
      write (*,*) '### An interpolation was attempted outside the'// &
                  ' range of the defined scales.'
      ierr=2
end subroutine
function flint (x,n,xn,fn,icheck,ierr)
      use number_types
      implicit none
      real(r_typ) :: flint
      real(r_typ) :: x
      integer :: n
      real(r_typ), dimension(n) :: xn,fn
      integer :: icheck
      integer :: ierr
      integer :: i,j
      real(r_typ) :: x1,x2,alpha
      ierr=0
      flint=0.
      if (x.le.xn(1)) then
        flint=fn(1)
      else if (x.gt.xn(n)) then
        flint=fn(n)
      else
        do 200 i=1,n-1
          if (x.ge.xn(i).and.x.lt.xn(i+1)) go to 300
  200   continue
  300   continue
        x1=xn(i)
        x2=xn(i+1)
        alpha=(x-x1)/(x2-x1)
        flint=fn(i)*(1.-alpha)+fn(i+1)*alpha
      end if
      return
end function
subroutine interp (x,n,xv,i,alpha)
      use number_types
      implicit none
      integer :: n
      real(r_typ), dimension(n) :: x
      real(r_typ) :: xv
      integer :: i
      real(r_typ) :: alpha
      do 100 i=1,n-1
        if (xv.ge.x(i).and.xv.le.x(i+1)) then
          alpha=(xv-x(i))/(x(i+1)-x(i))
          go to 200
        end if
  100 continue
      write (*,*)
      write (*,*) '### ERROR in INTERP:'
      write (*,*) '### Value not found in table.'
      write (*,*) 'Value requested = ',xv
      write (*,*) 'Min table value = ',x(1)
      write (*,*) 'Max table value = ',x(n)
      call endrun (.true.)
  200 continue
end subroutine
