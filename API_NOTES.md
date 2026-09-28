# API Notes: WeatherAPI

Maintained by: Krish (API + Backend Lead)

## 1. Basic Info
- Provider: WeatherAPI (weatherapi.com)
- Base URL: `https://api.weatherapi.com/v1`
- Auth: API key as query parameter `key`
- Response format: JSON
- **Never commit the real API key to GitHub.** Store it in `.env` (added to `.gitignore`) or pass via `--dart-define=WEATHER_API_KEY=xxxx`.

## 2. Endpoints We Use

| Endpoint | Purpose | Phase |
|---|---|---|
| `/current.json` | Current weather | MVP |
| `/forecast.json` | Hourly + daily forecast | Forecast |
| `/search.json` | City search / autocomplete | Optional (saved locations) |

## 3. Current Weather

**Request**
```
GET /current.json?key=YOUR_KEY&q=22.7196,75.8577&aqi=no
```
- `q` = `latitude,longitude` (from Geolocator) or a city name

**Fields needed for the Home Screen**

| Field in JSON | Use in app |
|---|---|
| `location.name` | City name |
| `location.region` | State / region |
| `location.country` | Country |
| `location.localtime` | Local time |
| `current.temp_c` | Temperature (°C) |
| `current.feelslike_c` | Feels like |
| `current.condition.text` | Condition text (e.g. "Sunny") |
| `current.condition.icon` | Icon URL (add `https:` in front) |
| `current.humidity` | Humidity (%) |
| `current.wind_kph` | Wind speed (km/h) |
| `current.last_updated` | Last updated time |

## 4. Forecast

**Request**
```
GET /forecast.json?key=YOUR_KEY&q=22.7196,75.8577&days=3&aqi=no&alerts=no
```
- `days` = number of forecast days
- **Note:** the free plan may allow only ~3 days. Our plan says 7 days, so confirm this on the pricing page. If needed, we switch to Open-Meteo or upgrade.

**Fields**
- `forecast.forecastday[]` (list of days)
  - `date`
  - `day.maxtemp_c`, `day.mintemp_c`
  - `day.condition.text`, `day.condition.icon`
  - `day.daily_chance_of_rain`
  - `hour[]` (hourly list)
    - `time`, `temp_c`, `condition`, `chance_of_rain`, `wind_kph`, `humidity`

## 5. Error Cases (to handle in the app)

| Case | What happens | App should show |
|---|---|---|
| Invalid API key | HTTP 4xx, error code 2006 | "Something went wrong, try later" |
| Missing key | HTTP 4xx, error code 1002 | Same (this is a dev bug) |
| Location not found | HTTP 400, error code 1006 | "Location not found" |
| Empty `q` | HTTP 400, error code 1003 | "Location not available" |
| Quota exceeded | HTTP 4xx, error code 2007 | "Service busy, try later" |
| No internet | Exception (SocketException) | "No internet connection" |
| Timeout | TimeoutException | "Request timed out, retry" |

Error response format:
```json
{ "error": { "code": 1006, "message": "No matching location found." } }
```
(Exact codes to be re-verified during testing.)

## 6. Flutter Data Flow
```
Geolocator → lat,lng → WeatherService (http GET) → JSON → WeatherModel → Home Screen
```
- Service file: `lib/services/weather_service.dart`
- Model file: `lib/models/weather_model.dart`
- Always use a timeout (10 sec) and try/catch.
- Cache the response for 10-15 min to avoid extra API calls.

## 7. Test Log (fill after testing)

| # | Test | Result |
|---|---|---|
| 1 | Current weather with lat,lng | |
| 2 | Current weather with city name | |
| 3 | Forecast with days=3 | |
| 4 | Forecast with days=7 | |
| 5 | Invalid key | |
| 6 | Invalid location | |
| 7 | No internet | |

## 8. Open Questions
- Does the free plan give a 7-day forecast? If not, which alternative do we use?
- Final monthly call limit on the free plan (verify on the official pricing page).

## 9. Sample Response (current.json)

```json
{
  "location": {
    "name": "Indore",
    "region": "Madhya Pradesh",
    "country": "India",
    "localtime": "2026-09-28 14:30"
  },
  "current": {
    "last_updated": "2026-09-28 14:15",
    "temp_c": 30.2,
    "feelslike_c": 33.1,
    "condition": {
      "text": "Partly cloudy",
      "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png"
    },
    "wind_kph": 12.6,
    "humidity": 58
  }
}
```
(Values are examples. Real values change.)

## 10. How Ajay Uses It

```dart
final weather = await WeatherService().getCurrentWeather(lat, lon);
// weather.city, weather.tempC, weather.condition,
// weather.humidity, weather.windKph, weather.iconUrl
```

Errors come as `WeatherException`. Show `e.message` on the error screen.
