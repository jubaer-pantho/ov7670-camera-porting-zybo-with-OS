
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z010clg400-1

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set config_finished [ create_bd_port -dir O config_finished ]
  set d [ create_bd_port -dir I -from 7 -to 0 d ]
  set href [ create_bd_port -dir I href ]
  set i [ create_bd_port -dir I i ]
  set pclk [ create_bd_port -dir I pclk ]
  set pwdn [ create_bd_port -dir O pwdn ]
  set reset [ create_bd_port -dir O -type rst reset ]
  set sioc [ create_bd_port -dir O sioc ]
  set siod [ create_bd_port -dir IO siod ]
  set vsync [ create_bd_port -dir I vsync ]
  set xclk [ create_bd_port -dir O xclk ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]

  # Create instance: axi_protocol_converter_0, and set properties
  set axi_protocol_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_0 ]

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_vdma_0 ]
  set_property -dict [ list \
CONFIG.c_include_mm2s {0} \
CONFIG.c_m_axi_s2mm_data_width {32} \
CONFIG.c_mm2s_genlock_mode {0} \
 ] $axi_vdma_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {151.636} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: debounce_0, and set properties
  set debounce_0 [ create_bd_cell -type ip -vlnv user.org:user:debounce:1.0 debounce_0 ]

  # Create instance: ov7670_axi_stream_capture_0, and set properties
  set ov7670_axi_stream_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ov7670_axi_stream_capture:1.0 ov7670_axi_stream_capture_0 ]

  # Create instance: ov7670_controller_0, and set properties
  set ov7670_controller_0 [ create_bd_cell -type ip -vlnv user.org:user:ov7670_controller:1.0 ov7670_controller_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {650} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {50.000000} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} \
