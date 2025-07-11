<script lang="ts">
    import { navigate } from "../lib/router";

    export let navItems: Array<{ label: string; key: string }>;
    export let handleNavClick: (key: string) => void;
    export let isOpen: boolean;
    export let toggleMenu: () => void;

</script>

<div class="sticky top-0 z-30 w-full">
  <!-- Header Image -->
  <img
  onclick={() => navigate('/')}
    src="nav.png"
    alt=""
    class="w-full h-full object-cover animate-fade-in cursor-pointer"
  />

  <!-- Nav Bar Container -->
  <nav
    class="bg-orange-600 border-t border-white rounded-full max-sm:rounded-none mx-2 md:mx-4 max-sm:mx-0 relative"
  >
    <!-- Desktop & Toggle Button -->
    <div
      class="flex items-center justify-between px-4 py-2 max-sm:py-0 md:py-3"
    >
      <!-- Hamburger button (visible on small screens) -->
      <button
        class="md:hidden text-white focus:outline-none"
        onclick={toggleMenu}
        aria-label="Toggle Menu"
      >
        <svg
          class="w-6 h-6"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d={isOpen ? "M6 18L18 6M6 6l12 12" : "M4 6h16M4 12h16M4 18h16"}
          />
        </svg>
      </button>

      <!-- Nav Items (desktop) -->
      <div class="hidden md:flex space-x-2 z-100">
        {#each navItems as item}
          <button
            onclick={() => handleNavClick(item.key)}
            class="px-4 py-2 text-sm font-medium text-white hover:text-blue-600 hover:bg-white rounded-full transition-all duration-300 whitespace-nowrap"
          >
            {item.label}
          </button>
        {/each}
      </div>
    </div>

    <!-- Nav Items (mobile dropdown) -->
    {#if isOpen}
      <div
        class="md:hidden flex flex-col items-center px-4 pb-4 space-y-2 animate-fade-in"
      >
        {#each navItems as item}
          <button
            onclick={() => handleNavClick(item.key)}
            class="w-full text-center px-4 py-2 text-sm font-medium text-white hover:text-blue-600 hover:bg-white rounded-full transition-all duration-300"
          >
            {item.label}
          </button>
        {/each}
      </div>
    {/if}
  </nav>
</div>

<style>
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .animate-fade-in {
    animation: fadeInUp 0.8s ease-out forwards;
  }
</style>
