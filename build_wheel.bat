@echo off
echo Creating virtual environment...
python -m venv venv
call venv\Scripts\activate.bat

echo Installing build requirements...
pip install --upgrade pip
pip install wheel build setuptools sphinx

echo Building wheel...
python -m build --wheel

echo Wheel built successfully! Wheel file is in dist\ directory:
dir /b dist\

echo.
echo You can install the wheel with:
echo pip install dist\indbermuda_opensfm-*.whl
