# Network Printer Setup Guide

This guide explains how to use the enhanced printer configuration that has been added to your NixOS setup.

## What's Been Added

### System Services
- **CUPS (Common Unix Printing System)** with web interface enabled
- **Avahi** for network printer discovery via mDNS/Bonjour
- **Firewall rules** for printer sharing and CUPS web interface
- **Comprehensive printer drivers** for most major brands
- **Printer browsing** enabled for network discovery
- **Default printer sharing** enabled for local printers

### Graphical Tools
- **system-config-printer** - GTK-based printer configuration tool
- **CUPS web interface** - Web-based printer management
- **Additional printer utilities** and drivers

## How to Use

### 1. Access CUPS Web Interface
After rebuilding your system, you can access the CUPS web interface at:
```
http://localhost:631
```

This provides a web-based interface for:
- Adding new printers
- Managing existing printers
- Viewing print jobs
- Configuring printer settings

### 2. Using system-config-printer
Launch the graphical printer configuration tool:
```bash
system-config-printer
```

This GTK application provides:
- Easy printer discovery
- Driver installation
- Printer configuration
- Test printing

### 3. Network Printer Discovery
The system is configured to automatically discover network printers using:
- **mDNS/Bonjour** (Avahi) - discovers printers on the local network
- **IPP (Internet Printing Protocol)** - for modern network printers
- **SMB/CIFS** - for Windows network printers

### 4. Command Line Tools

#### List available printers:
```bash
lpstat -p
```

#### Print a test page:
```bash
lp -d <printer_name> /usr/share/cups/data/testprint
```

#### Check printer status:
```bash
lpstat -t
```

#### Add a network printer via command line:
```bash
lpadmin -p <printer_name> -E -v ipp://<printer_ip>/ipp/print -m everywhere
```

### 5. Supported Printer Brands
The configuration includes drivers for:
- **HP** (hplip)
- **Canon** (cnijfilter2)
- **Epson** (epson-escpr, epson-escpr2)
- **Samsung** (samsung-unified-linux-driver)
- **Brother** (brlaser)
- **Generic** (gutenprint, splix, foo2zjs)

### 6. Printer Sharing
Your system is configured to share printers with other devices on the network. Other devices can discover and use your printers via:
- mDNS/Bonjour discovery
- CUPS sharing protocol
- IPP sharing

### 7. Troubleshooting

#### Check CUPS service status:
```bash
systemctl status cups
```

#### Check Avahi service status:
```bash
systemctl status avahi-daemon
```

#### View CUPS logs:
```bash
journalctl -u cups
```

#### Reset CUPS configuration:
```bash
sudo systemctl restart cups
```

#### Test network connectivity to printer:
```bash
ping <printer_ip>
```

### 8. Common Printer Setup Scenarios

#### Adding a USB Printer:
1. Connect the printer via USB
2. Open `system-config-printer`
3. Click "Add" → "USB Printer"
4. Select your printer from the list
5. Choose appropriate driver
6. Test print

#### Adding a Network Printer (IPP):
1. Open `system-config-printer`
2. Click "Add" → "Network Printer"
3. Select "Internet Printing Protocol (IPP)"
4. Enter printer URL: `ipp://<printer_ip>/ipp/print`
5. Choose driver and test

#### Adding a Windows Network Printer:
1. Open `system-config-printer`
2. Click "Add" → "Network Printer"
3. Select "Windows Printer via SAMBA"
4. Enter printer URI: `smb://<server>/<printer>`
5. Configure authentication if needed

### 9. Security Notes
- CUPS web interface is accessible from localhost by default
- Printer sharing is enabled for local network
- Firewall rules allow necessary ports (631, 9100, 5353)
- Remote administration can be configured via CUPS web interface

### 10. Next Steps After Rebuild
1. Rebuild your system: `sudo nixos-rebuild switch`
2. Check services are running: `systemctl status cups avahi-daemon`
3. Open CUPS web interface: `http://localhost:631`
4. Launch printer configuration: `system-config-printer`
5. Add your printers and test printing

## Additional Resources
- [CUPS Documentation](https://www.cups.org/doc/man-cupsd.conf.html)
- [Avahi Documentation](https://avahi.org/)
- [NixOS Printing Options](https://nixos.org/manual/nixos/stable/options.html#opt-services.printing.enable)