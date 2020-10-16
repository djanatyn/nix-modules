let
  rule = sources: m: {
    folders = sources;
    subfolders = false;
    filters = [{ extension = m.extensions; }];
    actions = [{ move = m.dest; }];
  };

  layout = [
    {
      dest = "roms/";
      extensions = [ "z64" "srm" ];
    }
    {
      dest = "archives/";
      extensions = [ "zip" "gz" "dmg" "pkg" "7z" "xz" "ova" ];
    }
    {
      dest = "media/";
      extensions = [ "mp4" "ogg" "mp3" "mov" "m4v" "avi" "webm" "wav" ];
    }
    {
      dest = "image/";
      extensions = [ "gif" "jpg" "jpeg" "png" "svg" "HEIC" "webp" ];
    }
    {
      dest = "binary/";
      extensions =
        [ "jar" "apk" "app" "deb" "AppImage" "msi" "exe" "xpi" "dll" ];
    }
    {
      dest = "font/";
      extensions = [ "ttf" "dfont" ];
    }
    {
      dest = "document/";
      extensions = [ "txt" "csv" "json" "pdf" "epub" "xml" "docx" ];
    }
  ];
in { rules = map (rule [ "$HOME/Downloads" "$HOME/" ]) layout; }
