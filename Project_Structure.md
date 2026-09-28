# Project Structure

```
weather_app/
├── lib/
│   ├── main.dart            # App entry point
│   ├── screens/             # Home, Forecast, AI, Emergency screens
│   ├── widgets/             # Reusable cards, buttons, tiles
│   ├── models/              # Data models (weather_model.dart)
│   ├── services/            # API, location, Firebase (weather_service.dart)
│   └── utils/               # Constants, helpers, formatting
├── assets/                  # Icons, images
├── API_NOTES.md             # WeatherAPI details
├── PROJECT_STRUCTURE.md     # This file
└── README.md
```

## Rules
- Screens only show UI. No API calls inside screens.
- All API calls go through `services/`.
- All JSON parsing goes through `models/`.
- Do not put API keys in code.
- Do not over-engineer the MVP.

## Branches
- `main`: stable code
- `ajay`: Flutter and integration work
- `krish`: API, backend, Firebase work
- `anshika`: UI implementation and design work
