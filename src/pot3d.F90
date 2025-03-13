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
      real(r_typ), dimension(:), allocatable :: r_g,rh_g,dr_g,drh_g
      real(r_typ), dimension(:), allocatable :: t_g,th_g,dt_g,dth_g
      real(r_typ), dimension(:), allocatable :: p_g,ph_g,dp_g,dph_g
      real(r_typ), dimension(:), allocatable :: st_g,ct_g,sth_g,cth_g
      real(r_typ), dimension(:), allocatable :: sp_g,cp_g,sph_g,cph_g
      real(r_typ), parameter, private :: one=1._r_typ
      real(r_typ), parameter, private :: two=2._r_typ
      real(r_typ) :: r0=1._r_typ
      real(r_typ) :: r1=30._r_typ
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
      real(r_typ), dimension(:), allocatable :: r,r2,rh,dr,drh
      real(r_typ) :: dr1,drn
      real(r_typ), dimension(:), allocatable :: t,th,dt,dth
      real(r_typ), dimension(:), allocatable :: p,ph,dp,dph
      real(r_typ), dimension(:), allocatable :: st,ct,sth,cth
      real(r_typ), dimension(:), allocatable :: sp,cp,sph,cph
      real(r_typ), dimension(:), allocatable :: r_i,rh_i
      real(r_typ), dimension(:), allocatable :: dr_i,drh_i
      real(r_typ), dimension(:), allocatable :: dt_i,dth_i
      real(r_typ), dimension(:), allocatable :: st_i,sth_i
      real(r_typ), dimension(:), allocatable :: dp_i,dph_i
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
module decomposition
      implicit none
      type :: map_struct
        integer :: n
        integer :: i0
        integer :: i1
        integer :: offset
      end type
      type(map_struct), dimension(:), pointer :: map_rh
      type(map_struct), dimension(:), pointer :: map_rm
      type(map_struct), dimension(:), pointer :: map_th
      type(map_struct), dimension(:), pointer :: map_tm
      type(map_struct), dimension(:), pointer :: map_ph
      type(map_struct), dimension(:), pointer :: map_pm
end module
module meshdef
      use number_types
      implicit none
      integer, parameter :: nmseg=30
      real(r_typ), dimension(nmseg) :: drratio=0.
      real(r_typ), dimension(nmseg) :: dtratio=0.
      real(r_typ), dimension(nmseg) :: dpratio=0.
      real(r_typ), dimension(nmseg) :: rfrac=0.
      real(r_typ), dimension(nmseg) :: tfrac=0.
      real(r_typ), dimension(nmseg) :: pfrac=0.
      integer :: nfrmesh=0
      integer :: nftmesh=0
      integer :: nfpmesh=0
      real(r_typ) :: phishift=0.
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
module cgcom
      use number_types
      implicit none
      integer :: ncgeq
      integer :: ifprec=1
      integer :: ncgmax=1000000
      integer :: ncghist=100
      real(r_typ) :: epscg=1.e-9
      integer :: ncg
      real(r_typ) :: epsn
      real(r_typ), allocatable, dimension(:,:) :: sbuf_rt1,sbuf_rt2
      real(r_typ), allocatable, dimension(:,:) :: sbuf_tp1,sbuf_tp2
      real(r_typ), allocatable, dimension(:,:) :: sbuf_rp1,sbuf_rp2
      real(r_typ), allocatable, dimension(:,:) :: rbuf_rt1,rbuf_rt2
      real(r_typ), allocatable, dimension(:,:) :: rbuf_tp1,rbuf_tp2
      real(r_typ), allocatable, dimension(:,:) :: rbuf_rp1,rbuf_rp2
end module
module vars
      use number_types
      implicit none
      character(256) :: outfile='pot3d.out'
      character(256) :: phifile='default'
      character(256) :: br0file='default'
      character(256) :: brfile='default'
      character(256) :: btfile='default'
      character(256) :: bpfile='default'
      character(256) :: br_photo_file='default'
      character(256) :: br_photo_original_file='default'
      character(16) :: option='potential'
      integer :: ndump=0
      logical :: do_not_balance_flux=.false.
      character(3) :: fmt='h5'
      logical :: hdf32=.true.
      logical :: validation_run=.false.
      real(r_typ) :: dipole_angle=0.7853981633974483_r_typ
end module
module solve_params
      use number_types
      implicit none
      real(r_typ) :: pm_r1
end module
module timer
      use number_types
      implicit none
      integer, parameter :: nstack=10
      integer :: istack=0
      real(r_typ), dimension(nstack) :: tstart=0.
end module
module timing
      use number_types
      implicit none
      real(r_typ) :: t_startup=0.
      real(r_typ) :: t_solve=0.
      real(r_typ) :: t_pc_load=0.
      real(r_typ) :: t_pc=0.
      real(r_typ) :: t_ax=0.
      real(r_typ) :: t_io=0.
      real(r_typ) :: c_seam=0.
      real(r_typ) :: c_cgdot=0.
      real(r_typ) :: c_sumphi=0.
      real(r_typ) :: t_wall=0.
end module
module debug
      implicit none
      integer :: idebug=0
end module
module cusparse_interface
      use, intrinsic :: iso_c_binding
#ifdef CUSPARSE
      interface
  subroutine load_lusol_cusparse(CSR_A,CSR_AI,CSR_AJ,N,M) &
          BIND(C, name="load_lusol_cusparse")
          use, intrinsic :: iso_c_binding
          implicit none
          integer(C_INT), value :: N,M
          type(C_PTR), value :: CSR_A,CSR_AI,CSR_AJ
  end subroutine load_lusol_cusparse
  subroutine lusol_cusparse(x) &
          BIND(C, name="lusol_cusparse")
          use, intrinsic :: iso_c_binding
          implicit none
          type(C_PTR), value :: x
  end subroutine lusol_cusparse
  subroutine unload_lusol_cusparse() &
          BIND(C, name="unload_lusol_cusparse")
  end subroutine unload_lusol_cusparse
      end interface
#endif
      integer(c_int) :: cN,cM
