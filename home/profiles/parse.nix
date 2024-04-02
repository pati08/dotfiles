/*
   Takes a string, strips out newlines, and returns the appropriate profile's path.
   If the newline-removed string is not either "desktop" or "laptop", it aborts.
*/

profileString:
  let cleaned = builtins.replaceStrings [ "\n" ] [ "" ] profileString;
in (
  if cleaned == "desktop" then ( ./desktop.nix )
  else
    if cleaned == "laptop" then (./laptop.nix)
      else
        builtins.abort "invalid profile id (from file profile-id.txt): \"" + cleaned + "\""
)
