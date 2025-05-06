#!/usr/bin/env python3

import multiprocessing
import os
import subprocess
import sys
from pathlib import Path

import setuptools
from wheel.bdist_wheel import bdist_wheel

VERSION = (0, 5, 2)


def version_str(version):
    return ".".join(map(str, version))


class platform_bdist_wheel(bdist_wheel):
    """Patched bdist_wheel to make sure wheels include platform tag."""

    def finalize_options(self):
        bdist_wheel.finalize_options(self)
        self.root_is_pure = False


def configure_c_extension():
    """Configure cmake project to C extension."""
    print(
        f"Configuring for python {sys.version_info.major}.{sys.version_info.minor}..."
    )
    os.makedirs("cmake_build", exist_ok=True)
    cmake_command = [
        "cmake",
        "../opensfm/src",
        "-DPYTHON_EXECUTABLE=" + sys.executable,
    ]
    if sys.platform == "win32":
        cmake_command += [
            "-DVCPKG_TARGET_TRIPLET=x64-windows",
            "-DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake",
        ]
    subprocess.check_call(cmake_command, cwd="cmake_build")


def build_c_extension():
    """Compile C extension."""
    print("Compiling extension...")
    if sys.platform == "win32":
        subprocess.check_call(
            ["cmake", "--build", ".", "--config", "Release"], cwd="cmake_build"
        )
    else:
        subprocess.check_call(
            ["make", "-j" + str(multiprocessing.cpu_count())], cwd="cmake_build"
        )


try:
    configure_c_extension()
    build_c_extension()
except Exception as e:
    print(f"Warning: Failed to build C extension: {e}")
    print("Continuing with setup, but some functionality may be missing")


# Read requirements from requirements.txt
with open("requirements.txt") as f:
    install_requires = [line.strip() for line in f if line.strip() and not line.startswith("#")]

# Make paths for scripts
scripts_dir = Path("bin")
scripts = [str(script) for script in scripts_dir.glob("*") if script.is_file() and not script.name.endswith(".py")]

setuptools.setup(
    name="indbermuda-opensfm",
    version=version_str(VERSION),
    description="A Structure from Motion library with GPU acceleration for 360 Gaussian Splatting",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    url="https://github.com/inuex35/ind-bermuda-opensfm",
    author="inuex35",
    license="BSD",
    packages=setuptools.find_packages(),
    scripts=scripts,
    install_requires=install_requires,
    python_requires=">=3.7",
    package_data={
        "opensfm": [
            "pybundle.*",
            "pygeo.*",
            "pygeometry.*",
            "pyrobust.*",
            "pyfeatures.*",
            "pydense.*",
            "pysfm.*",
            "pyfoundation.*",
            "pymap.*",
            "data/sensor_data.json",
            "data/camera_calibration.yaml",
            "data/bow/bow_hahog_root_uchar_10000.npz",
            "data/bow/bow_hahog_root_uchar_64.npz",
        ]
    },
    include_package_data=True,
    zip_safe=False,
    cmdclass={
        "bdist_wheel": platform_bdist_wheel,
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: BSD License",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Topic :: Scientific/Engineering",
        "Topic :: Scientific/Engineering :: Artificial Intelligence",
        "Topic :: Scientific/Engineering :: Image Processing",
    ],
)