end module
module matrix_storage_pot3d_solve
      use number_types
      use number_types_pc
      implicit none
      real(r_typ), dimension(:,:,:,:), allocatable :: a
      real(r_typ_pc), dimension(:), allocatable :: a_i
      integer, dimension(7) :: a_offsets
      integer :: N,M
      real(r_typ_pc), dimension(:), allocatable, target :: a_csr
      real(r_typ_pc), dimension(:), allocatable :: lu_csr
      real(r_typ_pc), dimension(:), allocatable :: a_csr_d
      integer, dimension(:), allocatable :: lu_csr_ja
      integer, dimension(:), allocatable, target :: a_csr_ia
      integer, dimension(:), allocatable, target :: a_csr_ja
      integer, dimension(:), allocatable :: a_N1
      integer, dimension(:), allocatable :: a_N2
      integer, dimension(:), allocatable :: a_csr_dptr
end module
program POT3D
      use ident
      use mpidefs
      use vars
      use solve_params
      use timing
      use ffopen_MOD
      implicit none
      integer :: ierr
      call init_mpi
      if (iamp0) then
        write (*,*)
        write (*,*) idcode,' Version ',vers,', updated on ',update
      end if
      call read_input_file
      call check_proc_topology
      call decompose_domain
      call allocate_global_arrays
      call set_global_mesh
      call decompose_mesh_r
      call decompose_mesh_tp
      call allocate_local_arrays_r
      call set_flux
      call endrun (.false.)
end program pot3d
subroutine read_input_file
            use global_dims
            use ffopen_MOD
            use global_mesh
            use mpidefs
            use meshdef
            use cgcom
            use debug
            use vars
            use decomposition_params
            implicit none
            integer :: nr=0
            integer :: nt=0
            integer :: np=0
            integer :: i
            integer :: pos_eq
            integer :: ierr
            integer :: n_values
            character(80) :: infile='pot3d.dat'
            character(80) :: line
            character(20) :: key
            character(60) :: value
            call ffopen (8,infile,'r',ierr)
            do
              read(8, '(A)', iostat=ierr) line
              if (ierr /= 0) then
                  ierr = 0
                  exit
              end if
                pos_eq = index(line, '=')
                if (pos_eq > 0) then
                  key = adjustl(line(1:pos_eq - 1))
                  value = adjustl(line(pos_eq + 1:))
                  if (value /= "''") then
                        if (value(1:1) == "'") value = value(2:)
                        if (value(len_trim(value):len_trim(value)) == "'") value = value(1:len_trim(value)-1)
                  end if
                  select case (trim(key))
                    case ("nprocs")
                        read(value, *) nprocs
                    case ("nr")
                        read(value, *) nr
                    case ("nt")
                        read(value, *) nt
                    case ("np")
                        read(value, *) np
                    case ("r0")
                        read(value, *) r0
                    case ("r1")
                        read(value, *) r1
                    case ("drratio")
                        read(value, *, iostat=ierr) drratio(1)
                    case ("dtratio")
                        read(value, *, iostat=ierr) dtratio(1)
                    case ("dpratio")
                        read(value, *, iostat=ierr) dpratio(1)
                    case ("rfrac")
                        pos_eq = index(value, ",")
                        read(value(1:pos_eq-1), *) rfrac(1)
                        read(value(pos_eq+1:), *) rfrac(2)
                    case ("tfrac")
                        read(value, *, iostat=ierr) tfrac(1)
                    case ("pfrac")
                        read(value, *, iostat=ierr) pfrac(1)
                    case ("nfrmesh")
                        read(value, *) nfrmesh
                    case ("nftmesh")
                        read(value, *) nftmesh
                    case ("nfpmesh")
                        read(value, *) nfpmesh
                    case ("phishift")
                        read(value, *) phishift
                    case ("ifprec")
                        read(value, *) ifprec
                    case ("ncgmax")
                        read(value, *) ncgmax
                    case ("ncghist")
                        read(value, *) ncghist
                    case ("epscg")
                        read(value, *) epscg
                    case ("idebug")
                        read(value, *) idebug
                    case ("br0file")
                        read(value, *) br0file
                    case ("phifile")
                        read(value, *) phifile
                    case ("brfile")
                        read(value, *) brfile
                    case ("btfile")
                        read(value, *) btfile
                    case ("bpfile")
                        read(value, *) bpfile
                    case ("br_photo_file")
                        read(value, *) br_photo_file
                    case ("br_photo_original_file")
                        read(value, *) br_photo_original_file
                    case ("option")
                        read(value, *) option
                    case ("do_not_balance_flux")
                        read(value, *) do_not_balance_flux
                    case ("hdf32")
                        read(value, *) hdf32
                    case ("validation_run")
                        read(value, *) validation_run
                    case ("dipole_angle")
                        read(value, *) dipole_angle
                    case default
                        write(*, *) "WARNING: Unknown key:", trim(key)
                  end select
                end if
            end do
            if (ierr.ne.0) then
              if (iamp0) then
                write (*,*)
                write (*,*) '### ERROR in READ_INPUT_FILE:'
                write (*,*) '### Could not open the input file.'
                write (*,*) 'File name: ',trim(infile)
              end if
              call endrun (.true.)
            end if
            close (8)
            if (trim(fmt).ne.'h5') then
              if (iamp0) then
                write (*,*)
                write (*,*) '### ERROR in READ_INPUT_FILE:'
                write (*,*) '### "fmt" must be "h5".'
                write (*,*) 'fmt: ',trim(fmt)
              end if
              call endrun (.true.)
            end if
            if (trim(phifile).eq.'default') then
              phifile='phi.'//trim(fmt)
            end if
            if (trim(br0file).eq.'default') then
              br0file='br0.'//trim(fmt)
            end if
            if (trim(brfile).eq.'default') then
              brfile='br.'//trim(fmt)
            end if
            if (trim(btfile).eq.'default') then
              btfile='bt.'//trim(fmt)
            end if
            if (trim(bpfile).eq.'default') then
              bpfile='bp.'//trim(fmt)
            end if
            if (trim(br_photo_file).eq.'default') then
              br_photo_file='br_photo.'//trim(fmt)
            end if
            if (trim(br_photo_original_file).eq.'default') then
              br_photo_original_file='br_photo_original.'//trim(fmt)
            end if
            nr_g=nr
            nt_g=nt
            np_g=np
            call check_mesh_dimensions (nr_g,nt_g,np_g)
            nrm1_g=nr_g-1
            ntm1_g=nt_g-1
            npm1_g=np_g-1
