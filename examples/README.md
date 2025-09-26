# Example Applications

This directory contains example applications to test the Hangover Docker setup.

## Test Scripts

### test-wine.ps1
A simple PowerShell script to test Wine functionality.

```bash
# Run the test script
./scripts/run-cli.sh wine powershell.exe ./examples/test-wine.ps1
```

## Getting Test Applications

You can download small Windows applications to test:

### Notepad++ (Portable)
```bash
wget https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.3/npp.8.6.3.portable.x64.zip
unzip npp.8.6.3.portable.x64.zip -d ./apps/
```

### 7-Zip
```bash
wget https://www.7-zip.org/a/7z2301-x64.exe
mv 7z2301-x64.exe ./apps/
```

### Test with these applications:
```bash
# GUI mode
./scripts/run-gui.sh
# Then in VNC: wine ./apps/7z2301-x64.exe

# CLI mode
./scripts/run-cli.sh wine ./apps/7z2301-x64.exe
```

## Performance Testing

For performance testing, you can use:

### y-cruncher
```bash
wget https://www.numberworld.org/y-cruncher/y-cruncher%20v0.8.3.9530.zip
unzip "y-cruncher v0.8.3.9530.zip" -d ./apps/
```

### Linpack
```bash
wget https://www.netlib.org/benchmark/hpl/linpack_xeon64.exe
mv linpack_xeon64.exe ./apps/
```