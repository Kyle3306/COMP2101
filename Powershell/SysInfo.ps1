function SysHard{
	(gwmi win32_computersystem | format-list Manufacturer, Model | out-string).trim()
}

function SysOS{
	(gwmi win32_operatingsystem | format-list Caption, Version | out-string).trim()
}

function SysPro{
	(gwmi win32_processor | format-list Name, CurrentClockSpeed, NumberOfCores, L1CacheSize, @{n = "L2CacheSize"; e = {if ($_.L2CacheSize -eq $null) {                                                                                                                        "no data"                                                                                                                        }                                                                                                                       else {                                                                                                                        [string]$_.L2CacheSize                                                                                                                        }                                                                                               }}, L3CacheSize | out-string).trim()
}

function SysRAM{
	(gwmi win32_physicalmemory | format-table Manufacturer, Description, @{n="Size";e={($_.Capacity/1mb -as [string]) + "MB"}}, BankLabel, DeviceLocator | out-string).trim()
}

function SysTotalRAM{
	$TotalMem = 0
	gwmi win32_physicalmemory | 
	foreach {
		$TotalMem += $_.capacity/1mb}
	($TotalMem -as [string]) + "MB"
}

function SysDisks {
    $diskdrives = Get-CIMInstance CIM_diskdrive
	$diskinfo = foreach ($disk in $diskdrives) {
		$partitions = $disk | get-cimassociatedinstance -resultclassname CIM_diskpartition
		foreach ($partition in $partitions) {
			$logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
			foreach ($logicaldisk in $logicaldisks) {
				new-object -typename psobject -property @{ Drive = $logicaldisk.deviceid;
									                       Vender=$disk.Manufacturer;
									                       Model=$disk.model;
									                       “Size(GB)” = "{0:N2}" -f (($logicaldisk.size) / 1gb);
									                       "Space Usage(GB)" = "{0:N2}" -f (($logicaldisk.freespace) / 1gb);
                                                            }
                }		
	        }  
    }
    $diskinfo
}

function VidCard {
    (gwmi win32_videocontroller | format-list AdapterCompatibility, Description, @{n = "Resolution"; e = {[string]$_.CurrentVerticalResolution + "x" + [string]$_.CurrentHorizontalResolution}} | out-string).trim()
}

"
SYSTEM HARDWARE
============"
SysHard

"
OPERATING SYSTEM
============"
SysOS

"
PROCESSOR
============"
SysPro

"
RAM
============"
SysRAM
"TOTAL MEMORY"
SysTotalRAM

"
PHYSICAL DISKS
============"
SysDisks

"
NETWORK ADAPTER
============"
IPConfigReport.ps1

"
VIDEO CARD
============"
VidCard