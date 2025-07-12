<script>
  export let title = "Nous Contacter";
  
  let contactForm = {
    nom: '',
    email: '',
    telephone: '',
    sujet: '',
    message: ''
  };
  
  function handleSubmit() {
    // Logique de soumission du formulaire
    console.log('Formulaire soumis:', contactForm);
  }
</script>

<div class="max-w-6xl mx-auto px-6 py-12">
  <header class="mb-12">
    <h1 class="text-4xl font-bold text-blue-600 mb-4">{title}</h1>
    <div class="w-20 h-1 bg-orange-500 rounded"></div>
  </header>

  <div class="grid lg:grid-cols-2 gap-12">
    <!-- Informations de contact -->
    <div>
      <h2 class="text-2xl font-semibold text-gray-800 mb-6">Nos Coordonnées</h2>
      
      <div class="space-y-6">
        <div class="flex items-start">
          <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mr-4">
            <svg class="w-6 h-6 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
              <path d="M2 3a1 1 0 011-1h2.153a1 1 0 01.986.836l.74 4.435a1 1 0 01-.54 1.06l-1.548.773a11.037 11.037 0 006.105 6.105l.774-1.548a1 1 0 011.059-.54l4.435.74a1 1 0 01.836.986V17a1 1 0 01-1 1h-2C7.82 18 2 12.18 2 5V3z"/>
            </svg>
          </div>
          <div>
            <h3 class="font-semibold text-gray-800">Téléphone</h3>
            <p class="text-xl font-bold text-blue-600">+33 7 45 88 08 62</p>
            <p class="text-sm text-gray-600">Disponible 24h/24 pour les urgences</p>
          </div>
        </div>

        <div class="flex items-start">
          <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mr-4">
            <svg class="w-6 h-6 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
              <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/>
              <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/>
            </svg>
          </div>
          <div>
            <h3 class="font-semibold text-gray-800">Email</h3>
            <p class="text-blue-600">Contact@frdservices.fr</p>
          </div>
        </div>

        <div class="flex items-start">
          <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mr-4">
            <svg class="w-6 h-6 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"/>
            </svg>
          </div>
          <div>
            <h3 class="font-semibold text-gray-800">Adresse</h3>
            <p class="text-gray-700">3 Allée Marianske Lazne, 91460 Marcoussis</p>
          </div>
        </div>
      </div>

      <div class="mt-8 p-6 bg-gray-50 rounded-lg">
        <h3 class="font-semibold text-gray-800 mb-4">Horaires d'Ouverture</h3>
        <div class="space-y-2 text-sm">
          <div class="flex justify-between">
            <span>Lundi - Vendredi</span>
            <span>8h00 - 18h30</span>
          </div>
          <div class="flex justify-between">
            <span>Samedi</span>
            <span>8h30 - 16h30</span>
          </div>
          <div class="flex justify-between">
            <span>Dimanche</span>
            <span>Urgences uniquement</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Formulaire de contact -->
    <div>
      <h2 class="text-2xl font-semibold text-gray-800 mb-6">Envoyez-nous un Message</h2>
      
      <form on:submit|preventDefault={handleSubmit} class="space-y-6">
        <div class="grid md:grid-cols-2 gap-6">
          <div>
            <label for="nom" class="block text-sm font-medium text-gray-700 mb-2">Nom *</label>
            <input 
              type="text" 
              id="nom" 
              bind:value={contactForm.nom}
              required
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
          <div>
            <label for="telephone" class="block text-sm font-medium text-gray-700 mb-2">Téléphone</label>
            <input 
              type="tel" 
              id="telephone" 
              bind:value={contactForm.telephone}
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>

        <div>
          <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email *</label>
          <input 
            type="email" 
            id="email" 
            bind:value={contactForm.email}
            required
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>

        <div>
          <label for="sujet" class="block text-sm font-medium text-gray-700 mb-2">Sujet</label>
          <select 
            id="sujet" 
            bind:value={contactForm.sujet}
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          >
            <option value="">Sélectionnez un sujet</option>
            <option value="devis">Demande de devis</option>
            <option value="urgence">Intervention d'urgence</option>
            <option value="maintenance">Maintenance</option>
            <option value="autre">Autre</option>
          </select>
        </div>

        <div>
          <label for="message" class="block text-sm font-medium text-gray-700 mb-2">Message *</label>
          <textarea 
            id="message" 
            bind:value={contactForm.message}
            required
            rows="5"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          ></textarea>
        </div>

        <button 
          type="submit" 
          class="w-full bg-blue-600 text-white py-3 px-6 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
        >
          Envoyer le Message
        </button>
      </form>
    </div>
  </div>
</div>
