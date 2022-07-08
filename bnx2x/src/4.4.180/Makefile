obj-m += mdio.o
obj-m += bnx2x.o

bnx2x-y := bnx2x_main.o bnx2x_link.o bnx2x_cmn.o bnx2x_ethtool.o bnx2x_stats.o bnx2x_dcb.o bnx2x_sp.o
ifeq ($(PLATFORM),APOLLOLAKE)
  bnx2x-n += bnx2x_vfpf.o bnx2x_sriov.o
else
  ifeq ($(PLATFORM),GEMINILAKE)
    bnx2x-n += bnx2x_vfpf.o bnx2x_sriov.o
  else
    bnx2x-y += bnx2x_vfpf.o bnx2x_sriov.o
  endif
endif
