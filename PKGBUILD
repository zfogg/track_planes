# Maintainer: zfogg
pkgname=track_planes
pkgver=1.0.0
pkgrel=1
pkgdesc="ADS-B aircraft tracking stack (dump1090_rs + readsb + tar1090 + piaware)"
arch=('x86_64')
url="https://github.com/zfogg/track_planes"
license=('MIT')
depends=(
    'dump1090_rs'
    'readsb-git'
    'lighttpd'
    'docker'
    'docker-compose'
    'rtl-sdr'
    'git'
)
backup=(
    'etc/default/readsb'
    'etc/lighttpd/lighttpd.conf'
    'etc/track_planes/docker-compose.yml'
)
install=track_planes.install

package() {
    cp -r "$srcdir/../root/"* "$pkgdir/"

    # Create readsb user directory
    install -dm755 "$pkgdir/usr/share/readsb"

    # Create tar1090 directories
    install -dm755 "$pkgdir/usr/local/share/tar1090/html"
    install -dm755 "$pkgdir/var/cache/piaware"
}
