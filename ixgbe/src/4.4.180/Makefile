obj-m += mdio.o
obj-m += ixgbe.o

ixgbe-objs := ixgbe_main.o ixgbe_common.o ixgbe_ethtool.o \
              ixgbe_82599.o ixgbe_82598.o ixgbe_phy.o ixgbe_sriov.o \
              ixgbe_mbx.o ixgbe_x540.o ixgbe_x550.o ixgbe_lib.o ixgbe_ptp.o

ixgbe-n +=  ixgbe_dcb.o ixgbe_dcb_82598.o \
                              ixgbe_dcb_82599.o ixgbe_dcb_nl.o

ixgbe-n += ixgbe_sysfs.o
ixgbe-y += ixgbe_debugfs.o
ixgbe-n += ixgbe_fcoe.o
