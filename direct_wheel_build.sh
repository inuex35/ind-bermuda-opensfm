#!/bin/bash
set -e

# 最もシンプルなアプローチを使用するスクリプト
echo "Installing build requirements..."
pip install --upgrade pip wheel setuptools

# setup.pyを直接使用してwheelをビルドする
echo "Building wheel directly using setup.py..."
python setup.py bdist_wheel

# ビルド情報の表示
echo "Wheel built successfully! Wheel file is in dist/ directory:"
ls -la dist/

echo ""
echo "You can install the wheel with:"
echo "pip install dist/opensfm-*.whl"
