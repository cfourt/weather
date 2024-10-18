// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Turning off Turbo for now
document.addEventListener("turbo:load", () => {
  Turbo.session.drive = false; // Disables Turbo drive
});
