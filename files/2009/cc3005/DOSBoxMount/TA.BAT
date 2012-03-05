@Echo Off
Rem 
Rem   Startdatei zum Starten von Turbo Assembler / TasmX an der FHU
Rem  *** Nicht unter Windows aufrufen, da evtl. bereits gemappte ***
Rem  *** Laufwerke geloescht werden koennte == Absturz!          ***
Rem  TasmX ist SHAREWARE! und mit nur 24.- ist man dabei!
Rem
Rem --- SmartDrv laden, damit Diskettenzugriff nicht so lahm...
SmartDrv 1024 256
Cls
Rem --- "USE", sonst funkt Turbo Debugger nicht!
Echo =============== Hau einfach nur auf die Enter-Taste !!! ===============
Echo ÿ
Echo ÿ
Call Use Turbo_A2
Cls
Echo Novell Mapping sicherstellen/aendern....
Map Del L:
Map L:=Lisa\Big:\
Echo Lade....
TasmX
Cls
Echo                      ####################################
Echo                      ##           Don't Panic         ###
Echo                      ####################################
Echo ÿ
Echo ÿ
Echo ...und vergiss deine Diskette nicht!
