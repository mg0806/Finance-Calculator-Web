# Finance Calculator India - Web

Flutter web version of the local-first Indian finance calculator suite.

## Included in this first build

- Home dashboard with 12 calculator modules.
- Functional SIP, step-up SIP, EMI, loan comparison, loan eligibility, GST, FD/lumpsum, PPF, CAGR, inflation, and retirement calculators.
- Custom result cards, amortisation preview, and simple chart painters.
- No backend required.

## Run locally

```powershell
flutter pub get
flutter run -d chrome
```

## Deploy To Vercel

Import this folder as a repository in Vercel. The included `vercel.json` uses:

```sh
flutter build web --release
```

Output directory: `build/web`.

Before publishing, replace `contact@example.com` in the static pages with your real support email.
