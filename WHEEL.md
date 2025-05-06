# IndBermuda OpenSfM Wheel Package

This directory contains the necessary files to build and distribute a wheel package for the IndBermuda OpenSfM library, a fork of OpenSfM with GPU acceleration for 360 Gaussian Splatting.

## Building the Wheel

### Prerequisites

- Python 3.7 or newer
- CMake 3.10 or newer
- C++ compiler compatible with your system
- Required system libraries for OpenSfM

### On Linux/macOS

1. Make sure you have all the prerequisites installed
2. Run the build script:
   ```bash
   chmod +x build_wheel.sh
   ./build_wheel.sh
   ```

### On Windows

1. Make sure you have all the prerequisites installed
2. Run the build script:
   ```
   build_wheel.bat
   ```

### Manual Building

If you prefer to build manually:

1. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install build requirements:
   ```bash
   pip install --upgrade pip
   pip install wheel build setuptools sphinx
   ```

3. Build the wheel:
   ```bash
   python -m build --wheel
   ```

## Installing the Wheel

After building, you can install the wheel with:

```bash
pip install dist/indbermuda_opensfm-*.whl
```

## Using the Package

Once installed, you can use the package like the original OpenSfM:

```python
import opensfm

# Your OpenSfM code here
```

## Features

The IndBermuda OpenSfM fork includes:

- GPU accelerated feature extraction and matching
- Support for 360 degree camera reconstruction
- Integration with SUPERPOINT, DISK, ALIKED feature detectors
- LIGHTGLUE feature matcher
- Support for Gaussian Splatting workflow

## Differences from Original OpenSfM

The main differences from the original OpenSfM repository are:

1. GPU acceleration for feature detection and matching
2. Enhanced support for 360 cameras
3. Integration with modern feature extraction and matching methods

For more information, see the main [README.md](README.md) file.
