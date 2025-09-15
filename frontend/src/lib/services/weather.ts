import { apiService } from './api';
import type { WeatherData, ApiResponse } from '../types/weather';

class WeatherService {
	private readonly baseEndpoint = 'http://localhost:8080/api/weather';

	async getWeatherByCity(city: string): Promise<ApiResponse<WeatherData>> {
		if (!city || !city.trim()) {
			return {
				error: 'City name is required',
				success: false,
			};
		}

		const params = {
			city: city.trim(),
		};

		return await apiService.get<WeatherData>(this.baseEndpoint, params);
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
				// Wait before retrying (exponential backoff)
				await new Promise(resolve => setTimeout(resolve, Math.pow(2, attempt) * 1000));
			}
		}

		return {
			error: `Failed after ${maxRetries} attempts: ${lastError}`,
			success: false,
		};
	}
}

export const weatherService = new WeatherService();