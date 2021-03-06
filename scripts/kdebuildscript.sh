#!/bin/bash
echo "
function setup_distcc() {
  echo distcc > /etc/distcc/hosts
  if [ -z \$(find . -maxdepth 1 -name \"configure.ac\") ]; then
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
    dpkg-reconfigure distcc
    COMPILERS_TO_REPLACE=\$(ls /usr/lib/distcc/ | grep -v ccache )
    COMPILERS_TO_REPLACE=\"\${COMPILERS_TO_REPLACE} cc c++\"
    for bin in \${COMPILERS_TO_REPLACE}; do
      rm /usr/lib/distcc/\${bin};
    done

      # Create distcc wrapper
    echo '#!/usr/bin/env bash' > /usr/lib/distcc/distccwrapper
    echo 'CCACHE_PREFIX=distcc ccache /usr/bin/aarch64-linux-gnu-g\"\${0:\$[-2]}\" \"\$@\"' >> /usr/lib/distcc/distccwrapper
    chmod +x /usr/lib/distcc/distccwrapper

    # Create distcc wrapper
    for bin in \${COMPILERS_TO_REPLACE}; do
        ln -s /usr/lib/distcc/distccwrapper /usr/lib/distcc/\${bin}
    done


    export CCACHE_DIR=/root/.ccache
    export PATH=\"/usr/lib/distcc/:\$PATH\"
  fi
}" > /media/fakeinstallroot/build/addFunction.tmp

if [ ! -d "/media/fakeinstallroot/root/kde/" ] ; then
  chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;which gcc;/build/kdesrc-build/kdesrc-build --initial-setup"
  /bin/sed 's/\~\/kde\/usr/\/usr/g' /media/fakeinstallroot/root/.kdesrc-buildrc > /tmp/.kdesrc-buildrc
  rm /media/fakeinstallroot/root/.kdesrc-buildrc
  cp /tmp/.kdesrc-buildrc /media/fakeinstallroot/root/.kdesrc-buildrc
  chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;which gcc;/build/kdesrc-build/kdesrc-build kdesrc-build plasma-workspace plasma-framework plasma-nm plasma-pa plasma-thunderbolt plasma-vault plasma-disks plasma-workspace-wallpapers kdeplasma-addons krunner milou kwin kscreen sddm-kcm breeze discover print-manager plasma-sdk kaccounts-integration kaccounts-providers kdeconnect-kde plasma-browser-integration xdg-desktop-portal-kde khotkeys plasma-nano plasma-phone-components plasma-settings plasma-camera marble koko okular plasma-angelfish peruse calindori index-fm maui-pix qrca keysmith plasma-dialer discover spacebar --include-dependencies && distcc-pump --startup"
else
  chroot /media/fakeinstallroot /usr/bin/bash -c "source /build/addFunction.tmp;setup_distcc;which gcc;/build/kdesrc-build/kdesrc-build kdesrc-build plasma-workspace plasma-framework plasma-nm plasma-pa plasma-thunderbolt plasma-vault plasma-disks plasma-workspace-wallpapers kdeplasma-addons krunner milou kwin kscreen sddm-kcm breeze discover print-manager plasma-sdk kaccounts-integration kaccounts-providers kdeconnect-kde plasma-browser-integration xdg-desktop-portal-kde khotkeys plasma-nano plasma-phone-components plasma-settings plasma-camera marble koko okular plasma-angelfish peruse calindori index-fm maui-pix qrca keysmith plasma-dialer discover spacebar --no-src && distcc-pump --startup"
fi