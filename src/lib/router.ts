import { writable } from "svelte/store"

export const currentRoute = writable("/")
export const routeParams = writable({})

export function navigate(path: string): void {
  currentRoute.set(path)
  window.history.pushState({}, "", path)
}

export function initRouter() {
  // Handle browser back/forward buttons
  window.addEventListener("popstate", () => {
    currentRoute.set(window.location.pathname)
  })

  // Set initial route
  currentRoute.set(window.location.pathname)
}
