get-ciminstance win32_networkadapterconfiguration |
   where-object IPEnabled -eq True |
   format-table Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder