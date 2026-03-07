{ lib, ... }:
{
  # Returns a list of all .nix files and directories in a path,
  # skipping default.nix. Perfect for the 'imports' list.
  scanPaths =
    path:
    let
      content = builtins.readDir path;
    in
    map (name: path + "/${name}") (
      builtins.attrNames (
        lib.filterAttrs (
          name: type: (type == "directory") || (name != "default.nix" && lib.hasSuffix ".nix" name)
        ) content
      )
    );

  relativeToRoot = lib.path.append ../.;
}
