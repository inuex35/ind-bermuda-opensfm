OpenSfM ![Docker workflow](https://github.com/mapillary/opensfm/workflows/Docker%20CI/badge.svg)
=======

## Overview
OpenSfM is a Structure from Motion library written in Python. The library serves as a processing pipeline for reconstructing camera poses and 3D scenes from multiple images. It consists of basic modules for Structure from Motion (feature detection/matching, minimal solvers) with a focus on building a robust and scalable reconstruction pipeline. It also integrates external sensor (e.g. GPS, accelerometer) measurements for geographical alignment and robustness. A JavaScript viewer is provided to preview the models and debug the pipeline.

## Getting Started

* [Building the library][]
* [Running a reconstruction][]
* [Documentation][]


[Building the library]: https://opensfm.org/docs/building.html (OpenSfM building instructions)
[Running a reconstruction]: https://opensfm.org/docs/using.html (OpenSfM usage)
[Documentation]: https://opensfm.org/docs/ (OpenSfM documentation)

## License
OpenSfM is BSD-style licensed, as found in the LICENSE file.  See also the Facebook Open Source [Terms of Use][] and [Privacy Policy][]

[Terms of Use]: https://opensource.facebook.com/legal/terms (Facebook Open Source - Terms of Use)
[Privacy Policy]: https://opensource.facebook.com/legal/privacy (Facebook Open Source - Privacy Policy)

## For 360 gaussian splatting
In sample folder, there are config.yaml and camera_models_overrides.json.
The difference from the original repository is this repository can use GPU acceralated feature and matching(feature: SUPERPOINT, DISK, ALIKED, matcher: LIGHTGLUE)

Sample data for 360 degree camera can be found here.

[360 camera data][]

Start reconstruction with this command. 

```bash
./bin/opensfm_pointcloud data/your_data_dir
```

After reconstruction, you will see reconstruction.json. You can visualize with opensfm viewer.

```python
python3 viewer/server.py -d data/your_data_dir
```

![image](https://github.com/inuex35/ind-bermuda-opensfm/assets/129066540/cc3677ca-9c73-4725-b706-2cf6cb28f07a)

You can use reconstruction.json and images for 360 gaussian splatting.

[360 camera data]: https://www.dropbox.com/sh/3vabbmrhqqbagp5/AABi14O2tWMbxAX91jaaQY77a?dl=0 (Dropbox)
