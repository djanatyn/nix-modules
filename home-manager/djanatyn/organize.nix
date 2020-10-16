let
  rule = sources: m: {
    folders = sources;
    subfolders = false;
    filters = [{ extension = m.extensions; }];
    actions = [{ move = m.dest; }];
  };

  layout = [
    {
      dest = "archives/";
      extensions = [ "zip" "gz" "dmg" "pkg" "7z" ];
    }
    {
      dest = "media/";
      extensions = [ "mp4" "mov" "m4v" "avi" "wav" ];
    }
    {
      dest = "image/";
      extensions = [ "gif" "jpg" "jpeg" "png" "svg" "HEIC" "webm" ];
    }
    {
      dest = "binary/";
      extensions = [ "app" "deb" "AppImage" "msi" "exe" ];
    }
    {
      dest = "font/";
      extensions = [ "ttf" "dfont" ];
    }
    {
      dest = "document/";
      extensions = [ "txt" "csv" "json" "pdf" "epub" ];
    }
  ];
in { rules = map (rule [ "$HOME/Downloads" "$HOME/" ]) layout; }
