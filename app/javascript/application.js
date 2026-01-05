// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers" // for Stimulus
// import "@rails/ujs"   // removed: not needed with importmap

// Import and configure Chartkick with Chart.js
import Chartkick from "chartkick"

if (window.Chart) {
	Chartkick.use(window.Chart)
}