
  ' FreeSpace.bas. A utility to measure and monitor the Hard Drive usage.

  ' Created : 08/27/2011
  ' Last Modified : 08/27/2011

'----------------------------------------------------------------------------------------------------------------------------------------------

  nomainwin

  WindowWidth = 285
  WindowHeight = 180

  statictext #fsp.freeAv, "", 20, 20, 250, 25
  statictext #fsp.totByte, "", 20, 55, 250, 25
  statictext #fsp.totFree, "", 20, 90, 250, 25

  menu #fsp, "Help", _
             "Help Topics", [hlp]

  menu #fsp, "About", _
             "About FreeSpace", [about]

  stylebits #fsp, _WS_SYSMENU, _WS_MAXIMIZEBOX, _WS_EX_CLIENTEDGE, 0

  open "FreeSpace" for window_nf as #fsp

  #fsp, "trapclose [quit]"

  #fsp.freeAv, "!font arial 5 15"
  #fsp.totByte, "!font arial 5 15"
  #fsp.totFree, "!font arial 5 15"

  struct lpFree, _
    BytesL as ulong, _
    BytesH as ulong

  struct lpTotal, _
    BytesL as ulong, _
    BytesH as ulong

  struct lpTotFree, _
    BytesL as ulong, _
    BytesH as ulong

'----------------------------------------------------------------------------------------------------------------------------------------------

  [main]

  calldll #kernel32, "GetDiskFreeSpaceExA", _
        "C:\" as ptr, _
        lpFree as struct, _
        lpTotal as struct, _
        lpTotFree as struct, _
        ret as long

  FreeAv$ =  InUnits$(lpFree.BytesH.struct * hexdec("100000000") + lpFree.BytesL.struct)
  TotAv$ = InUnits$(lpTotal.BytesH.struct * hexdec("100000000") + lpTotal.BytesL.struct)
  TotalFreeAv$ = InUnits$(lpTotFree.BytesH.struct * hexdec("100000000") + lpTotFree.BytesL.struct)

  #fsp.freeAv, "Free Space Available: " ; FreeAv$
  #fsp.totByte, "Total Space Available: " ; TotAv$
  #fsp.totFree, "Total Free Space Available: " ; TotalFreeAv$

  timer 1000, [main]
  wait

'----------------------------------------------------------------------------------------------------------------------------------------------

  [quit]

  close #fsp
  end

'----------------------------------------------------------------------------------------------------------------------------------------------

  [hlp]

  run "notepad FreeSpace.txt"

  wait

'----------------------------------------------------------------------------------------------------------------------------------------------

  [about]

  icon$ = "FreeSpace.ico"

  calldll #shell32, "ExtractIconA", _
      0 as long, _
      icon$ as ptr, _
      0 as long, _
      hIcon as ulong

  szApp$ = "About FreeSpace ver 1.0 # Built in Liberty Basic ver 4.03"
  cr$ = chr$(13)
  szOtherStuff$ = cr$ + "Created by Alexander Kampolis" + cr$

  calldll #shell32, "ShellAboutA", _
      h as ulong, _
      szApp$ as ptr, _
      szOtherStuff$ as ptr, _
      hIcon as ulong, _
      ret as long

  wait

'----------------------------------------------------------------------------------------------------------------------------------------------

  function InUnits$(Bytes)

    InUnits$ = Bytes / (1024 * 1024 * 1024) ; " GB"

  end function
