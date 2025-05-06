#!/bin/bash
set -e

# Create and activate a virtual environment
echo "Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install build requirements
echo "Installing build requirements..."
pip install --upgrade pip
pip install wheel build setuptools sphinx

# Build the wheel
echo "Building wheel..."
python -m build --wheel

# Output information about the built wheel
echo "Wheel built successfully! Wheel file is in dist/ directory:"
ls -la dist/

echo ""
echo "You can install the wheel with:"
echo "pip install dist/indbermuda_opensfm-*.whl"
