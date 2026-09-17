{
  lib,
  stdenv,
  audacious-plugins,
  fetchFromGitHub,
  gtk3,
  meson,
  ninja,
  pkg-config,
  qt6,
  wrapGAppsHook3,
  withPlugins ? false,
  withGtk3 ? true,
}:

stdenv.mkDerivation rec {
  pname = "audacious";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "audacious-media-player";
    repo = "audacious";
    rev = "${pname}-${version}";
    hash = "sha256-f1ugxM57dYDDq/G+16bXs6++KXnaLwT+mcPY0R371tY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals withGtk3 [ wrapGAppsHook3 ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ]
  ++ lib.optionals withGtk3 [
    gtk3
  ];

  mesonFlags = [
    "-Dgtk=${lib.boolToString withGtk3}"
    "-Dbuildstamp=NixOS"
  ];

  postInstall = lib.optionalString withPlugins ''
    ln -s ${audacious-plugins}/lib/audacious $out/lib
    ln -s ${audacious-plugins}/share/audacious/Skins $out/share/audacious/
  '';

  meta = {
    description = "Lightweight and versatile audio player";
    homepage = "https://audacious-media-player.org";
    downloadPage = "https://github.com/audacious-media-player/audacious";
    mainProgram = "audacious";
    maintainers = with lib.maintainers; [
      ramkromberg
      thiagokokada
    ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      bsd2
      bsd3 # https://github.com/audacious-media-player/audacious/blob/master/COPYING
      gpl2
      gpl3
      lgpl2Plus # http://redmine.audacious-media-player.org/issues/46
    ];
  };
}
