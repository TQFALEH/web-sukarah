# سُكرة ميني — صفحة الويب + فلَش المتصفح

موقع ثابت: لاندن بيج احترافي لجهاز **سُكرة ميني**، مع **تفعيل وفلَش الجهاز من المتصفح** مباشرة (ESP Web Tools / Web Serial) — بدون تثبيت أي برنامج.

## المحتويات
- `index.html` — الصفحة (لاندن + قسم «فعّل جهازك»). عربي RTL، هوية سُكرة التركوازية.
- `manifest.json` — بيان ESP Web Tools (ESP32-S3، صورة واحدة من 0x0).
- `firmware/sukra-mini-1.0.2.bin` — صورة الفِرموِير الكاملة (bootloader + partitions + app).
- `assets/` — صور/أيقونات.

## التشغيل محليًّا (لاختبار الفلَش)
الفلَش عبر Web Serial يحتاج **سياقًا آمنًا**: `localhost` أو **HTTPS**.

```bash
cd webapp
python3 -m http.server 8099
```
ثم افتح **http://localhost:8099** في **Chrome أو Edge على كمبيوتر** (الجوال لا يدعم Web Serial).
وصّل جهاز سُكرة ميني بالـUSB → اضغط «⚡ ابدأ الفلَش» → اختر المنفذ → ينزّل الفِرموِير.

## النشر (GitHub Pages)
ادفع مجلد `webapp/` وفعّل Pages (HTTPS تلقائي — مطلوب للفلَش):
- إمّا فرع `gh-pages` جذره `webapp/`، أو إعداد Pages على `/webapp`.
- بعد النشر يصير الفلَش متاحًا للجميع عبر الرابط.

## تحديث الفِرموِير المعروض
```bash
pio run -e waveshare-185              # يبني firmware.factory.bin
cp .pio/build/waveshare-185/firmware.factory.bin webapp/firmware/sukra-mini-<ver>.bin
# حدّث "version" و"path" في webapp/manifest.json
```

## ملاحظات
- المتصفحات المدعومة: Chrome/Edge/Opera على سطح المكتب (Web Serial).
- زر «سجّل جهازك» يفتح كونسول سُكرة لربط الحساب/الحساس.
