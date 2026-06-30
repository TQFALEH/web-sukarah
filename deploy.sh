#!/usr/bin/env bash
# =====================================================================
# نشر تحديث فِرموِير جديد لموقع الفلَش (سُكرة ميني)
# الاستخدام:  ./webapp/deploy.sh 1.0.3
# يبني الفِرموِير، يحدّث الصورة + manifest، يدفع، ويعيد نشر gh-pages.
# الموقع الحيّ: https://tqfaleh.github.io/web-sukarah/  (يتحدّث خلال ~دقيقة)
# =====================================================================
set -e
VER="${1:?الاستخدام: ./webapp/deploy.sh <version>   مثال: ./webapp/deploy.sh 1.0.3}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"          # جذر مستودع sukra-mini
PIO="$HOME/.platformio/penv/bin/pio"
WEB_REPO="https://github.com/TQFALEH/web-sukarah.git"
cd "$ROOT"

echo "▶ (1/5) بناء الفِرموِير (waveshare-185c)…"
"$PIO" run -e waveshare-185c

echo "▶ (2/5) نسخ الصورة الكاملة → webapp/firmware/sukra-mini-185c-$VER.bin"
cp ".pio/build/waveshare-185c/firmware.factory.bin" "webapp/firmware/sukra-mini-185c-$VER.bin"

echo "▶ (3/5) تحديث manifest.json (الإصدار + المسار)…"
python3 - "$VER" <<'PY'
import json, sys
v = sys.argv[1]; p = "webapp/manifest.json"
m = json.load(open(p, encoding="utf-8"))
m["version"] = v
m["builds"][0]["parts"][0]["path"] = f"firmware/sukra-mini-185c-{v}.bin"
json.dump(m, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
print("   manifest -> version", v)
PY

echo "▶ (4/5) حفظ ودفع المصدر (master)…"
git add "webapp/firmware/sukra-mini-185c-$VER.bin" webapp/manifest.json
git commit -m "webapp: firmware $VER"
git -c http.postBuffer=524288000 push origin بوكس

echo "▶ (5/5) إعادة نشر الموقع (gh-pages → web-sukarah)…"
git branch -D gh-pages 2>/dev/null || true
git subtree split --prefix=webapp -b gh-pages
git -c http.version=HTTP/1.1 -c http.postBuffer=524288000 -c pack.window=0 \
    push -f "$WEB_REPO" gh-pages:gh-pages

echo ""
echo "✅ تم نشر الإصدار $VER — حيّ خلال ~دقيقة على:"
echo "   https://tqfaleh.github.io/web-sukarah/"