CONFIG.PCW_EN_RST1_PORT {1} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_MIO_0_PULLUP {enabled} \
CONFIG.PCW_MIO_10_PULLUP {enabled} \
CONFIG.PCW_MIO_11_PULLUP {enabled} \
CONFIG.PCW_MIO_12_PULLUP {enabled} \
CONFIG.PCW_MIO_16_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {fast} \
CONFIG.PCW_MIO_17_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {fast} \
CONFIG.PCW_MIO_18_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {fast} \
CONFIG.PCW_MIO_19_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {fast} \
CONFIG.PCW_MIO_1_PULLUP {disabled} \
CONFIG.PCW_MIO_1_SLEW {fast} \
CONFIG.PCW_MIO_20_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {fast} \
CONFIG.PCW_MIO_21_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {fast} \
CONFIG.PCW_MIO_22_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {fast} \
CONFIG.PCW_MIO_23_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {fast} \
CONFIG.PCW_MIO_24_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {fast} \
CONFIG.PCW_MIO_25_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {fast} \
CONFIG.PCW_MIO_26_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {fast} \
CONFIG.PCW_MIO_27_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {fast} \
CONFIG.PCW_MIO_28_PULLUP {disabled} \
CONFIG.PCW_MIO_28_SLEW {fast} \
CONFIG.PCW_MIO_29_PULLUP {disabled} \
CONFIG.PCW_MIO_29_SLEW {fast} \
CONFIG.PCW_MIO_2_SLEW {fast} \
CONFIG.PCW_MIO_30_PULLUP {disabled} \
CONFIG.PCW_MIO_30_SLEW {fast} \
CONFIG.PCW_MIO_31_PULLUP {disabled} \
CONFIG.PCW_MIO_31_SLEW {fast} \
CONFIG.PCW_MIO_32_PULLUP {disabled} \
CONFIG.PCW_MIO_32_SLEW {fast} \
CONFIG.PCW_MIO_33_PULLUP {disabled} \
CONFIG.PCW_MIO_33_SLEW {fast} \
CONFIG.PCW_MIO_34_PULLUP {disabled} \
CONFIG.PCW_MIO_34_SLEW {fast} \
CONFIG.PCW_MIO_35_PULLUP {disabled} \
CONFIG.PCW_MIO_35_SLEW {fast} \
CONFIG.PCW_MIO_36_PULLUP {disabled} \
CONFIG.PCW_MIO_36_SLEW {fast} \
CONFIG.PCW_MIO_37_PULLUP {disabled} \
CONFIG.PCW_MIO_37_SLEW {fast} \
CONFIG.PCW_MIO_38_PULLUP {disabled} \
CONFIG.PCW_MIO_38_SLEW {fast} \
CONFIG.PCW_MIO_39_PULLUP {disabled} \
CONFIG.PCW_MIO_39_SLEW {fast} \
CONFIG.PCW_MIO_3_SLEW {fast} \
CONFIG.PCW_MIO_40_PULLUP {disabled} \
CONFIG.PCW_MIO_40_SLEW {fast} \
CONFIG.PCW_MIO_41_PULLUP {disabled} \
CONFIG.PCW_MIO_41_SLEW {fast} \
CONFIG.PCW_MIO_42_PULLUP {disabled} \
CONFIG.PCW_MIO_42_SLEW {fast} \
CONFIG.PCW_MIO_43_PULLUP {disabled} \
CONFIG.PCW_MIO_43_SLEW {fast} \
CONFIG.PCW_MIO_44_PULLUP {disabled} \
CONFIG.PCW_MIO_44_SLEW {fast} \
CONFIG.PCW_MIO_45_PULLUP {disabled} \
CONFIG.PCW_MIO_45_SLEW {fast} \
CONFIG.PCW_MIO_47_PULLUP {disabled} \
CONFIG.PCW_MIO_48_PULLUP {disabled} \
CONFIG.PCW_MIO_49_PULLUP {disabled} \
CONFIG.PCW_MIO_4_SLEW {fast} \
CONFIG.PCW_MIO_50_DIRECTION {inout} \
CONFIG.PCW_MIO_50_PULLUP {disabled} \
CONFIG.PCW_MIO_51_DIRECTION {inout} \
CONFIG.PCW_MIO_51_PULLUP {disabled} \
CONFIG.PCW_MIO_52_PULLUP {disabled} \
CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_PULLUP {disabled} \
CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_SLEW {fast} \
CONFIG.PCW_MIO_6_SLEW {fast} \
CONFIG.PCW_MIO_8_SLEW {fast} \
CONFIG.PCW_MIO_9_PULLUP {enabled} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.176} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.159} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.162} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.187} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.034} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.03} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.082} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {525} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K128M16 JT-125} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 46} \
CONFIG.PCW_USE_DMA0 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
 ] $processing_system7_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins axi_vdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_protocol_converter_0_M_AXI [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins axi_protocol_converter_0/M_AXI]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_protocol_converter_0/S_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_protocol_converter_0/aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_protocol_converter_0/aresetn] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net Net1 [get_bd_ports siod] [get_bd_pins ov7670_controller_0/siod]
  connect_bd_net -net S00_ACLK_1 [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins processing_system7_0/FCLK_RESET1_N]
  connect_bd_net -net axi_vdma_0_s_axis_s2mm_tready [get_bd_pins axi_vdma_0/s_axis_s2mm_tready] [get_bd_pins ov7670_axi_stream_capture_0/m_axis_tready]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins debounce_0/clk] [get_bd_pins ov7670_controller_0/clk]
  connect_bd_net -net d_1 [get_bd_ports d] [get_bd_pins ov7670_axi_stream_capture_0/d]
  connect_bd_net -net debounce_0_o [get_bd_pins debounce_0/o] [get_bd_pins ov7670_controller_0/resend]
  connect_bd_net -net href_1 [get_bd_ports href] [get_bd_pins ov7670_axi_stream_capture_0/href]
  connect_bd_net -net i_1 [get_bd_ports i] [get_bd_pins debounce_0/i]
  connect_bd_net -net ov7670_axi_stream_capture_0_aclk [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins ov7670_axi_stream_capture_0/aclk]
  connect_bd_net -net ov7670_axi_stream_capture_0_m_axis_tdata [get_bd_pins axi_vdma_0/s_axis_s2mm_tdata] [get_bd_pins ov7670_axi_stream_capture_0/m_axis_tdata]
  connect_bd_net -net ov7670_axi_stream_capture_0_m_axis_tlast [get_bd_pins axi_vdma_0/s_axis_s2mm_tlast] [get_bd_pins ov7670_axi_stream_capture_0/m_axis_tlast]
  connect_bd_net -net ov7670_axi_stream_capture_0_m_axis_tuser [get_bd_pins axi_vdma_0/s_axis_s2mm_tuser] [get_bd_pins ov7670_axi_stream_capture_0/m_axis_tuser]
  connect_bd_net -net ov7670_axi_stream_capture_0_m_axis_tvalid [get_bd_pins axi_vdma_0/s_axis_s2mm_tvalid] [get_bd_pins ov7670_axi_stream_capture_0/m_axis_tvalid]
  connect_bd_net -net ov7670_controller_0_config_finished [get_bd_ports config_finished] [get_bd_pins ov7670_controller_0/config_finished]
  connect_bd_net -net ov7670_controller_0_pwdn [get_bd_ports pwdn] [get_bd_pins ov7670_controller_0/pwdn]
  connect_bd_net -net ov7670_controller_0_reset [get_bd_ports reset] [get_bd_pins ov7670_controller_0/reset]
  connect_bd_net -net ov7670_controller_0_sioc [get_bd_ports sioc] [get_bd_pins ov7670_controller_0/sioc]
  connect_bd_net -net ov7670_controller_0_xclk [get_bd_ports xclk] [get_bd_pins ov7670_controller_0/xclk]
  connect_bd_net -net pclk_1 [get_bd_ports pclk] [get_bd_pins ov7670_axi_stream_capture_0/pclk]
  connect_bd_net -net vsync_1 [get_bd_ports vsync] [get_bd_pins ov7670_axi_stream_capture_0/vsync]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port vsync -pg 1 -y -180 -defaultsOSRD
