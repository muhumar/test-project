import axios, { type AxiosInstance, type AxiosResponse } from 'axios';
import type { ApiResponse } from '../types/weather';

class ApiService {
	private client: AxiosInstance;

	constructor() {
		this.client = axios.create({
			baseURL: typeof window !== 'undefined' ? window.location.origin : '',
			timeout: 10000,
			headers: {
				'Content-Type': 'application/json',
			},
		});

		this.setupInterceptors();
	}

	private setupInterceptors(): void {
		// Request interceptor
		this.client.interceptors.request.use(
			(config) => {
				return config;
			},
			(error) => {
				return Promise.reject(error);
			}
		);

		// Response interceptor
		this.client.interceptors.response.use(
			(response) => {
				return response;
			},
			(error) => {
				const message = error.response?.data?.error || error.message || 'An unexpected error occurred';
				return Promise.reject(new Error(message));
			}
		);
	}

	async get<T>(url: string, params?: Record<string, any>): Promise<ApiResponse<T>> {
		try {
			const response: AxiosResponse<T> = await this.client.get(url, { params });
			return {
				data: response.data,
				success: true,
			};
		} catch (error) {
			return {
				error: error instanceof Error ? error.message : 'Unknown error occurred',
				success: false,
			};
		}
	}

	async post<T>(url: string, data?: any): Promise<ApiResponse<T>> {
		try {
			const response: AxiosResponse<T> = await this.client.post(url, data);
			return {
				data: response.data,
				success: true,
			};
		} catch (error) {
			return {
				error: error instanceof Error ? error.message : 'Unknown error occurred',
				success: false,
			};
		}
	}
}

export const apiService = new ApiService();