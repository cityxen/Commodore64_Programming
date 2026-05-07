// -----------------------------------------------------------
// Ultimate 64/1541 Ultimate II+ include file for geoGopher
// -----------------------------------------------------------

// Address Description                         Default
// $DF1C   Control register (Write)
// $DF1C   Status register (Read)              $00
// $DF1D   Command data register (Write)   
// $DF1D   Identification register (Read)      $C9
// $DF1E   Response Data register (Read only) 
// $DF1F   Status Data register (Read only)

// registers:
.const CTRL_REG = $df1c
.const CMD_REG = $df1d
.const DATA_REG = $df1e
.const STAT_REG = $df1f
// control register (write):
.const CLR_ERR = $08
.const ABORT = $04
.const ACK_DATA = $02
.const PUSH_CMD = $01
// control register (read):
.const DATA_AVAIL = $80
.const STAT_AVAIL = $40
// status bits (4 and 5):
.const STAT_BITS = $30
.const IDLE = $00
.const CMDBUSY = $10
.const DATALAST = $20
.const DATAMORE = $30
.const CMD_ERR = $08
.const ABRT_PND = $04
.const DATA_ACK = $02
.const CMD_BUSY = $01
// device targets:
.const TGT_DOS1 = $01
.const TGT_DOS2 = $02
.const TGT_NET = $03
.const TGT_CTRL = $04
// network commands:
.const IDENTIFY = $01 ;identify target device
.const NET_IFCNT = $02 ;get interface count
.const NET_GETIP = $05 ;get IP address
.const TCP_CONN = $07 ;open TCP socket
.const TCP_CLOSE = $09 ;close TCP socket
.const TCP_READ = $10 ;read from TCP socket
.const TCP_WRITE = $11 ;write to TCP socket
.const TCP_LSN = $12 ;listen on TCP socket
.const TCP_UNLSN = $13 ;stop listening on TCP socket
.const NET_LSTATE = $14 ;get listener state
.const NET_LISOCK = $15 ;get listener socket
.const GET_TIME = $26 ;get time
// listener states:
.const NET_NOLSN = $00 ;listener not listening
.const NET_LSNING = $01 ;listener listening
.const NET_CONN = $02 ;listener connected
.const NET_BERR = $03 ;listener bind error
.const NET_INUSE = $04 ;listener port in use
