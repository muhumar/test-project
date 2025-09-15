import type { WeatherData, ApiResponse } from '../types/weather';

import rawData from '../../weather_data.json';

const Data: {
	cities: Record<string, any>;
} = rawData;

class WeatherService {
	// private readonly baseEndpoint = 'http://localhost:8080/api/weather';

	async getWeatherByCity(city: string): Promise<ApiResponse<WeatherData>> {
		if (!city || !city.trim()) {
			return {
				error: 'City name is required',
				success: false,
			};
		}

		const trimmedCity = city.trim().toLowerCase();
		const weather = Data?.cities?.[trimmedCity];

		if (!weather) {
			return {
				error: `Weather data for "${trimmedCity}" not found.`,
				success: false,
			};
		}

		return {
			data: weather,
			success: true,
		};
	}

	async getWeatherByCityWithRetry(city: string, maxRetries: number = 3): Promise<ApiResponse<WeatherData>> {
		let lastError: string = '';

		for (let attempt = 1; attempt <= maxRetries; attempt++) {
			const result = await this.getWeatherByCity(city);
			
			if (result.success) {
				return result;
			}

			lastError = result.error || 'Unknown error';
			
			if (attempt < maxRetries) {
				await new Promise(resolve => setTimeout(resolve, Math.pow(2, attempt) * 1000));
			}
		}

		return {
			error: `Failed after ${maxRetries} attempts: ${lastError}`,
			success: false,
		};
	}
}

export const weatherDummyService = new WeatherService();
