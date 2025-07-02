<script >
  import { Calendar, ArrowRight, ArrowLeft, User, Mail, Phone, MapPin } from 'lucide-svelte';
  import { navigate } from '../lib/router';
  import { onMount } from 'svelte';
    import GoBack from './GoBack.svelte';
  
  let step1Data = $state();
  let formData = $state({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    address: '',
    preferredDate: '',
    preferredTime: '',
    message: '',
    
  });
  
  const today = new Date().toISOString().split('T')[0];
  
  onMount(() => {
    const stored = sessionStorage.getItem('rdv_step1');
    if (stored) {
      step1Data = JSON.parse(stored);
    } else {
      navigate('/rdv');
    }
  });
  
  function handleNext() {
    if (formData.firstName && formData.lastName && formData.email && formData.phone && formData.address) {
      sessionStorage.setItem('rdv_step2', JSON.stringify(formData));
      navigate('/rdv/step3');
    }
  }
  
  function handleBack() {
    navigate('/rdv');
  }
</script>
<GoBack  />
<div class="min-h-screen bg-gradient-to-br from-blue-50 to-orange-50 py-12">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-12">
        <div class="flex items-center justify-center mb-6">
          <User class="w-12 h-12 text-blue-600 mr-4" />
          <h1 class="text-4xl font-bold text-gray-800">Vos informations</h1>
        </div>
        <p class="text-xl text-gray-600">Étape 2 sur 3 : Renseignez vos coordonnées</p>
        
        <!-- Progress bar -->
        <div class="w-full bg-gray-200 rounded-full h-2 mt-6">
          <div class="bg-blue-600 h-2 rounded-full w-2/3 transition-all duration-300"></div>
        </div>
      </div>

      {#if step1Data}
        <!-- Selected Service Recap -->
        <div class="bg-blue-100 rounded-xl p-6 mb-8">
          <h3 class="font-semibold text-blue-800 mb-2">Service sélectionné :</h3>
          <p class="text-blue-700 capitalize">{step1Data.selectedService} - {step1Data.urgency}</p>
        </div>
      {/if}

      <!-- Contact Form -->
      <div class="bg-white rounded-2xl shadow-xl p-8 mb-8">
        <form onsubmit={(e) => { e.preventDefault(); handleNext(); }}>
          <!-- Personal Information -->
          <div class="grid md:grid-cols-2 gap-6 mb-6">
            <div>
              <label for="firstName" class="block text-sm font-medium text-gray-700 mb-2">
                <User class="w-4 h-4 inline mr-2" />
                Prénom *
              </label>
              <input 
                type="text" 
                id="firstName" 
                bind:value={formData.firstName}
                required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                placeholder="Votre prénom"
              />
            </div>
            <div>
              <label for="lastName" class="block text-sm font-medium text-gray-700 mb-2">
                <User class="w-4 h-4 inline mr-2" />
                Nom *
              </label>
              <input 
                type="text" 
                id="lastName" 
                bind:value={formData.lastName}
                required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                placeholder="Votre nom"
              />
            </div>
          </div>

          <!-- Contact Information -->
          <div class="grid md:grid-cols-2 gap-6 mb-6">
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                <Mail class="w-4 h-4 inline mr-2" />
                Email *
              </label>
              <input 
                type="email" 
                id="email" 
                bind:value={formData.email}
                required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                placeholder="votre@email.com"
              />
            </div>
            <div>
              <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">
                <Phone class="w-4 h-4 inline mr-2" />
                Téléphone *
              </label>
              <input 
                type="tel" 
                id="phone" 
                bind:value={formData.phone}
                required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                placeholder="06 12 34 56 78"
              />
            </div>
          </div>

          <!-- Address -->
          <div class="mb-6">
            <label for="address" class="block text-sm font-medium text-gray-700 mb-2">
              <MapPin class="w-4 h-4 inline mr-2" />
              Adresse d'intervention *
            </label>
            <textarea 
              id="address" 
              bind:value={formData.address}
              required
              rows="3"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
              placeholder="Adresse complète de l'intervention"
            ></textarea>
          </div>

          <!-- Date and Time -->
          <div class="grid md:grid-cols-2 gap-6 mb-6">
            <div>
              <label for="preferredDate" class="block text-sm font-medium text-gray-700 mb-2">
                <Calendar class="w-4 h-4 inline mr-2" />
                Date souhaitée
              </label>
              <input 
                type="date" 
                id="preferredDate" 
                bind:value={formData.preferredDate}
                min={today}
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
              />
            </div>
            <div>
              <label for="preferredTime" class="block text-sm font-medium text-gray-700 mb-2">
                Heure souhaitée
              </label>
              <select 
                id="preferredTime" 
                bind:value={formData.preferredTime}
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
              >
                <option value="">Sélectionnez une heure</option>
                <option value="08:00">08:00</option>
                <option value="09:00">09:00</option>
                <option value="10:00">10:00</option>
                <option value="11:00">11:00</option>
                <option value="14:00">14:00</option>
                <option value="15:00">15:00</option>
                <option value="16:00">16:00</option>
                <option value="17:00">17:00</option>
              </select>
            </div>
          </div>

          <!-- Message -->
          <div class="mb-6">
            <label for="message" class="block text-sm font-medium text-gray-700 mb-2">
              Description du problème
            </label>
            <textarea 
              id="message" 
              bind:value={formData.message}
              rows="4"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
              placeholder="Décrivez votre problème ou demande en détail..."
            ></textarea>
          </div>
        </form>
      </div>

      <!-- Navigation -->
      <div class="flex justify-between items-center">
        <button onclick={handleBack} class="px-6 py-3 text-gray-600 hover:text-gray-800 transition-colors flex items-center">
          <ArrowLeft class="w-5 h-5 mr-2" />
          Retour
        </button>
        
        <button
          onclick={handleNext}
          disabled={!formData.firstName || !formData.lastName || !formData.email || !formData.phone || !formData.address}
          class="px-8 py-3 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white rounded-lg font-semibold transition-colors flex items-center"
        >
          Continuer
          <ArrowRight class="w-5 h-5 ml-2" />
        </button>
      </div>
    </div>
  </div>
</div>
