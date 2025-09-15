export interface WeatherData {
	city: string;
	temp: number;
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