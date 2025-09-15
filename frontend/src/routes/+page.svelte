<script lang="ts">
	import { weatherService } from '$lib/services';
	import type { WeatherData } from '$lib/types';

	let city = '';
	let weatherData: WeatherData | null = null;
	let loading = false;
	let error = '';

	async function searchWeather() {
		if (!city.trim()) return;
		
		loading = true;
		error = '';
		weatherData = null;
		
		try {
			const result = await weatherService.getWeatherByCity(city);
			
			if (result.success && result.data) {
				weatherData = result.data;
			} else {
				error = result.error || 'Failed to fetch weather data';
			}
		} catch (err) {
			error = err instanceof Error ? err.message : 'An unexpected error occurred';
		} finally {
			loading = false;
		}
	}

	function handleKeyPress(event: KeyboardEvent) {
		if (event.key === 'Enter') {
			searchWeather();
		}
	}
</script>

<div class="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-6">
	<div class="w-full max-w-md bg-white shadow-lg rounded-xl p-6">
		<h1 class="text-2xl font-semibold text-gray-800 text-center mb-4">
			Weather Dashboard
		</h1>

		<!-- Search Bar -->
		<div class="flex items-center space-x-2">
			<input
				type="text"
				placeholder="Enter city name..."
				class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400"
				bind:value={city}
				on:keypress={handleKeyPress}
				disabled={loading}
			/>
			<button
				class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition disabled:opacity-50"
				on:click={searchWeather}
				disabled={loading || !city.trim()}
			>
				{loading ? '...' : 'Search'}
			</button>
		</div>

		<!-- Weather Display -->
		{#if error}
			<div class="mt-6 text-center bg-red-50 p-4 rounded-lg shadow">
				<p class="text-red-600">{error}</p>
			</div>
		{:else if weatherData}
		{console.log({weatherData})}
			<div class="mt-6 text-center bg-gray-50 p-4 rounded-lg shadow">
				<p class="text-lg font-medium text-gray-700">🌍 City: <span class="font-semibold">{weatherData.city}</span></p>
				<p class="text-4xl font-bold text-blue-600 mt-2">{weatherData.temp}&deg;C</p>
				<p class="text-md text-gray-600 mt-1">{weatherData.condition}</p>
				<p class="text-sm text-gray-500 mt-1">💧 Humidity: {weatherData.humidity}%</p>
			</div>
		{:else}
			<div class="mt-6 text-center bg-gray-50 p-4 rounded-lg shadow">
				<p class="text-gray-500">Enter a city name to get weather information</p>
			</div>
		{/if}
	</div>
</div>