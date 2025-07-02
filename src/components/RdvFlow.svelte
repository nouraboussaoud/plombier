<script lang="ts">
  import {
    Calendar,
    ArrowRight,
    ArrowLeft,
    Wrench,
    Droplets,
    Settings,
    Home,
    Zap,
    CheckCircle,
    Clock,
    MapPin,
    Phone,
    User,
    Mail,
  } from 'lucide-svelte';
  import { navigate } from '../lib/router.js';
  import { supabase } from '../lib/supabase.js';

  let currentStep = $state(1);
  let selectedServiceType = $state('');
  let selectedCategory = $state('');
  let selectedProblem = $state('');
  
  // Contact form data
  let contactData = $state({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    address: '',
    preferredDate: '',
    preferredTime: '',
    message: ''
  });
  
  let isSubmitting = $state(false);
  let isSubmitted = $state(false);
  let submitMessage = $state('');
  
  // Get today's date in YYYY-MM-DD format for date input
  const today = new Date().toISOString().split('T')[0];

  // Step 1: Main service types
  const serviceTypes = [
    {
      id: 'depannage',
      name: 'DÉPANNAGE',
      description: 'Intervention d\'urgence pour réparer',
      icon: Wrench,
      color: 'bg-red-500',
      available: true,
    },
    {
      id: 'installation',
      name: 'INSTALLATION',
      description: 'Pose et installation d\'équipements',
      icon: Settings,
      color: 'bg-blue-500',
      available: false,
    },
    {
      id: 'entretien',
      name: 'ENTRETIEN',
      description: 'Maintenance préventive',
      icon: CheckCircle,
      color: 'bg-green-500',
      available: false,
    },
  ];

  // Step 2: Categories (only for dépannage)
  const categories = [
    {
      id: 'wc',
      name: 'WC',
      description: 'Toilettes et sanitaires',
      icon: Home,
      color: 'bg-blue-500',
      available: true,
    },
    {
      id: 'douche-baignoire',
      name: 'DOUCHE ET BAIGNOIRE',
      description: '(INCLUS ROBINETTERIE)',
      icon: Droplets,
      color: 'bg-blue-400',
      available: false,
    },
    {
      id: 'lavabo-evier',
      name: 'LAVABO ET ÉVIER',
      description: '(INCLUS ROBINETTERIE)',
      icon: Droplets,
      color: 'bg-cyan-500',
      available: false,
    },
    {
      id: 'canalisation',
      name: 'CANALISATION ET TUYAUTERIE',
      description: '(HORS DOUCHE, BAIGNOIRE, LAVABO, ÉVIER)',
      icon: Settings,
      color: 'bg-gray-500',
      available: false,
    },
    {
      id: 'tuyau-machine',
      name: 'TUYAU',
      description: '(MACHINE À LAVER, LAVE VAISSELLE)',
      icon: Settings,
      color: 'bg-purple-500',
      available: false,
    },
    {
      id: 'ballon-chaudiere',
      name: 'BALLON D\'EAU CHAUDE, CHAUFFE-EAU',
      description: 'CHAUDIÈRE, PAC AIR-EAU, PAC AIR-AIR',
      icon: Zap,
      color: 'bg-orange-500',
      available: false,
    },
  ];

  // Step 3: Specific WC problems
  const wcProblems = [
    {
      id: 'wc-bouches',
      name: 'WC bouchés (engorgement)',
      description: 'Toilettes obstruées, évacuation difficile',
      icon: '🚽',
      urgency: 'urgent',
      needsSanibroyeur: true,
    },
    {
      id: 'fuite',
      name: 'Fuite (recherche de fuite)',
      description: 'Fuite d\'eau visible ou suspectée',
      icon: '💧',
      urgency: 'rapide',
      needsWcType: true,
    },
    {
      id: 'fonctionnement-defectueux',
      name: 'Fonctionnement défectueux',
      description: 'Chasse d\'eau, mécanisme défaillant',
      icon: '⚙️',
      urgency: 'planifie',
      needsWcType: true,
    },
  ];

  // New state variables
  let hasSanibroyeur = $state('');
  let wcType = $state('');
  let houseAge = $state('');

  // WC Types
  const wcTypes = [
    { id: 'simple', name: 'WC Simple', description: 'WC classique au sol' },
    { id: 'suspendu', name: 'WC Suspendu', description: 'WC fixé au mur' },
    { id: 'autre', name: 'Autre', description: 'Autre type de WC' }
  ];

  // House age options for TVA
  const houseAgeOptions = [
    { 
      id: 'plus-2-ans', 
      name: 'Maison de plus de 2 ans', 
      description: 'TVA 10%',
      tva: 10 
    },
    { 
      id: 'moins-2-ans', 
      name: 'Maison de moins de 2 ans / Professionnel', 
      description: 'TVA 20%',
      tva: 20 
    }
  ];

  // Price calculation function
  function calculatePrice() {
    if (!selectedProblemData) return null;
    
    let basePrice = 0;
    
    // Base prices for WC problems
    if (selectedProblem === 'wc-bouches') {
      if (hasSanibroyeur === 'oui') {
        basePrice = 150; // Prix fixe avec sanibroyeur
      } else {
        basePrice = 80; // Prix de base sans sanibroyeur
      }
    } else if (selectedProblem === 'fuite') {
      basePrice = wcType === 'suspendu' ? 120 : wcType === 'simple' ? 90 : 100;
    } else if (selectedProblem === 'fonctionnement-defectueux') {
      basePrice = wcType === 'suspendu' ? 100 : wcType === 'simple' ? 70 : 85;
    }
    
    // Apply TVA
    const selectedHouseAge = houseAgeOptions.find(h => h.id === houseAge);
    if (selectedHouseAge) {
      const tvaMultiplier = 1 + (selectedHouseAge.tva / 100);
      return Math.round(basePrice * tvaMultiplier);
    }
    
    return basePrice;
  }

  // Update step navigation functions
  function handleProblemSelect(problemId: string) {
    selectedProblem = problemId;
    const problem = wcProblems.find(p => p.id === problemId);
    
    if (problem?.needsSanibroyeur) {
      currentStep = 4; // Sanibroyeur question
    } else if (problem?.needsWcType) {
      currentStep = 5; // WC type question
    } else {
      currentStep = 6; // House age question
    }
  }

  function handleSanibroyeurSelect(answer: string) {
    hasSanibroyeur = answer;
    currentStep = 6; // Go to house age question
  }

  function handleWcTypeSelect(type: string) {
    wcType = type;
    currentStep = 6; // Go to house age question
  }

  function handleHouseAgeSelect(age: string) {
    houseAge = age;
    currentStep = 7; // Go to summary
  }

  function goToContactForm() {
    currentStep = 8;
  }

  async function submitAppointment() {
    isSubmitting = true;
    
    try {
      const appointmentData = {
        first_name: contactData.firstName,
        last_name: contactData.lastName,
        email: contactData.email,
        phone: contactData.phone,
        service: `${selectedServiceType}-${selectedCategory}-${selectedProblem}`,
        urgency: selectedProblemData?.urgency || 'planifie',
        preferred_date: contactData.preferredDate || null,
        preferred_time: contactData.preferredTime || null,
        address: contactData.address,
        message: contactData.message,
        status: 'pending',
        created_at: new Date().toISOString()
      };

      const { data, error } = await supabase
        .from('appointments')
        .insert([appointmentData])
        .select()
        .single();

      if (error) throw error;

      isSubmitted = true;
      submitMessage = 'Votre demande de rendez-vous a été envoyée avec succès !';
      currentStep = 9;
      
    } catch (error) {
      console.error('Error submitting appointment:', error);
      submitMessage = 'Une erreur est survenue. Veuillez réessayer.';
    } finally {
      isSubmitting = false;
    }
  }

  function goBack() {
    if (currentStep > 1) {
      // Handle specific back navigation logic
      if (currentStep === 6) {
        // Coming from house age question
        if (selectedProblem === 'wc-bouches') {
          currentStep = 4; // Back to sanibroyeur question
        } else {
          currentStep = 5; // Back to WC type question
        }
      } else if (currentStep === 5) {
        currentStep = 3; // Back to problem selection
      } else if (currentStep === 4) {
        currentStep = 3; // Back to problem selection
      } else {
        currentStep = currentStep - 1;
      }
    }
  }

  function resetFlow() {
    currentStep = 1;
    selectedServiceType = '';
    selectedCategory = '';
    selectedProblem = '';
    contactData = {
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      address: '',
      preferredDate: '',
      preferredTime: '',
      message: ''
    };
  }

  function handleServiceTypeSelect(serviceId: string) {
    selectedServiceType = serviceId;
    if (serviceId === 'depannage') {
      currentStep = 2; // Go to category selection
    }
    // For other service types, you can add logic here when they become available
  }

  function handleCategorySelect(categoryId: string) {
    selectedCategory = categoryId;
    if (categoryId === 'wc') {
      currentStep = 3; // Go to WC problem selection
    }
    // For other categories, you can add logic here when they become available
  }

  function goHome() {
    navigate('/');
  }

  // Derived values
  const selectedProblemData = $derived(wcProblems.find((p) => p.id === selectedProblem));
  const maxSteps = $derived(isSubmitted ? 9 : 8);
