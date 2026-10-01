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
without them sextant falls back to stb_truetype and stb_image_write. `window-icon`, also default, gives
every window the sextant icon (Windows, Linux); without it windows keep the platform's default icon.
To drop a default feature, list the ones you keep with `"default-features": false`:

```json
{ "dependencies": [{ "name": "sextant", "default-features": false, "features": ["freetype", "png"] }] }
```

On Linux, sextant's GLFW needs the X11 and Wayland development headers from the system:
`libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libxext-dev libwayland-dev
libxkbcommon-dev wayland-protocols` (Debian/Ubuntu names).

