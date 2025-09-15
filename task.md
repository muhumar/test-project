# 🚀 YGO - Frontend Coding Challenge

## 🌤️ Task: Build a Weather Dashboard
You will create a **weather dashboard** using **SvelteKit** and **TailwindCSS**, fetching weather data based on user input.

<br>

## 🏆 AI-First Development Approach (IMPORTANT)
✅ This challenge is designed to **assess how well you use AI tools (GitHub Copilot, Cursor, Claude, etc.) to speed up development**.  
✅ The **earlier** you involve AI in the development process, the **higher your rating**.  
✅ You must provide **screenshots of AI conversations** in a dedicated `/ai-conversations/` folder in your GitHub repository.  

Using AI is **not optional**—it is a key evaluation criterion!

<br>

## 📌 Requirements
1. **Use AI to generate code as early as possible** (document AI usage with screenshots).
2. **Create a responsive UI** based on the provided TailwindCSS mockup.
3. **Implement a search feature** that fetches weather data based on city input.
4. **Set up a SvelteKit API route (`/api/weather`)** to fetch weather data.
5. **Style the app with TailwindCSS**, ensuring a pixel-perfect match.
6. **Deploy the app on Vercel** and **upload the code to a public GitHub repository**.

<br>


## 🎨 UI Mockup
Your implementation should match this TailwindCSS design, use https://play.tailwindcss.com/ to see how it looks:

```html
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
      />
      <button
        class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition">
        Search
      </button>
    </div>

    <!-- Weather Display -->
    <div class="mt-6 text-center bg-gray-50 p-4 rounded-lg shadow">
      <p class="text-lg font-medium text-gray-700">🌍 City: <span class="font-semibold">Berlin</span></p>
      <p class="text-4xl font-bold text-blue-600 mt-2">15°C</p>
      <p class="text-md text-gray-600 mt-1">Cloudy</p>
    </div>
  </div>
</div>
```

<br>

## 🛠️ API Implementation
- Create a **SvelteKit API route (`/api/weather?city=Berlin`)**.
- Fetch **real weather data** (you can use OpenWeatherMap, WeatherAPI, or mock data).
- Return **city name, temperature, and condition** in JSON format.

**Example API response:**
```json
{
  "city": "Berlin",
  "temperature": 15,
  "condition": "Cloudy"
}
```

<br>

## ⏳ Time Limit (STRICT)
🔴 **You have exactly 2 hours** to complete the challenge from the moment you receive it.  
🔴 **Any commits made after the 2-hour mark will be ignored.**  
🔴 **Emails sent after 2 hours will result in disqualification.**  

<br>

## 📦 Deliverables
1. **Public GitHub Repository** containing your code.
2. **Deployed Site on Vercel** (must be live and accessible).
3. **AI Tool Screenshots** (Upload to a `/ai-conversations/` folder in the repo):
   - Show conversations with **GitHub Copilot, Cursor, Claude, etc.**  
   - These should demonstrate how AI assisted in your development.  

<br>

## 📧 Submission Instructions
LATEST at the **2-hour mark**, send an email to **sebastian@ygotrips.com** with:  
✅ **GitHub repository link**  
✅ **Vercel deployment URL**  

🔴 **Emails received after 2 hours will be ignored, and you will be disqualified.**  

<br>

## ✨ Optional Enhancements (Extra Points)
Candidates can **show initiative** and earn extra points by implementing:
- **Loading states** (e.g., show a spinner while fetching data)  
- **Error handling** (e.g., show a user-friendly error message if API call fails)  
- **Animations** (e.g., smooth transitions when updating weather data)  
- **Dark mode support** (toggle between light and dark theme)  
- **Debounce search input** (avoid unnecessary API calls while typing)  
- **Unit tests** (write a test for the API function or Svelte component)  

<br>

## 💡 Evaluation Criteria
- **AI-first approach** (Did you use AI early and effectively? Screenshots required!)
- **Code correctness** (Does it fetch and display weather correctly?)
- **SvelteKit & API skills** (Are API endpoints correctly set up?)
- **TailwindCSS styling** (Does it match the mockup?)
- **Performance & UX** (Are search and updates smooth?)
- **Extra effort** (Did you implement any optional enhancements?)

<br>

Happy Coding!