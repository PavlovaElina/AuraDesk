import SwiftUI

struct WeatherWidgetView: View {
    let city: String
    let latitude: Double
    let longitude: Double

    @State private var temperature: Double?
    @State private var windSpeed: Double?
    @State private var isLoading = false
    @State private var errorText: String?

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 34))

            if isLoading {
                ProgressView()
            } else if let temperature {
                Text("\(Int(temperature.rounded()))°C")
                    .font(.system(size: 42, weight: .bold, design: .rounded))

                Text(city)
                    .font(.system(size: 16, weight: .medium, design: .rounded))

                if let windSpeed {
                    Text("Wind \(Int(windSpeed.rounded())) km/h")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(errorText ?? "Weather unavailable")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .task {
            await loadWeather()
        }
    }

    private func loadWeather() async {
        isLoading = true
        errorText = nil

        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,wind_speed_10m&timezone=auto"

        guard let url = URL(string: urlString) else {
            errorText = "Bad URL"
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)

            temperature = response.current.temperature2m
            windSpeed = response.current.windSpeed10m
        } catch {
            errorText = "Cannot load weather"
        }

        isLoading = false
    }
}

private struct OpenMeteoResponse: Decodable {
    let current: CurrentWeather

    struct CurrentWeather: Decodable {
        let temperature2m: Double
        let windSpeed10m: Double

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case windSpeed10m = "wind_speed_10m"
        }
    }
}

#Preview {
    WeatherWidgetView(
        city: "Amsterdam",
        latitude: 52.37,
        longitude: 4.89
    )
    .frame(width: 288, height: 140)
}
