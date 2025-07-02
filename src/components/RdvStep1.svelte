<script lang="ts">
  import { Calendar, ArrowRight, Wrench, Droplets, Flame, Zap, Settings, Home } from 'lucide-svelte';
  import { navigate } from '../lib/router';
    import GoBack from './GoBack.svelte';
  
  let selectedService = $state('');
  let urgency = $state('');
  
  const services = [
    { id: 'plomberie', name: 'Plomberie', icon: Droplets, color: 'bg-blue-500' },
    { id: 'chauffage', name: 'Chauffage', icon: Flame, color: 'bg-orange-500' },
    { id: 'debouchage', name: 'Débouchage', icon: Settings, color: 'bg-blue-400' },
    { id: 'ballon', name: 'Ballon/Chauffe-eau', icon: Zap, color: 'bg-red-500' },
    { id: 'chaudiere', name: 'Chaudière gaz', icon: Home, color: 'bg-yellow-500' },
    { id: 'pompe', name: 'Pompe à chaleur', icon: Wrench, color: 'bg-green-500' }
  ];
  
  function handleNext() {
    if (selectedService && urgency) {
      // Store selection in sessionStorage
      sessionStorage.setItem('rdv_step1', JSON.stringify({ selectedService, urgency }));
      navigate('/rdv/step2');
    }
  }
</script>
<GoBack fallbackRoute="/" />

<div class="min-h-screen bg-gradient-to-br from-blue-50 to-orange-50 py-12">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-12">
        <div class="flex items-center justify-center mb-6">
          <Calendar class="w-12 h-12 text-blue-600 mr-4" />
          <h1 class="text-4xl font-bold text-gray-800">Prendre rendez-vous</h1>
        </div>
        <p class="text-xl text-gray-600">Étape 1 sur 3 : Sélectionnez votre service</p>
        
        <!-- Progress bar -->
        <div class="w-full bg-gray-200 rounded-full h-2 mt-6">
          <div class="bg-blue-600 h-2 rounded-full w-1/3 transition-all duration-300"></div>
        </div>
      </div>

      <!-- Service Selection -->
      <div class="bg-white rounded-2xl shadow-xl p-8 mb-8">
        <h2 class="text-2xl font-bold text-gray-800 mb-6">Quel service vous intéresse ?</h2>
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          {#each services as service}
            <button
              onclick={() => selectedService = service.id}
              class="p-6 rounded-xl border-2 transition-all duration-300 hover:shadow-lg"
              class:border-blue-500={selectedService === service.id}
              class:bg-blue-50={selectedService === service.id}
              class:border-gray-200={selectedService !== service.id}
            >
              <div class="flex flex-col items-center text-center">
                <div class="w-16 h-16 {service.color} rounded-full flex items-center justify-center mb-4">
                  <service.icon class="w-8 h-8 text-white" />
                </div>
                <h3 class="font-semibold text-gray-800">{service.name}</h3>
              </div>
            </button>
          {/each}
        </div>
      </div>

      <!-- Urgency Selection -->
      <div class="bg-white rounded-2xl shadow-xl p-8 mb-8">
        <h2 class="text-2xl font-bold text-gray-800 mb-6">Quel est le niveau d'urgence ?</h2>
        <div class="grid md:grid-cols-3 gap-4">
          <button
            onclick={() => urgency = 'urgent'}
            class="p-6 rounded-xl border-2 transition-all duration-300 hover:shadow-lg"
            class:border-red-500={urgency === 'urgent'}
            class:bg-red-50={urgency === 'urgent'}
            class:border-gray-200={urgency !== 'urgent'}
          >
            <div class="text-center">
              <div class="w-12 h-12 bg-red-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-white font-bold">!</span>
              </div>
              <h3 class="font-semibold text-gray-800 mb-2">Urgent</h3>
              <p class="text-sm text-gray-600">Intervention dans les 2h</p>
            </div>
          </button>
          
          <button
            onclick={() => urgency = 'rapide'}
            class="p-6 rounded-xl border-2 transition-all duration-300 hover:shadow-lg"
            class:border-orange-500={urgency === 'rapide'}
            class:bg-orange-50={urgency === 'rapide'}
            class:border-gray-200={urgency !== 'rapide'}
          >
            <div class="text-center">
              <div class="w-12 h-12 bg-orange-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <Calendar class="w-6 h-6 text-white" />
              </div>
              <h3 class="font-semibold text-gray-800 mb-2">Rapide</h3>
              <p class="text-sm text-gray-600">Intervention sous 24h</p>
            </div>
          </button>
          
          <button
            onclick={() => urgency = 'planifie'}
            class="p-6 rounded-xl border-2 transition-all duration-300 hover:shadow-lg"
            class:border-green-500={urgency === 'planifie'}
            class:bg-green-50={urgency === 'planifie'}
            class:border-gray-200={urgency !== 'planifie'}
          >
            <div class="text-center">
              <div class="w-12 h-12 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <Settings class="w-6 h-6 text-white" />
              </div>
              <h3 class="font-semibold text-gray-800 mb-2">Planifié</h3>
              <p class="text-sm text-gray-600">Rendez-vous programmé</p>
            </div>
          </button>
        </div>
      </div>

      <!-- Navigation -->
      <div class="flex justify-between items-center">
        <button onclick={() => navigate('/')} class="px-6 py-3 text-gray-600 hover:text-gray-800 transition-colors">
          ← Retour à l'accueil
        </button>
        
        <button
          onclick={handleNext}
          disabled={!selectedService || !urgency}
          class="px-8 py-3 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white rounded-lg font-semibold transition-colors flex items-center"
        >
          Continuer
          <ArrowRight class="w-5 h-5 ml-2" />
        </button>
      </div>
    </div>
  </div>
</div>