</script>

<div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-orange-50">
  <!-- Header -->
  <header class="bg-white shadow-sm border-b">
    <div class="container mx-auto px-4 py-4">
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-4">
          <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-orange-500 rounded-lg flex items-center justify-center">
            <Droplets class="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 class="text-2xl font-bold text-gray-800">FRD Services</h1>
            <p class="text-sm text-gray-600">Spécialiste du dépannage urgent</p>
          </div>
        </div>
        <div class="flex items-center space-x-4">
          <button onclick={() => navigate('/')} class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
            ← Accueil
          </button>
          <button class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 flex items-center">
            <Phone class="w-4 h-4 mr-2" />
            Appeler
          </button>
        </div>
      </div>
    </div>
  </header>

  <!-- Progress Bar -->
  {#if !isSubmitted}
    <div class="bg-white border-b overflow-scroll">
      <div class="container mx-auto px-4 py-4">
        <div class="flex items-center justify-center space-x-4">
          {#each Array(maxSteps).fill(0).map((_, i) => i + 1) as step}
            <div class="flex items-center">
              <div
                class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold"
                class:bg-blue-500={step <= currentStep}
                class:text-white={step <= currentStep}
                class:bg-gray-200={step > currentStep}
                class:text-gray-500={step > currentStep}
              >
                {step}
              </div>
              {#if step < maxSteps}
                <div 
                  class="w-12 h-1 mx-2 "
                  class:bg-blue-500={step < currentStep}
                  class:bg-gray-200={step >= currentStep}
                ></div>
              {/if}
            </div>
          {/each}
        </div>
        <div class="text-center mt-2">
          <p class="text-sm text-gray-600">Étape {currentStep} sur {maxSteps}</p>
        </div>
      </div>
    </div>
  {/if}

  <div class="container mx-auto px-4 py-8 ">
    <div class="max-w-4xl mx-auto">

      <!-- Step 1: Service Type Selection -->
      {#if currentStep === 1}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-blue-500 to-orange-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center">Identifiez votre besoin</h2>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-3 gap-6">
              {#each serviceTypes as service}
                <button
                  type="button"
                  onclick={() => handleServiceTypeSelect(service.id)}
                  class="p-8 rounded-xl border-2 cursor-pointer transition-all duration-300 text-center"
                  class:hover:shadow-lg={service.available}
                  class:hover:border-blue-300={service.available}
                  class:border-gray-200={service.available}
                  class:opacity-50={!service.available}
                  class:cursor-not-allowed={!service.available}
                  class:border-gray-100={!service.available}
                  aria-label={`Select ${service.name}`}
                >
                  <div class="w-16 h-16 {service.color} rounded-full flex items-center justify-center mx-auto mb-4">
                    <service.icon class="w-8 h-8 text-white" />
                  </div>
                  <h3 class="text-xl font-bold text-gray-800 mb-2">{service.name}</h3>
                  <p class="text-gray-600">{service.description}</p>
                  {#if !service.available}
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 mt-3">
                      Bientôt disponible
                    </span>
                  {/if}
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 2: Category Selection -->
      {#if currentStep === 2}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-red-500 to-orange-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center">Choisissez la catégorie - DÉPANNAGE</h2>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {#each categories as category}
                <button
                  type="button"
                  onclick={() => handleCategorySelect(category.id)}
                  class="p-6 rounded-xl border-2 cursor-pointer transition-all duration-300"
                  class:hover:shadow-lg={category.available}
                  class:hover:border-blue-300={category.available}
                  class:border-gray-200={category.available}
                  class:opacity-50={!category.available}
                  class:cursor-not-allowed={!category.available}
                  class:border-gray-100={!category.available}
                  aria-label={`Select ${category.name}`}
                >
                  <div class="w-12 h-12 {category.color} rounded-lg flex items-center justify-center mx-auto mb-4">
                    <category.icon class="w-6 h-6 text-white" />
                  </div>
                  <h3 class="font-bold text-gray-800 mb-2">{category.name}</h3>
                  <p class="text-sm text-gray-600">{category.description}</p>
                  {#if !category.available}
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 mt-3">
                      Bientôt disponible
                    </span>
                  {/if}
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 3: WC Problem Selection -->
      {#if currentStep === 3}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-blue-500 to-cyan-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center">Quel est plus précisément votre problème ?</h2>
            <p class="text-center text-blue-100 mt-2">Catégorie : WC</p>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-1 gap-6 max-w-2xl mx-auto">
              {#each wcProblems as problem}
                <button
                  type="button"
                  onclick={() => handleProblemSelect(problem.id)}
                  class="p-6 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-300 border-gray-200"
                  aria-label={`Select ${problem.name}`}
                >
                  <div class="flex items-center space-x-4">
                    <div class="text-4xl">{problem.icon}</div>
                    <div class="flex-1">
                      <h3 class="text-xl font-bold text-gray-800 mb-2">{problem.name}</h3>
                      <p class="text-gray-600 mb-3">{problem.description}</p>
                      <div class="flex items-center justify-between">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border border-gray-300 text-gray-700 capitalize">
                          {problem.urgency}
                        </span>
                      </div>
                    </div>
                    <ArrowRight class="w-6 h-6 text-gray-400" />
                  </div>
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 4: Sanibroyeur Question (only for WC bouchés) -->
      {#if currentStep === 4}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-purple-500 to-blue-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center">Votre WC est équipé d'un sanibroyeur ?</h2>
            <p class="text-center text-purple-100 mt-2">Cette information nous aide à estimer le prix</p>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-2 gap-6 max-w-2xl mx-auto">
              <button
                type="button"
                onclick={() => handleSanibroyeurSelect('oui')}
                class="p-8 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-green-300 border-gray-200 text-center"
              >
                <div class="text-6xl mb-4">✅</div>
                <h3 class="text-2xl font-bold text-gray-800 mb-2">OUI</h3>
                <p class="text-gray-600">Mon WC a un sanibroyeur</p>
                <div class="mt-4 bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-semibold">
                  Prix fixe : 150€ TTC
                </div>
              </button>
              
              <button
                type="button"
                onclick={() => handleSanibroyeurSelect('non')}
                class="p-8 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-300 border-gray-200 text-center"
              >
                <div class="text-6xl mb-4">❌</div>
                <h3 class="text-2xl font-bold text-gray-800 mb-2">NON</h3>
                <p class="text-gray-600">WC classique sans sanibroyeur</p>
                <div class="mt-4 bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-semibold">
                  À partir de 80€
                </div>
              </button>
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 5: WC Type Question (for fuite and fonctionnement-defectueux) -->
      {#if currentStep === 5}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-indigo-500 to-purple-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center">Quel type de WC possédez-vous ?</h2>
            <p class="text-center text-indigo-100 mt-2">Le type de WC influence le tarif d'intervention</p>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-3 gap-6">
              {#each wcTypes as type}
                <button
                  type="button"
                  onclick={() => handleWcTypeSelect(type.id)}
                  class="p-6 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-300 border-gray-200 text-center"
                >
                  <div class="text-4xl mb-4">
                    {#if type.id === 'simple'}🚽
                    {:else if type.id === 'suspendu'}🏗️
                    {:else}❓{/if}
                  </div>
                  <h3 class="text-xl font-bold text-gray-800 mb-2">{type.name}</h3>
                  <p class="text-gray-600">{type.description}</p>
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 6: House Age / TVA Question -->
      {#if currentStep === 6}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-green-500 to-teal-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center">Âge de votre logement</h2>
            <p class="text-center text-green-100 mt-2">Pour appliquer le bon taux de TVA</p>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-2 gap-6 max-w-3xl mx-auto">
              {#each houseAgeOptions as option}
                <button
                  type="button"
                  onclick={() => handleHouseAgeSelect(option.id)}
                  class="p-8 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-green-300 border-gray-200 text-center"
                >
                  <div class="text-5xl mb-4">
                    {#if option.id === 'plus-2-ans'}🏠
                    {:else}🏗️{/if}
                  </div>
                  <h3 class="text-xl font-bold text-gray-800 mb-2">{option.name}</h3>
                  <p class="text-gray-600 mb-3">{option.description}</p>
                  <div class="bg-{option.tva === 10 ? 'green' : 'orange'}-100 text-{option.tva === 10 ? 'green' : 'orange'}-800 px-3 py-1 rounded-full text-sm font-semibold">
                    TVA {option.tva}%
                  </div>
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 7: Updated Summary with calculated price -->
      {#if currentStep === 7}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-green-500 to-blue-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center flex items-center justify-center">
              <CheckCircle class="w-8 h-8 mr-3" />
              Récapitulatif de votre demande
            </h2>
          </div>
          <div class="p-8">
            <div class="max-w-2xl mx-auto">
              <!-- Service Summary -->
              <div class="bg-blue-50 rounded-lg p-6 mb-6">
                <h3 class="text-xl font-bold text-blue-800 mb-4">Votre sélection</h3>
                <div class="space-y-3">
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Type de service :</span>
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-500 text-white">
                      DÉPANNAGE
                    </span>
                  </div>
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Catégorie :</span>
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border border-gray-300 text-gray-700">
                      WC
                    </span>
                  </div>
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Problème :</span>
                    <span class="font-semibold text-blue-700">
                      {selectedProblemData?.name}
                    </span>
                  </div>
                  
                  {#if selectedProblem === 'wc-bouches'}
                    <div class="flex justify-between items-center">
                      <span class="font-medium">Sanibroyeur :</span>
                      <span class="capitalize font-semibold">{hasSanibroyeur}</span>
                    </div>
                  {/if}
                  
                  {#if wcType}
                    <div class="flex justify-between items-center">
                      <span class="font-medium">Type de WC :</span>
                      <span class="capitalize font-semibold">{wcTypes.find(w => w.id === wcType)?.name}</span>
                    </div>
                  {/if}
                  
                  <div class="flex justify-between items-center">
                    <span class="font-medium">TVA :</span>
                    <span class="font-semibold">{houseAgeOptions.find(h => h.id === houseAge)?.tva}%</span>
                  </div>
                </div>
              </div>

              <!-- Price Estimation -->
              <div class="bg-green-50 rounded-lg p-6 mb-6">
                <h3 class="text-xl font-bold text-green-800 mb-4">Prix TTC</h3>
                <div class="text-center">
                  <div class="text-4xl font-bold text-green-600 mb-2">
                    {calculatePrice()}€
                  </div>
                  <p class="text-gray-600">Prix estimé pour l'intervention</p>
                </div>
              </div>

              <!-- What's included -->
              <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 mb-8">
                <h4 class="font-bold text-yellow-800 mb-3">💡 Cette estimation inclut :</h4>
                <ul class="text-sm text-yellow-700 space-y-2">
                  <li class="flex items-center">
                    <CheckCircle class="w-4 h-4 mr-2 text-green-600" />
                    Déplacement et diagnostic
                  </li>
                  <li class="flex items-center">
                    <CheckCircle class="w-4 h-4 mr-2 text-green-600" />
                    Main d'œuvre qualifiée
                  </li>
                  <li class="flex items-center">
                    <CheckCircle class="w-4 h-4 mr-2 text-green-600" />
                    Petites fournitures courantes
                  </li>
                  <li class="flex items-center">
                    <CheckCircle class="w-4 h-4 mr-2 text-green-600" />
                    Garantie intervention
                  </li>
                </ul>
              </div>

              <!-- Action Buttons -->
              <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <button onclick={goToContactForm} class="px-8 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg font-semibold transition-colors flex items-center justify-center">
                  <Calendar class="w-5 h-5 mr-2" />
                  Prendre rendez-vous
                </button>
                <button class="px-8 py-3 border border-gray-300 text-gray-700 bg-white hover:bg-gray-50 rounded-lg font-semibold transition-colors flex items-center justify-center">
                  <Phone class="w-5 h-5 mr-2" />
                  Appeler maintenant
                </button>
              </div>

              <div class="text-center mt-6">
                <p class="text-sm text-gray-500">
                  * Prix indicatif, devis définitif après diagnostic sur place
                </p>
              </div>
            </div>
          </div>
        </div>
      {/if}

      <!-- Update step numbers for contact form (Step 8) and success (Step 9) -->
      {#if currentStep === 8}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-blue-500 to-green-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center flex items-center justify-center">
              <User class="w-8 h-8 mr-3" />
              Vos informations
            </h2>
          </div>
          <div class="p-8">
            <form onsubmit={(e) => { e.preventDefault(); submitAppointment(); }}>
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
                    bind:value={contactData.firstName}
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
                    bind:value={contactData.lastName}
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
                    bind:value={contactData.email}
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
                    bind:value={contactData.phone}
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
                  bind:value={contactData.address}
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
                    bind:value={contactData.preferredDate}
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
                    bind:value={contactData.preferredTime}
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
                  bind:value={contactData.message}
                  rows="4"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                  placeholder="Décrivez votre problème ou demande en détail..."
                ></textarea>
              </div>

              <!-- Submit Button -->
              <div class="text-center">
                <button
                  type="submit"
                  disabled={isSubmitting || !contactData.firstName || !contactData.lastName || !contactData.email || !contactData.phone || !contactData.address}
                  class="px-8 py-4 bg-green-600 hover:bg-green-700 disabled:bg-gray-400 text-white rounded-lg font-semibold transition-colors flex items-center mx-auto"
                >
                  {#if isSubmitting}
                    <div class="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-2"></div>
                    Envoi en cours...
                  {:else}
                    <CheckCircle class="w-5 h-5 mr-2" />
                    Confirmer la demande
                  {/if}
                </button>
              </div>
            </form>
          </div>
        </div>
      {/if}

      <!-- Step 9: Success Message -->
      {#if currentStep === 9 && isSubmitted}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div class="bg-gradient-to-r from-green-500 to-blue-500 text-white p-8">
            <h2 class="text-3xl font-bold text-center flex items-center justify-center">
              <CheckCircle class="w-8 h-8 mr-3" />
              Demande envoyée !
            </h2>
          </div>
          <div class="p-12 text-center">
            <div class="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-8">
              <CheckCircle class="w-12 h-12 text-green-600" />
            </div>
            
            <h1 class="text-4xl font-bold text-gray-800 mb-6">Demande envoyée !</h1>
            <p class="text-xl text-gray-600 mb-8">{submitMessage}</p>
            
            <div class="bg-blue-50 rounded-lg p-6 mb-8">
              <h3 class="font-semibold text-blue-800 mb-2">Prochaines étapes :</h3>
              <ul class="text-blue-700 space-y-2">
                <li>• Nous vous contacterons dans les plus brefs délais</li>
                <li>• Un technicien confirmera le rendez-vous</li>
                <li>• Vous recevrez un SMS de confirmation</li>
              </ul>
            </div>
            
            <button
              onclick={goHome}
              class="px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-semibold transition-colors flex items-center mx-auto"
            >
              <Home class="w-5 h-5 mr-2" />
              Retour à l'accueil
            </button>
          </div>
        </div>
      {/if}

      <!-- Navigation Buttons -->
      {#if currentStep > 1 && currentStep < 8}
        <div class="flex justify-between items-center mt-8">
          <button 
            type="button"
            onclick={goBack}
            class="px-6 py-3 border border-gray-300 text-gray-700 bg-transparent hover:bg-gray-50 rounded-lg font-medium transition-colors flex items-center"
            aria-label="Go back"
          >
            <ArrowLeft class="w-4 h-4 mr-2" />
            Retour
          </button>
          {#if currentStep < 7}
            <button 
              type="button"
              onclick={resetFlow}
              class="px-6 py-3 text-gray-500 bg-transparent hover:bg-gray-50 rounded-lg font-medium transition-colors"
              aria-label="Reset flow"
            >
              Recommencer
            </button>
          {/if}
        </div>
      {/if}
    </div>
  </div>

  <!-- Service Features Footer -->
  {#if currentStep <= 7}
    <section class="bg-gray-50 py-12 mt-16">
      <div class="container mx-auto px-4">
        <div class="grid md:grid-cols-4 gap-8">
          <div class="text-center">
            <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <CheckCircle class="w-8 h-8 text-blue-600" />
            </div>
            <h3 class="font-bold text-gray-800 mb-2">ESTIMATION TARIFAIRE AVANT LE RDV</h3>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Clock class="w-8 h-8 text-red-600" />
            </div>
            <h3 class="font-bold text-gray-800 mb-2">DÉPANNAGE 7J/7 24H/24</h3>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <MapPin class="w-8 h-8 text-green-600" />
            </div>
            <h3 class="font-bold text-gray-800 mb-2">INTERVENTION SUR TOUTE L'ÎLE-DE-FRANCE</h3>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Wrench class="w-8 h-8 text-orange-600" />
            </div>
            <h3 class="font-bold text-gray-800 mb-2">UNE ÉQUIPE QUALIFIÉE ET CERTIFIÉE</h3>
          </div>
        </div>
      </div>
    </section>
  {/if}
</div>
