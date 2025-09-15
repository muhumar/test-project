export interface WeatherData {
	city: string;
	temperature: number;
	condition: string;
	humidity: number;
}

export interface WeatherError {
	error: string;
}

export interface ApiResponse<T> {
	data?: T;
	error?: string;
	success: boolean;
}