#!/bin/bash
set -e

# Dockerコンテナ内での実行用にSphinxを使わないシンプルなセットアップを使用
echo "Installing build requirements..."
pip install --upgrade pip
pip install wheel setuptools build

# 簡易セットアップファイルを使用
echo "Building wheel using simple setup..."
cp simple_setup.py setup.py
cp simple_pyproject.toml pyproject.toml

# wheelをビルド
python -m build --wheel

# ビルド情報の表示
echo "Wheel built successfully! Wheel file is in dist/ directory:"
ls -la dist/

echo ""
echo "You can install the wheel with:"
echo "pip install dist/indbermuda_opensfm-*.whl"
