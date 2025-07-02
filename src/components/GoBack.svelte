<script lang="ts">
  import { ArrowLeft } from 'lucide-svelte';
  import { navigate } from '../lib/router';

  export let fallbackRoute: string = '/';

  function goBack() {
    
    if (window.history.length > 1) {
      window.history.back();
    } else {
      navigate(fallbackRoute);
    }
  }
</script>

<button
  onclick={goBack}
  class="fixed top-4 left-4 z-50 flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg shadow-md hover:bg-blue-700 transition-all duration-300 hover:scale-105 focus:outline-none focus:ring-2 focus:ring-blue-500"
  aria-label="Go back"
>
  <ArrowLeft size={20} />
  <span class="font-semibold">Retour</span>
</button>

<style>
  button {
    font-family: inherit;
  }
</style>