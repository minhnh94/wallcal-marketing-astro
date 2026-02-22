import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";
import alpinejs from "@astrojs/alpinejs";

export default defineConfig({
  output: 'static',
  site: 'https://wallcal.app',
  vite: {
    plugins: [tailwindcss()],
  },
  integrations: [
    alpinejs({ entrypoint: '/src/alpine/entrypoint' }),
  ],
});