end subroutine
subroutine endrun (ifstop)
      use mpidefs
      implicit none
      logical :: ifstop
      integer :: ierr
      ! if (iamp0) then
      !   close (9)
      ! end if
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
      if (iprocw.eq.0) then
        iamp0=.true.
      else
        iamp0=.false.
      end if
      if (kind(def_real).eq.KIND_REAL_4) then
        ntype_real=MPI_REAL4
      else if (kind(def_real).eq.KIND_REAL_8) then
        ntype_real=MPI_REAL8
      else
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in INIT_MPI:'
          write (*,*) '### Unrecognized default REAL number KIND:'
          write (*,*) 'KIND(default_real) = ',kind(def_real)
          write (*,*) 'This is a fatal error.'
        end if
        call endrun (.true.)
      end if
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
      if (num_rank_fac.eq.0) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in SET_PROC_TOPOLOGY:'
          write (*,*) '### Processor topology specification error.'
          write (*,*) 'No valid topologies found for selected options.'
          write (*,*) 'Number of MPI ranks = ',nproc
          write (*,*) 'NPROC_R = ',nproc_r
          write (*,*) 'NPROC_T = ',nproc_t
          write (*,*) 'NPROC_P = ',nproc_p
        end if
        call endrun (.true.)
      end if
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
      if (penalty(best_idx).eq.bigval) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in SET_PROC_TOPOLOGY:'
          write (*,*) '### Processor topology specification error.'
          write (*,*) 'No valid topologies found for selected options'
          write (*,*) 'with selected grid.  '
          write (*,*) 'It is likely you are using too many MPI ranks.'
          write (*,*) 'Number of MPI ranks = ',nproc
          write (*,*) 'NPROC_R = ',nproc_r
          write (*,*) 'NPROC_T = ',nproc_t
          write (*,*) 'NPROC_P = ',nproc_p
          write (*,*) 'NR = ',nr_g
          write (*,*) 'NT = ',nt_g
          write (*,*) 'NP = ',np_g
        end if
        call endrun (.true.)
      end if
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
      do i=1,3
        if (nprocs(i).lt.1.and.nprocs(i).ne.-1) then
          if (iamp0) then
            write (*,*)
            write (*,*) '### ERROR in CHECK_PROC_TOPOLOGY:'
            write (*,*) '### Processor topology specification error.'
            write (*,*) 'Invalid number of processors requested.'
            write (*,*) 'Dimension = ',i
            write (*,*) 'Number of processors requested = ', &
                        nprocs(i)
          end if
          call endrun (.true.)
        end if
      enddo
      call set_proc_topology
      nreq=nprocs(1)*nprocs(2)*nprocs(3)
      if (nreq.ne.nproc) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in CHECK_PROC_TOPOLOGY:'
          write (*,*) '### Processor topology specification error.'
          write (*,*) 'The number of processors requested does not'// &
                     ' equal the number available.'
          write (*,*) 'Number of processors requested = ',nreq
          write (*,*) 'Number of processors available = ',nproc
        end if
        call endrun (.true.)
      end if
