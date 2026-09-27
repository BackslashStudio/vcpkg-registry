# vcpkg-registry
vcpkg registry for Backslash Studio — currently one port, [sextant](https://github.com/BackslashStudio/sextant).

## Use it

Add a `vcpkg-configuration.json` next to your project's `vcpkg.json`:

```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/microsoft/vcpkg",
    "baseline": "<a microsoft/vcpkg commit>"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/BackslashStudio/vcpkg-registry",
      "baseline": "<a commit of this repository>",
      "packages": ["sextant"]
    }
  ]
}
```

and depend on it in `vcpkg.json`:

```json
{ "dependencies": ["sextant"] }
```

Then in CMake:

```cmake
find_package(sextant CONFIG REQUIRED)
target_link_libraries(main PRIVATE sextant::sextant)
```

`sextant::sextant` is a shared library on dynamic triplets (`x64-windows`, `x64-linux-dynamic`,
`arm64-osx-dynamic`) and a static one on static triplets. Features: `freetype` and `png`, both default;
without them sextant falls back to stb_truetype and stb_image_write.

On Linux, sextant's GLFW needs the X11 and Wayland development headers from the system:
`libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libxext-dev libwayland-dev
libxkbcommon-dev wayland-protocols` (Debian/Ubuntu names).

## Releasing a new sextant version

1. Tag the release in `sextant` (`vX.Y.Z`); `project(VERSION)` in its `CMakeLists.txt` must match.
2. In `ports/sextant/vcpkg.json` set `"version"`; reset `"port-version"` if present.
3. Fill in `SHA512` in `ports/sextant/portfile.cmake`: leave it `0`, run
   `vcpkg install sextant --overlay-ports=ports`, and copy the hash from the error.
4. `vcpkg format-manifest ports/sextant/vcpkg.json`
5. Commit the port, then record it:
   `vcpkg x-add-version sextant --x-builtin-ports-root=ports --x-builtin-registry-versions-dir=versions`,
   and commit `versions/` in a second commit.
