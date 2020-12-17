param ([switch]$System, [switch]$Disks, [switch]$Network)

if (!$System -and !$Disks -and !$Network) {
    $All = $true
}

if ($All) {
"
SYSTEM HARDWARE
============"
SysHard
}

if ($System -or $All) {

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
VIDEO CARD
============"
VidCard
}

if ($Disks -or $All) { 
"
PHYSICAL DISKS
============"
SysDisks
}

if ($Network -or $All) {
"
NETWORK ADAPTER
============"
IPConfigReport.ps1
}