end subroutine
subroutine decompose_domain
      use mpidefs
      use decomposition_params
      implicit none
      integer :: ierr
      integer, parameter :: ndim=3
      integer, dimension(ndim) :: coords
      logical, dimension(ndim) :: periodic
      logical :: reorder
      logical, dimension(ndim) :: keep_dim
      periodic(1)=.false.
      periodic(2)=.false.
      periodic(3)=.true.
      reorder=.true.
      call MPI_Cart_create (MPI_COMM_WORLD,ndim,nprocs, &
                            periodic,reorder,comm_all,ierr)
      call MPI_Comm_rank (comm_all,iproc,ierr)
      if (iamp0) then
        iproc0=iproc
      end if
      call MPI_Bcast (iproc0,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
      call MPI_Cart_coords (comm_all,iproc,ndim,coords,ierr)
      iproc_r=coords(1)
      iproc_t=coords(2)
      iproc_p=coords(3)
      nproc_r=nprocs(1)
      nproc_t=nprocs(2)
      nproc_p=nprocs(3)
      call MPI_Cart_shift (comm_all,0,1,iproc_rm,iproc_rp,ierr)
      call MPI_Cart_shift (comm_all,1,1,iproc_tm,iproc_tp,ierr)
      call MPI_Cart_shift (comm_all,2,1,iproc_pm,iproc_pp,ierr)
      keep_dim(1)=.false.
      keep_dim(2)=.false.
      keep_dim(3)=.true.
      call MPI_Cart_sub (comm_all,keep_dim,comm_phi,ierr)
      keep_dim(1)=.true.
      keep_dim(2)=.false.
      keep_dim(3)=.false.
      call MPI_Cart_sub (comm_all,keep_dim,comm_r,ierr)
end subroutine
subroutine decompose_mesh_r
      use global_dims
      use local_dims
      use decomposition
      use solve_params
      use mpidefs
      implicit none
      integer :: ierr,i,npts
      integer :: i0_h,i1_h,i0_m,i1_m
      integer, dimension(nproc_r) :: mp_r
      npts=nr_g
      call decompose_dimension (npts,nproc_r,mp_r,ierr)
      if (ierr.ne.0) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in DECOMPOSE_MESH:'
          write (*,*) '### Anomaly in decomposing the mesh'// &
                      ' between processors.'
          write (*,*) '### Could not decompose the r mesh.'
          write (*,*) 'Number of mesh points in r = ',npts
          write (*,*) 'Number of processors along r = ',nproc_r
        end if
        call endrun (.true.)
      end if
      call check_mesh_topology (nproc_r,mp_r,1,'r')
      i0_g=1
      do i=1,iproc_r
        i0_g=i0_g+mp_r(i)
      enddo
      nr=mp_r(iproc_r+1)+2
      i1_g=i0_g+nr-1
      nrm1=nr-1
      if (iproc_r.eq.0) then
        rb0=.true.
      else
        rb0=.false.
      end if
      if (iproc_r.eq.nproc_r-1) then
        rb1=.true.
      else
        rb1=.false.
      end if
      if (rb1) then
        nrm=nrm1
      else
        nrm=nr
      end if
      allocate (map_rh(0:nproc-1))
      allocate (map_rm(0:nproc-1))
      if (rb0) then
        i0_h=1
      else
        i0_h=2
      end if
      if (rb1) then
        i1_h=nr
      else
        i1_h=nrm1
      end if
      if (rb0) then
        i0_m=1
      else
        i0_m=2
      end if
      i1_m=nrm1
      map_rh(iproc)%i0=i0_h
      map_rh(iproc)%i1=i1_h
      map_rm(iproc)%i0=i0_m
      map_rm(iproc)%i1=i1_m
      map_rh(iproc)%offset=i0_g+map_rh(iproc)%i0-1
      map_rh(iproc)%n=map_rh(iproc)%i1-map_rh(iproc)%i0+1
      map_rm(iproc)%offset=i0_g+map_rm(iproc)%i0-1
      map_rm(iproc)%n=map_rm(iproc)%i1-map_rm(iproc)%i0+1
      call gather_mapping_info (map_rh)
      call gather_mapping_info (map_rm)
end subroutine
subroutine decompose_mesh_tp
      use global_dims
      use local_dims
      use decomposition
      use mpidefs
      implicit none
      integer :: ierr,j,k
      integer :: j0_h,j1_h,j0_m,j1_m
      integer :: k0_h,k1_h,k0_m,k1_m
      integer, dimension(nproc_t) :: mp_t
      integer, dimension(nproc_p) :: mp_p
      call decompose_dimension (nt_g,nproc_t,mp_t,ierr)
      if (ierr.ne.0) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in DECOMPOSE_MESH_TP:'
          write (*,*) '### Anomaly in decomposing the mesh'// &
                      ' between processors.'
          write (*,*) '### Could not decompose the theta mesh.'
          write (*,*) 'Number of mesh points in theta = ',nt_g
          write (*,*) 'Number of processors along theta = ',nproc_t
        end if
        call endrun (.true.)
      end if
      call decompose_dimension (np_g,nproc_p,mp_p,ierr)
      if (ierr.ne.0) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in DECOMPOSE_MESH_TP:'
          write (*,*) '### Anomaly in decomposing the mesh'// &
                      ' between processors.'
          write (*,*) '### Could not decompose the phi mesh.'
          write (*,*) 'Number of mesh points in phi = ',np_g
          write (*,*) 'Number of processors along phi = ',nproc_p
        end if
        call endrun (.true.)
      end if
      call check_mesh_topology (nproc_t,mp_t,1,'theta')
      call check_mesh_topology (nproc_p,mp_p,1,'phi')
      if (np_g.eq.3) then
        axisymmetric=.true.
      else
        axisymmetric=.false.
      end if
      j0_g=1
      do j=1,iproc_t
        j0_g=j0_g+mp_t(j)
      enddo
      nt=mp_t(iproc_t+1)+2
      j1_g=j0_g+nt-1
      k0_g=1
      do k=1,iproc_p
        k0_g=k0_g+mp_p(k)
      enddo
      np=mp_p(iproc_p+1)+2
      k1_g=k0_g+np-1
      ntm1=nt-1
      npm1=np-1
      if (iproc_t.eq.0) then
        tb0=.true.
      else
        tb0=.false.
      end if
      if (iproc_t.eq.nproc_t-1) then
        tb1=.true.
      else
        tb1=.false.
      end if
      if (tb1) then
        ntm=ntm1
      else
        ntm=nt
      end if
      npm=np
      allocate (map_th(0:nproc-1))
      allocate (map_tm(0:nproc-1))
      allocate (map_ph(0:nproc-1))
      allocate (map_pm(0:nproc-1))
      if (tb0) then
        j0_h=1
      else
        j0_h=2
      end if
      if (tb1) then
        j1_h=nt
      else
        j1_h=ntm1
      end if
      if (tb0) then
        j0_m=1
      else
        j0_m=2
      end if
      j1_m=ntm1
      if (iproc_p.eq.0) then
        k0_m=1
      else
        k0_m=2
      end if
      k1_m=npm1
      if (iproc_p.eq.0) then
        k0_h=1
      else
        k0_h=2
      end if
      if (iproc_p.eq.nproc_p-1) then
        k1_h=np
      else
        k1_h=npm1
      end if
      map_th(iproc)%i0=j0_h
      map_th(iproc)%i1=j1_h
      map_tm(iproc)%i0=j0_m
      map_tm(iproc)%i1=j1_m
      map_ph(iproc)%i0=k0_h
      map_ph(iproc)%i1=k1_h
      map_pm(iproc)%i0=k0_m
      map_pm(iproc)%i1=k1_m
      map_th(iproc)%offset=j0_g+map_th(iproc)%i0-1
      map_th(iproc)%n=map_th(iproc)%i1-map_th(iproc)%i0+1
      map_tm(iproc)%offset=j0_g+map_tm(iproc)%i0-1
      map_tm(iproc)%n=map_tm(iproc)%i1-map_tm(iproc)%i0+1
      map_ph(iproc)%offset=k0_g+map_ph(iproc)%i0-1
      map_ph(iproc)%n=map_ph(iproc)%i1-map_ph(iproc)%i0+1
      map_pm(iproc)%offset=k0_g+map_pm(iproc)%i0-1
      map_pm(iproc)%n=map_pm(iproc)%i1-map_pm(iproc)%i0+1
      call gather_mapping_info (map_th)
      call gather_mapping_info (map_tm)
      call gather_mapping_info (map_ph)
      call gather_mapping_info (map_pm)
end subroutine
subroutine check_mesh_dimensions (nr_g,nt_g,np_g)
      use mpidefs
      implicit none
      integer :: nr_g,nt_g,np_g
      if (nr_g.lt.4) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in CHECK_MESH_DIMENSIONS:'
          write (*,*) '### Invalid number of r mesh points'// &
                    ' requested.'
          write (*,*) '### The minimum number of mesh points is 4.'
          write (*,*)
          write (*,*) 'Number of mesh points requested = ',nr_g
        end if
        call endrun (.true.)
      end if
      if (nt_g.lt.4) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in CHECK_MESH_DIMENSIONS:'
          write (*,*) '### Invalid number of theta mesh points'// &
                    ' requested.'
          write (*,*) '### The minimum number of mesh points is 4.'
          write (*,*)
          write (*,*) 'Number of mesh points requested = ',nt_g
        end if
        call endrun (.true.)
      end if
      if (np_g.lt.3) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in CHECK_MESH_DIMENSIONS:'
          write (*,*) '### Invalid number of phi mesh points'// &
                    ' requested.'
          write (*,*) '### The minimum number of mesh points is 3.'
          write (*,*)
          write (*,*) 'Number of mesh points requested = ',np_g
        end if
        call endrun (.true.)
      end if
end subroutine
subroutine decompose_dimension (nx,np,mp,ierr)
      implicit none
      integer :: nx
      integer :: np
      integer, dimension(np) :: mp
      integer :: ierr
      integer :: nxm2,mpav,nrem
      ierr=0
      nxm2=nx-2
      if (nxm2.le.0) then
        ierr=1
        return
      end if
      if (np.le.0) then
        ierr=2
        return
      end if
      mpav=nxm2/np
      mp(:)=mpav
      nrem=nxm2-mpav*np
      mp(1:nrem)=mp(1:nrem)+1
end subroutine
subroutine check_mesh_topology (np,mp,min_pts,coord)
      use mpidefs
      implicit none
      integer :: np
      integer, dimension(np) :: mp
      integer :: min_pts
      character(*) :: coord
      integer :: i
      do i=1,np
        if (mp(i).lt.min_pts) then
          if (iamp0) then
            write (*,*)
            write (*,*) '### ERROR in CHECK_MESH_TOPOLOGY:'
            write (*,*) '### Mesh topology specification error.'
            write (*,*) 'Invalid number of ',coord, &
                        ' mesh points requested.'
            write (*,*) 'Processor index = ',i
            write (*,*) 'Number of mesh points requested = ',mp(i)
            write (*,*) 'Minimum number of mesh points allowed = ', &
                        min_pts
          end if
          call endrun (.true.)
        end if
      enddo
end subroutine
subroutine gather_mapping_info (map)
      use mpidefs
      use decomposition
      implicit none
      type(map_struct), dimension(0:nproc-1) :: map
      integer, parameter :: lbuf=4
      integer, dimension(lbuf) :: sbuf
      integer, dimension(lbuf,0:nproc-1) :: rbuf
      integer :: ierr,irank
      sbuf(1)=map(iproc)%n
      sbuf(2)=map(iproc)%i0
      sbuf(3)=map(iproc)%i1
      sbuf(4)=map(iproc)%offset
      call MPI_Allgather (sbuf,lbuf,MPI_INTEGER, &
                          rbuf,lbuf,MPI_INTEGER,comm_all,ierr)
      do irank=0,nproc-1
        map(irank)%n     =rbuf(1,irank)
        map(irank)%i0    =rbuf(2,irank)
        map(irank)%i1    =rbuf(3,irank)
        map(irank)%offset=rbuf(4,irank)
      enddo
end subroutine
subroutine allocate_global_arrays
      use global_dims
      use global_mesh
      implicit none
      allocate (r_g (nrm1_g))
      allocate (dr_g(nrm1_g))
      allocate (rh_g (nr_g))
      allocate (drh_g(nr_g))
      allocate (t_g (ntm1_g))
      allocate (dt_g(ntm1_g))
      allocate (th_g (nt_g))
      allocate (dth_g(nt_g))
      allocate (p_g  (np_g))
      allocate (dp_g (np_g))
      allocate (ph_g (np_g))
      allocate (dph_g(np_g))
      allocate (st_g(ntm1_g))
      allocate (ct_g(ntm1_g))
      allocate (sth_g(nt_g))
      allocate (cth_g(nt_g))
      allocate (sp_g (np_g))
      allocate (cp_g (np_g))
      allocate (sph_g(np_g))
      allocate (cph_g(np_g))
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
      allocate (drh(nr))
      allocate (r_i (nrm))
      allocate (dr_i(nrm))
      allocate (rh_i (nr))
      allocate (drh_i(nr))
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
subroutine set_global_mesh
      use number_types
      use global_dims
      use global_mesh
      use meshdef
      use mpidefs
      implicit none
      real(r_typ), parameter :: zero=0._r_typ
      real(r_typ), parameter :: one=1._r_typ
      real(r_typ), parameter :: half=.5_r_typ
      integer :: i,j,k
      call genmesh (9,'r',nrm1_g,r0,r1,nmseg,rfrac,drratio,nfrmesh, &
                    .false.,zero,r_g)
      do i=2,nrm1_g
        rh_g(i)=.5*(r_g(i)+r_g(i-1))
        drh_g(i)=r_g(i)-r_g(i-1)
      enddo
      rh_g(1)=rh_g(2)-drh_g(2)
      rh_g(nr_g)=rh_g(nrm1_g)+drh_g(nrm1_g)
      drh_g(1)=drh_g(2)
      drh_g(nr_g)=drh_g(nrm1_g)
      do i=1,nrm1_g
        dr_g(i)=rh_g(i+1)-rh_g(i)
      enddo
      call genmesh (9,'t',ntm1_g,t0,t1,nmseg,tfrac,dtratio, &
                    nftmesh,.false.,zero,t_g)
      do j=2,ntm1_g
        th_g(j)=.5*(t_g(j)+t_g(j-1))
        dth_g(j)=t_g(j)-t_g(j-1)
      enddo
      th_g(1)=th_g(2)-dth_g(2)
      th_g(nt_g)=th_g(ntm1_g)+dth_g(ntm1_g)
      dth_g(1)=dth_g(2)
      dth_g(nt_g)=dth_g(ntm1_g)
      do j=1,ntm1_g
        dt_g(j)=th_g(j+1)-th_g(j)
      enddo
      call genmesh (9,'p',npm1_g,p0,p1,nmseg,pfrac,dpratio, &
                    nfpmesh,.true.,phishift,p_g)
      p_g(np_g)=p_g(2)+pl
      do k=2,np_g
        ph_g(k)=half*(p_g(k)+p_g(k-1))
        dph_g(k)=p_g(k)-p_g(k-1)
      enddo
      ph_g(1)=ph_g(npm1_g)-pl
      dph_g(1)=dph_g(npm1_g)
      do k=1,npm1_g
        dp_g(k)=ph_g(k+1)-ph_g(k)
      enddo
      dp_g(np_g)=dp_g(2)
      dph_g(np_g)=dph_g(2)
      dp_g(1)=dp_g(npm1_g)
      st_g(:)=sin(t_g(:))
      ct_g(:)=cos(t_g(:))
      sth_g(:)=sin(th_g(:))
      cth_g(:)=cos(th_g(:))
      sp_g(:)=sin(p_g(:))
      cp_g(:)=cos(p_g(:))
      sph_g(:)=sin(ph_g(:))
      cph_g(:)=cos(ph_g(:))
      if (axisymmetric) then
        sp_g(2)=0.
        cp_g(2)=one
        sph_g(2)=0.
        cph_g(2)=-one
      end if
      sph_g(1)=sph_g(npm1_g)
      sph_g(np_g)=sph_g(2)
      cph_g(1)=cph_g(npm1_g)
      cph_g(np_g)=cph_g(2)
      sp_g(1)=sp_g(npm1_g)
      sp_g(np_g)=sp_g(2)
      cp_g(1)=cp_g(npm1_g)
      cp_g(np_g)=cp_g(2)
end subroutine
subroutine genmesh (io,label,nc,c0,c1,nseg,frac,dratio,nfilt,periodic, &
                    c_shift,c)
      use number_types
      use mpidefs
      use debug
      implicit none
      integer, intent(in) :: io
      character(*), intent(in) :: label
      integer, intent(in) :: nc
      real(r_typ), intent(in) :: c0,c1
      integer, intent(in) :: nseg
      real(r_typ), dimension(nseg), intent(in) :: frac,dratio
      integer, intent(in) :: nfilt
      logical, intent(in) :: periodic
      real(r_typ), intent(in) :: c_shift
      real(r_typ), dimension(nc), intent(out) :: c
      integer :: ns
      real(r_typ), dimension(:), allocatable :: xi,cs,a,r,f
      real(r_typ), parameter :: zero=0._r_typ
      real(r_typ), parameter :: one=1._r_typ
      real(r_typ), parameter :: half=.5_r_typ
      real(r_typ), parameter :: eps=1.e-5_r_typ
      integer :: i,j,nf,nr,ll,j0
      real(r_typ) :: alpha,dr,fac,d,dxi,xiv,cshft,xi_shift
      real(r_typ), dimension(:), allocatable :: dc,rdc
      if (nc.lt.2) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in GENMESH:'
          write (*,*) '### Invalid number of mesh points specified.'
          write (*,*) '### There must be at least two mesh points.'
          write (*,*) 'Mesh coordinate: ',label
          write (*,*) 'Number of mesh points specified = ',nc
        end if
        call endrun (.true.)
      end if
      if (c0.ge.c1) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in GENMESH:'
          write (*,*) '### Invalid mesh interval specified.'
          write (*,*) '### C1 must be greater than C0.'
          write (*,*) 'Mesh coordinate: ',label
          write (*,*) 'C0 = ',c0
          write (*,*) 'C1 = ',c1
        end if
        call endrun (.true.)
      end if
      do nf=1,nseg-1
        if (frac(nf+1).eq.zero) exit
      enddo
      if (nf.eq.1.and.frac(1).eq.zero) then
        ns=1
        allocate (cs(ns+1))
        allocate (r(ns))
        cs(1)=c0
        cs(2)=c1
        r(1)=one
        go to 100
      end if
      do i=2,nf
        if (frac(i).lt.frac(i-1)) then
          if (iamp0) then
            write (*,*)
            write (*,*) '### ERROR in GENMESH:'
            write (*,*) '### Invalid mesh specification.'
            write (*,*) 'Mesh coordinate: ',label
            write (*,*) 'The values in FRAC must increase'// &
                       ' monotonically.'
            write (*,*) 'FRAC = ',frac(1:nf)
          end if
          call endrun (.true.)
        end if
      enddo
      if (periodic) then
        if (frac(1).lt.zero.or.frac(nf).gt.one) then
          if (iamp0) then
            write (*,*)
            write (*,*) '### ERROR in GENMESH:'
            write (*,*) '### Invalid mesh specification.'
            write (*,*) 'Mesh coordinate: ',label
            write (*,*) 'For a periodic coordinate, the values in'// &
                       ' FRAC must be between 0. and 1.'
            write (*,*) 'FRAC = ',frac(1:nf)
          end if
          call endrun (.true.)
        end if
        if (frac(1).eq.zero.and.frac(nf).eq.one) then
          if (iamp0) then
            write (*,*)
            write (*,*) '### ERROR in GENMESH:'
            write (*,*) '### Invalid mesh specification.'
            write (*,*) 'Mesh coordinate: ',label
            write (*,*) 'For a periodic coordinate, FRAC must not'// &
                        ' contain both 0. and 1.'
            write (*,*) 'FRAC = ',frac(1:nf)
          end if
          call endrun (.true.)
        end if
      else
        if (frac(1).ne.zero) then
          if (iamp0) then
            write (*,*)
            write (*,*) '### ERROR in GENMESH:'
            write (*,*) '### Invalid mesh specification.'
            write (*,*) 'Mesh coordinate: ',label
            write (*,*) 'For a non-periodic coordinate, the first'// &
                      ' value of FRAC must equal 0.'
            write (*,*) 'FRAC = ',frac(1:nf)
          end if
          call endrun (.true.)
        end if
        if (frac(nf).ne.one) then
          if (iamp0) then
            write (*,*)
            write (*,*) '### ERROR in GENMESH:'
            write (*,*) '### Invalid mesh specification.'
            write (*,*) 'Mesh coordinate: ',label
            write (*,*) 'For a non-periodic coordinate, the last'// &
                        ' value of FRAC must equal 1.'
            write (*,*) 'FRAC = ',frac(1:nf)
          end if
          call endrun (.true.)
        end if
      end if
      if (periodic) then
        nr=nf
      else
        nr=nf-1
      end if
      do i=1,nr
        if (dratio(i).le.zero) then
          if (iamp0) then
            write (*,*)
            write (*,*) '### ERROR in GENMESH:'
            write (*,*) '### Invalid mesh specification.'
            write (*,*) 'Mesh coordinate: ',label
            write (*,*) 'A required value in DRATIO has not been'// &
                        ' set or is not positive.'
            write (*,*) 'DRATIO = ',dratio(1:nr)
          end if
          call endrun (.true.)
        end if
      enddo
      if (periodic.and.nr.eq.1.and.dratio(1).ne.one) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### WARNING from GENMESH:'
          write (*,*) '### Discontinuous mesh specification.'
          write (*,*) 'Mesh coordinate: ',label
          write (*,*) 'An inherently discontinuous mesh has been'// &
                      ' specified.'
          write (*,*) 'FRAC = ',frac(1:nf)
          write (*,*) 'DRATIO = ',dratio(1:nr)
        end if
      end if
      ns=nf-1
      if (periodic) then
        if (frac(1).ne.zero) ns=ns+1
        if (frac(nf).ne.one) ns=ns+1
      end if
      allocate (cs(ns+1))
      allocate (r(ns))
      if (periodic) then
        if (frac(1).ne.zero) then
          cs(1)=c0
          cs(2:nf+1)=c0+(c1-c0)*frac(1:nf)
          if (frac(nf).ne.one) then
            alpha=(one-frac(nf))/(frac(1)+one-frac(nf))
            r(1)=dratio(nr)/(one+alpha*(dratio(nr)-one))
            r(2:nr+1)=dratio(1:nr)
            cs(ns+1)=c1
            r(ns)=one+alpha*(dratio(nr)-one)
          else
            r(1)=dratio(nr)
            r(2:nr)=dratio(1:nr-1)
          end if
        else
          cs(1:nf)=c0+(c1-c0)*frac(1:nf)
          r(1:nr)=dratio(1:nr)
          cs(ns+1)=c1
        end if
      else
        cs(1:nf)=c0+(c1-c0)*frac(1:nf)
        r(1:nr)=dratio(1:nr)
      end if
  100 continue
      allocate (xi(ns+1))
      allocate (a(ns))
      allocate (f(ns))
      do i=1,ns
        dr=r(i)-one
        if (abs(dr).lt.eps) then
          f(i)=(cs(i+1)-cs(i))*(one+half*dr)
        else
          f(i)=(cs(i+1)-cs(i))*log(r(i))/dr
        end if
      enddo
      fac=zero
      do i=ns,1,-1
        fac=fac/r(i)+f(i)
      enddo
      d=f(1)/fac
      xi(1)=zero
      do i=2,ns
        xi(i)=xi(i-1)+d
        if (i.lt.ns) d=d*f(i)/(f(i-1)*r(i-1))
      enddo
      xi(ns+1)=one
      do i=1,ns
        a(i)=log(r(i))/(xi(i+1)-xi(i))
      enddo
      if (periodic) then
        cshft=-c_shift
        call map_c_to_xi (periodic,ns,xi,cs,a,r,cshft,xi_shift)
      else
        xi_shift=0.
      end if
      dxi=one/(nc-one)
      c(1)=c0
      do j=2,nc-1
        xiv=(j-1)*dxi
        call map_xi_to_c (periodic,ns,xi,cs,a,r,cshft,xi_shift,xiv,c(j))
      enddo
      c(nc)=c1
      if (nfilt.gt.0) then
        do i=1,nfilt
          if (periodic) then
            call filter_coord_periodic (c1-c0,nc,c)
          else
            call filter_coord (nc,c)
          end if
        enddo
      end if
      if (io.gt.0.and.iamp0) then
        write (io,*)
        write (io,*) '### COMMENT from GENMESH:'
        write (io,*) '### Mesh information for coordinate ',label,':'
        if (idebug.gt.0) then
          write (io,*)
          write (io,*) 'Flag to indicate a periodic mesh: ',periodic
          write (io,*) 'Number of mesh points = ',nc
          write (io,*) 'Lower mesh limit = ',c0
          write (io,*) 'Upper mesh limit = ',c1
          write (io,*) 'Number of times to filter the mesh = ',nfilt
          if (periodic) then
            write (io,*) 'Amount to shift the mesh = ',c_shift
          end if
        end if
        write (io,*)
        write (io,*) 'Number of mesh segments = ',ns
        ll=len_trim(label)
        write (io,900) 'Segment      xi0       xi1'//   &
                       repeat (' ',16-ll)//label//'0'// &
                       repeat (' ',16-ll)//label//'1'// &
                       '            ratio'
        do i=1,ns
          write (io,910) i,xi(i),xi(i+1),cs(i),cs(i+1),r(i)
        enddo
        allocate (dc(nc))
        allocate (rdc(nc))
        dc=c-cshift(c,-1)
        if (periodic) dc(1)=dc(nc)
        rdc=dc/cshift(dc,-1)
        if (periodic) rdc(1)=rdc(nc)
        write (io,*)
        write (io,920) 'Mesh-point locations:'
        write (io,920) '     i'//                         &
                       repeat (' ',18-ll)//label//        &
                       repeat (' ',17-ll)//'d'//label//   &
                       '             ratio'
        if (periodic) then
          j0=1
        else
          j0=3
          write (io,930) 1,c(1)
          write (io,930) 2,c(2),dc(2)
        end if
        do j=j0,nc
          write (io,930) j,c(j),dc(j),rdc(j)
        enddo
        deallocate (dc)
        deallocate (rdc)
      end if
  900 format (/,tr1,a)
  910 format (tr1,i4,2x,2f10.6,4f17.8)
  920 format (tr1,a)
  930 format (tr1,i6,3f18.8)
      deallocate (cs)
      deallocate (r)
      deallocate (xi)
      deallocate (a)
      deallocate (f)
end subroutine
subroutine map_xi_to_c (periodic,ns,xi,cs,a,r,cshft,xi_shift,xiv,cv)
      use number_types
      use mpidefs
      implicit none
      logical, intent(in) :: periodic
      integer, intent(in) :: ns
      real(r_typ), dimension(ns+1), intent(in) :: xi,cs
      real(r_typ), dimension(ns), intent(in) :: a,r
      real(r_typ), intent(in) :: cshft,xi_shift
      real(r_typ), intent(in) :: xiv
      real(r_typ), intent(out) :: cv
      real(r_typ), parameter :: zero=0._r_typ
      real(r_typ), parameter :: one=1._r_typ
      real(r_typ), parameter :: half=.5_r_typ
      real(r_typ), parameter :: eps=1.e-5_r_typ
      integer :: i
      real(r_typ) :: xiv_p,d,d1,da,da1,fac
      real(r_typ), external :: fold
      if (periodic) then
        xiv_p=xiv+xi_shift
        xiv_p=fold(zero,one,xiv_p)
      else
        xiv_p=xiv
      end if
      do i=1,ns
        if (xiv_p.ge.xi(i).and.xiv_p.le.xi(i+1)) exit
      enddo
      if (i.gt.ns) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in MAP_XI_TO_C:'
          write (*,*) '### Error in finding the XI segment.'
          write (*,*) '### Could not find XIV in the XI table.'
          write (*,*) '[Utility routine for GENMESH.]'
          write (*,*) '[This is an internal error.]'
          write (*,*) 'XI = ',xi
          write (*,*) 'XIV = ',xiv
          write (*,*) 'XIV_P = ',xiv_p
        end if
        call endrun (.true.)
      end if
      d =xiv_p  -xi(i)
      d1=xi(i+1)-xi(i)
      da =a(i)*d
      da1=a(i)*d1
      if (abs(da1).lt.eps) then
        fac=(d*(one+half*da))/(d1*(one+half*da1))
      else
        fac=(exp(da)-one)/(r(i)-one)
      end if
      cv=cs(i)+(cs(i+1)-cs(i))*fac
      if (periodic) then
        cv=cv-cshft
        cv=fold(cs(1),cs(ns+1),cv)
      end if
end subroutine
subroutine map_c_to_xi (periodic,ns,xi,cs,a,r,cv,xiv)
      use number_types
      use mpidefs
      implicit none
      logical, intent(in) :: periodic
      integer, intent(in) :: ns
      real(r_typ), dimension(ns+1), intent(in) :: xi,cs
      real(r_typ), dimension(ns), intent(in) :: a,r
      real(r_typ), intent(in) :: cv
      real(r_typ), intent(out) :: xiv
      real(r_typ), parameter :: one=1._r_typ
      real(r_typ), parameter :: eps=1.e-5_r_typ
      integer :: i
      real(r_typ) :: cv_p,d,da,fac
      real(r_typ), external :: fold
      if (periodic) then
        cv_p=fold(cs(1),cs(ns+1),cv)
      else
        cv_p=cv
      end if
      do i=1,ns
        if (cv_p.ge.cs(i).and.cv_p.le.cs(i+1)) exit
      enddo
      if (i.gt.ns) then
        if (iamp0) then
          write (*,*)
          write (*,*) '### ERROR in MAP_C_TO_XI:'
          write (*,*) '### Error in finding the CS segment.'
          write (*,*) '### Could not find CV in the CS table.'
          write (*,*) '[Utility routine for GENMESH.]'
          write (*,*) '[This is an internal error.]'
          write (*,*) 'CS = ',cs
          write (*,*) 'CV = ',cv
          write (*,*) 'CV_P = ',cv_p
        end if
        call endrun (.true.)
      end if
      d=(cv_p-cs(i))/(cs(i+1)-cs(i))
      da=(r(i)-one)*d
      if (abs(da).lt.eps) then
        fac=d*(xi(i+1)-xi(i))
      else
        fac=log(da+one)/a(i)
      end if
      xiv=xi(i)+fac
end subroutine
subroutine filter_coord (n,f)
      use number_types
      implicit none
      integer :: n
      real(r_typ), dimension(n) :: f
      real(r_typ), parameter :: two=2._r_typ
      real(r_typ), parameter :: quarter=.25_r_typ
      real(r_typ), dimension(n) :: ff
      integer :: i
      ff=f
      do i=2,n-1
        f(i)=quarter*(ff(i-1)+two*ff(i)+ff(i+1))
      enddo
end subroutine
subroutine filter_coord_periodic (xl,n,f)
      use number_types
      implicit none
      real(r_typ) :: xl
      integer :: n
      real(r_typ), dimension(n) :: f
      real(r_typ), parameter :: two=2._r_typ
      real(r_typ), parameter :: quarter=.25_r_typ
      real(r_typ), dimension(0:n+1) :: ff
      integer :: i
      real(r_typ) :: f1old,f1new
      f1old=f(1)
      ff(1:n)=f(:)
      ff(0)=f(n-1)-xl
      ff(n+1)=f(2)+xl
      do i=1,n
        f(i)=quarter*(ff(i-1)+two*ff(i)+ff(i+1))
      enddo
      f1new=f(1)
      do i=1,n
        f(i)=f(i)-f1new+f1old
      enddo
end subroutine
function fold (x0,x1,x)
      use number_types
      implicit none
      real(r_typ) :: fold
      real(r_typ) :: x0,x1,x
      real(r_typ) :: xl
      fold=x
      if (x0.eq.x1) return
      xl=x1-x0
      fold=mod(x-x0,xl)+x0
      if (fold.lt.x0) fold=fold+xl
      if (fold.ge.x1) fold=fold-xl
      return
end function
subroutine set_flux
      use number_types
      use global_dims
      use global_mesh
      use local_dims
      use local_mesh
      use fields
      use vars
      use mpidefs
      use timing
      implicit none
      real(r_typ), dimension(:,:), allocatable :: br0_g
      integer :: j,k,ierr
      allocate (br0_g(nt_g,np_g))
      if (iamp0) then
        call readbr (br0file,br0_g,ierr)
      end if
      deallocate(br0_g)
end subroutine
subroutine lusol (N,M,x,LU,LU_ja,N1,N2,LUd_i)
      use number_types
      use number_types_pc
      implicit none
      real(r_typ_pc) :: x(N),LUd_i(N),LU(M)
      integer :: N1(N),N2(N),LU_ja(M)
      integer :: N,M
      integer :: i,k,k1,k2
      k2=0
      do i=1,N
        k1=k2+1
        k2=k1+N1(i)
        do k=k1,k2
          x(i)=x(i)-LU(k)*x(LU_ja(k))
        enddo
      enddo
      do i=N,1,-1
        k1=k2+1
        k2=k1+N2(i)
        do k=k1,k2
          x(i)=x(i)-LU(k)*x(LU_ja(k))
        enddo
        x(i)=x(i)*LUd_i(i)
      enddo
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
      real(r_typ) :: sum0,sum1,area,fluxp,fluxm,da,br00err
      ierr=0
      write (*,*)
      write (*,*) '### COMMENT from READBR:'
      write (*,*) '### Reading Br file: ',trim(fname)
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
      area=0.
      fluxp=0.
      fluxm=0.
      do j=2,ntm1_g
        do k=2,npm1_g
          da=sth_g(j)*dth_g(j)*dph_g(k)
          if (br0_g(j,k).gt.0.) then
            fluxp=fluxp+br0_g(j,k)*da
          else
            fluxm=fluxm+br0_g(j,k)*da
          end if
          area=area+da
        enddo
      enddo
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
      if (icheck.ne.0) then
        if (n.le.0) then
          write (*,*)
          write (*,*) '### ERROR in FLINT:'
          write (*,*) '### Bad dimension of abscissa table.'
          write (*,*) 'N = ',n
          ierr=1
          return
        end if
        do 100 i=1,n-1
          if (xn(i+1).le.xn(i)) then
            write (*,*)
            write (*,*) '### ERROR in FLINT:'
            write (*,*) '### Bad data in abscissa table.'
            write (*,*) 'N = ',n
            write (*,*) 'XN = '
            write (*,*) (xn(j),j=1,n)
            ierr=1
            return
          end if
  100   continue
        return
      end if
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
