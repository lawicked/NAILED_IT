module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      spacing: {
        '13': '3.25rem',  // 52px - Fibonacci-inspired
        '21': '5.25rem',  // 84px - Fibonacci-inspired
        '34': '8.5rem',   // 136px - Fibonacci-inspired
      },
    },
  },
  plugins: [require("daisyui")],
}
