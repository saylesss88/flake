{ lib, ... }:
let
  # prevents infinite recursion error
  myLib = import ../../lib { inherit lib; };
in
{
  # Now we can use it safely
  imports = myLib.scanPaths ./.;
}
