import { writable } from "svelte/store";

export const currentRoute = writable("/");
export const routeParams = writable({});

export function navigate(path: string): void {
  currentRoute.set(path);
  window.history.pushState({}, "", path);
}

export function initRouter() {
  // Handle browser back/forward buttons
  window.addEventListener("popstate", () => {
    handleRouteChange();
  });

  // Set initial route
  handleRouteChange();
}

function handleRouteChange() {
  const path = window.location.pathname;
  const hash = window.location.hash;
  
  if (hash && hash.length > 0) {
    // For hash-based routes, format as "/#/route"
    currentRoute.set("/" + hash);
  } else {
    currentRoute.set(path);
  }
}