preplace port DDR -pg 1 -y -360 -defaultsOSRD
preplace port pwdn -pg 1 -y 130 -defaultsOSRD
preplace port i -pg 1 -y 250 -defaultsOSRD
preplace port xclk -pg 1 -y 150 -defaultsOSRD
preplace port sioc -pg 1 -y 70 -defaultsOSRD
preplace port siod -pg 1 -y 90 -defaultsOSRD
preplace port href -pg 1 -y -160 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y -340 -defaultsOSRD
preplace port config_finished -pg 1 -y 50 -defaultsOSRD
preplace port pclk -pg 1 -y -200 -defaultsOSRD
preplace port reset -pg 1 -y 110 -defaultsOSRD
preplace portBus d -pg 1 -y -140 -defaultsOSRD
preplace inst axi_vdma_0 -pg 1 -lvl 3 -y -120 -defaultsOSRD
preplace inst axi_protocol_converter_0 -pg 1 -lvl 1 -y -610 -defaultsOSRD
preplace inst ov7670_controller_0 -pg 1 -lvl 7 -y 100 -defaultsOSRD
preplace inst ov7670_axi_stream_capture_0 -pg 1 -lvl 2 -y -180 -defaultsOSRD
preplace inst debounce_0 -pg 1 -lvl 6 -y 240 -defaultsOSRD
preplace inst axi_interconnect_0 -pg 1 -lvl 4 -y -450 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 5 -y 80 -defaultsOSRD
preplace inst axi_interconnect_1 -pg 1 -lvl 2 -y -530 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 6 -y -260 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 6 2 N -380 NJ
preplace netloc ov7670_axi_stream_capture_0_aclk 1 2 1 200
preplace netloc ov7670_controller_0_reset 1 7 1 N
preplace netloc processing_system7_0_M_AXI_GP0 1 0 7 -570 -540 NJ -670 NJ -670 NJ -670 NJ -670 NJ -670 1780
preplace netloc ACLK_1 1 0 7 -580 -520 -260 -280 250 -280 NJ -280 NJ -280 1180 -430 1760
preplace netloc i_1 1 0 6 NJ 250 NJ 250 NJ 250 NJ 250 NJ 250 NJ
preplace netloc ARESETN_1 1 0 7 -560 -530 -250 -390 NJ -480 680 -630 NJ -630 NJ -630 1800
preplace netloc ov7670_axi_stream_capture_0_m_axis_tuser 1 2 1 210
preplace netloc ov7670_axi_stream_capture_0_m_axis_tdata 1 2 1 230
preplace netloc ov7670_axi_stream_capture_0_m_axis_tlast 1 2 1 240
preplace netloc href_1 1 0 2 NJ -180 N
preplace netloc S00_ACLK_1 1 2 5 270 -380 690 -610 NJ -610 1160 -440 1770
preplace netloc ov7670_controller_0_config_finished 1 7 1 N
preplace netloc axi_protocol_converter_0_M_AXI 1 1 1 N
preplace netloc ov7670_controller_0_xclk 1 7 1 N
preplace netloc processing_system7_0_FIXED_IO 1 6 2 N -360 NJ
preplace netloc ov7670_controller_0_pwdn 1 7 1 N
preplace netloc debounce_0_o 1 6 1 1780
preplace netloc clk_wiz_0_clk_out1 1 5 2 1170 90 NJ
preplace netloc axi_interconnect_0_M00_AXI 1 4 2 NJ -450 1170
preplace netloc axi_vdma_0_s_axis_s2mm_tready 1 1 2 NJ -90 NJ
preplace netloc d_1 1 0 2 NJ -160 N
preplace netloc pclk_1 1 0 2 NJ -220 N
preplace netloc Net1 1 7 1 N
preplace netloc ov7670_axi_stream_capture_0_m_axis_tvalid 1 2 1 220
preplace netloc axi_interconnect_1_M00_AXI 1 2 1 260
preplace netloc axi_vdma_0_M_AXI_S2MM 1 3 1 700
preplace netloc ov7670_controller_0_sioc 1 7 1 N
preplace netloc S00_ARESETN_1 1 2 5 280 -360 710 -600 NJ -600 NJ -600 1790
preplace netloc vsync_1 1 0 2 NJ -200 N
levelinfo -pg 1 -600 -400 60 480 860 1080 1540 1900 2030 -top -680 -bot 340
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


