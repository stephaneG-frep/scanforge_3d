# ScanForge 3D

Application Flutter Android simulant un pipeline realiste de scan 3D photogrammetrique.

## Lancer

```bash
flutter pub get
flutter run
```

## Activer le vrai traitement cloud

Le provider utilise automatiquement l'API cloud si ces variables sont renseignees:

- `PHOTOGRAMMETRY_API_BASE_URL`
- `PHOTOGRAMMETRY_API_KEY`

Exemple lancement:

```bash
flutter run \
  --dart-define=PHOTOGRAMMETRY_API_BASE_URL=https://ton-api.example.com \
  --dart-define=PHOTOGRAMMETRY_API_KEY=ton_token
```

Exemple build APK:

```bash
flutter build apk --release \
  --dart-define=PHOTOGRAMMETRY_API_BASE_URL=https://ton-api.example.com \
  --dart-define=PHOTOGRAMMETRY_API_KEY=ton_token
```

Contrat API attendu (par defaut):
- `POST /v1/reconstructions` (multipart field `images`) -> `{ "jobId": "..." }`
- `GET /v1/reconstructions/{jobId}` -> `{ "status": "queued|processing|completed|failed", "modelUrl": "https://...glb" }`

Si non configure, l'app garde le mode simule actuel.
