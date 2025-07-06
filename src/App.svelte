<script lang="ts">
  import { User, ShoppingCart, Phone, Mail, MapPin, Calendar } from 'lucide-svelte';
  import { onMount } from 'svelte';
  import { currentRoute, initRouter, navigate } from './lib/router.js';
  

  import RdvFlow from './components/RdvFlow.svelte';


  
  let selectedService = $state<typeof services[keyof typeof services] | null>(null);
  let isModalOpen = $state(false);
  let scrollY = $state(0);
  
  // Scroll animations
  let heroRef = $state();
  let servicesRef = $state();
  let contentRef = $state();
  
  onMount(() => {
    initRouter();
    
    // Scroll animations
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-fade-in-up');
        }
      });
    }, observerOptions);
    
    // Observe elements for animation
    document.querySelectorAll('.animate-on-scroll').forEach(el => {
      observer.observe(el);
    });
    
    // Scroll listener for parallax effects
    const handleScroll = () => {
      scrollY = window.scrollY;
    };
    
    window.addEventListener('scroll', handleScroll);
    
    return () => {
      observer.disconnect();
      window.removeEventListener('scroll', handleScroll);
    };
  });

  const services = {
    plomberie: {
      title: "PLOMBERIE",
      subtitle: "Dépannage urgent, installation et rénovation",
      description: "Service de plomberie complet disponible 24h/24 et 7j/7. Nos plombiers interviennent rapidement pour tous vos problèmes de plomberie urgents.",
      features: [
        "Dépannage urgent 24h/24",
        "Réparation de fuites",
        "Installation sanitaire complète",
        "Rénovation de salle de bain",
        "Débouchage d'urgence"
      ],
      certifications: []
    },
    debouchage: {
      title: "DÉBOUCHAGE CANALISATIONS",
      subtitle: "Débouchage canalisations 7J/7",
      description: "Service de débouchage professionnel disponible 7 jours sur 7. Nous utilisons des équipements haute pression pour un débouchage efficace.",
      features: [
        "Débouchage haute pression",
        "Curage de canalisations",
        "Inspection vidéo",
        "Travaux d'assainissement",
        "Intervention d'urgence 7j/7"
      ],
      certifications: []
    },
    chauffage: {
      title: "CHAUFFAGE",
      subtitle: "La solution chauffage adaptée à votre logement",
      description: "Spécialistes en chauffage, nous proposons des solutions adaptées à chaque logement. Installation, entretien et dépannage de tous types d'équipements.",
      features: [
        "Installation de chaudières",
        "Entretien annuel obligatoire",
        "Dépannage d'urgence",
        "Radiateurs et plancher chauffant",
        "Conseil en économie d'énergie"
      ],
      certifications: ["RGE Chauffage +", "PG"]
    },
    ballon: {
      title: "BALLON/CHAUFFE-EAU",
      subtitle: "Un grand choix de chauffe-eau et ballon d'eau chaude",
      description: "Large gamme de chauffe-eau et ballons d'eau chaude en stock. Installation, dépannage et entretien par nos techniciens certifiés.",
      features: [
        "Chauffe-eau électrique",
        "Chauffe-eau thermodynamique",
        "Ballon d'eau chaude",
        "Dépannage et entretien",
        "Stock permanent des grandes marques"
      ],
      certifications: ["RGE"]
    },
    chaudiere: {
      title: "CHAUDIÈRE GAZ",
      subtitle: "Entretien, dépannage et remplacement",
      description: "Spécialistes des chaudières gaz, nous assurons l'entretien, le dépannage et le remplacement de votre ancienne chaudière par une chaudière gaz moderne.",
      features: [
        "Entretien annuel chaudière gaz",
        "Dépannage d'urgence",
        "Remplacement chaudière",
        "Chaudières gaz condensation",
        "Conseil en économie d'énergie"
      ],
      certifications: ["RGE", "PG"]
    },
    pompe: {
      title: "POMPE À CHALEUR/CLIMATISATION",
      subtitle: "La solution climatisation pour rafraîchir votre habitation",
      description: "Installation et entretien de pompes à chaleur air/air et air/eau. Solutions de climatisation pour un confort optimal toute l'année.",
      features: [
        "Pompe à chaleur air/air",
        "Pompe à chaleur air/eau",
        "Climatisation réversible",
        "Entretien et maintenance",
        "Conseil en efficacité énergétique"
      ],
      certifications: ["RGE", "QUALIPAC"]
    }
  };

  const navItems = [
    { label: 'PLOMBERIE', key: 'plomberie' },
    { label: 'DÉBOUCHAGE CANALISATIONS', key: 'debouchage' },
    { label: 'CHAUFFAGE', key: 'chauffage' },
    { label: 'BALLON/CHAUFFE-EAU', key: 'ballon' },
    { label: 'RDV INTERVENTION & DEVIS', key: 'rdv' },
    { label: 'CHAUDIÈRE GAZ', key: 'chaudiere' },
    { label: 'POMPE À CHALEUR/CLIMATISATION', key: 'pompe' },
    { label: 'VOS PROJETS', key: 'projets' },
    { label: 'FRD Services', key: 'about' }
  ];

  function handleNavClick(key: string) {
    if (key === 'rdv') {
      navigate('/rdv');
    } else if (key in services) {
      openServiceModal(key);
    }
  }

  function openServiceModal(serviceKey: string) {
    if (serviceKey in services) {
      selectedService = services[serviceKey as keyof typeof services];
      isModalOpen = true;
    }
  }

  function closeModal() {
    isModalOpen = false;
    selectedService = null;
  }
</script>

<svelte:window bind:scrollY />

<style>
    footer {
  position: relative !important;
  z-index: 1000 !important;
  background-color: #1f2937 !important;
  min-height: 300px !important;
}
@keyframes wave {
    0% {
      transform: translateY(10px);
    }
    50% {
      transform: translateY(-30px);
    }
    100% {
      transform: translateY(10px);
    }
  }

  .animate-wave {
    animation: wave 3s ease-in-out infinite;
  }
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
  
  .animate-on-scroll {
    opacity: 1 !important;
  transform: translateY(0) !important;
  }
  
  .parallax-bg {
    transform: translateY(calc(var(--scroll) * 0.5px));
  }
</style>

{#if $currentRoute === '/'}
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="relative bg-white sticky top-0 z-40 backdrop-blur-sm">
  <!-- Decorative wave pattern -->
  <div class="absolute top-0 right-0 w-full h-32 overflow-hidden max-sm:hidden">
    <div class="absolute top-0 right-0 w-full h-full transform rotate-12 translate-x-32 -translate-y-8">
      <!-- Wave background with gradient -->
      <svg class="w-full h-full" viewBox="0 0 1200 400" preserveAspectRatio="none">
        <path
          d="M0,0 C300,50 600,150 900,50 C1100,0 1200,100 1200,200 V400 H0 Z"
          fill="url(#waveGradient)"
          class="animate-wave"
        />
        <defs>
          <linearGradient id="waveGradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color: rgba(59, 130, 246, 0.3);" />
            <stop offset="50%" style="stop-color: rgba(59, 130, 246, 0.2);" />
            <stop offset="100%" style="stop-color: rgba(249, 115, 22, 0.3);" />
          </linearGradient>
        </defs>
      </svg>
    </div>

    <!-- Diagonal text elements -->
    <div class="absolute top-4 right-20 transform rotate-12 text-gray-600 text-sm font-semibold">
      <div class="mb-2">INSTALLATION</div>
      <div class="mb-2">ENTRETIEN</div>
      <div>DÉPANNAGE</div>
    </div>
  </div>

  <div class="container mx-auto px-4 py-4">
    <div class="flex items-center justify-between">
      <!-- Logo and company info -->
      <div class="flex items-center space-x-7">
        <div class="relative">
          <!-- Water drop logo -->
          <div class="w-16 h-20 relative">
            <div class="absolute inset-0 w-full h-full flex items-center justify-center">
              <img src="logo.png" alt="FRD Services Logo" />
            </div>
          </div>
        </div>
        <div>
          <h1 class="text-2xl font-bold text-blue-600">FRD Services</h1>
          <p class="text-sm text-gray-600">Plomberie Chauffage</p>
          <p class="text-sm text-gray-600">Climatisation</p>
        </div>
        <div class="hidden md:block ml-8">
          <p class="text-lg font-semibold text-gray-800">Spécialiste du dépannage urgent</p>
        </div>
      </div>

      <!-- User and cart icons (commented out as per your code) -->
      <!-- 
      <div class="flex items-center space-x-4">
        <button class="p-2 text-gray-600 hover:text-blue-600 transition-colors">
          <User size={24} />
        </button>
        <button class="relative p-2 text-gray-600 hover:text-orange-500 transition-colors">
          <ShoppingCart size={24} />
          <span class="absolute -top-1 -right-1 bg-orange-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">0</span>
        </button>
      </div>
      -->
    </div>
  </div>
</header>

    <!-- Navigation -->
    <nav class="bg-gray-50 border-t border-gray-200 sticky top-24 z-30 backdrop-blur-sm bg-gray-50/95">
      <div class="container mx-auto px-4">
        <div class="flex flex-wrap justify-center space-x-1 py-3">
          {#each navItems as item}
            <button 
              onclick={() => handleNavClick(item.key)}
              class="px-3 py-2 text-sm font-medium text-gray-700 hover:text-blue-600 hover:bg-white rounded transition-all duration-300 whitespace-nowrap transform hover:scale-105"
              class:bg-orange-100={item.key === 'rdv'}
              class:text-orange-600={item.key === 'rdv'}
              class:shadow-md={item.key === 'rdv'}
            >
              {item.label}
            </button>
          {/each}
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section bind:this={heroRef} class="relative min-h-[600px] overflow-hidden">
      <!-- Kitchen background image with parallax -->
      <div class="absolute inset-0 parallax-bg" style="--scroll: {scrollY}">
        <img 
          src="/Plumbing.jpg" 
          alt="Modern kitchen with boiler installation"
          class="w-full h-full object-cover  max-sm:h-fit max-sm:object-cover animate-fade-in"
        />
      </div>

      <!-- Blue geometric overlay -->
      <div class="absolute inset-0 bg-gradient-to-r from-transparent via-blue-400/20 to-blue-500/40">
        <!-- Hexagonal pattern overlay -->
        <div class="absolute right-0 top-0 w-2/3 h-full">
          <div class="relative w-full h-full">
            <!-- Large hexagonal shape -->
            <div class="absolute right-0 top-1/4 w-96 h-96 bg-white/90 transform rotate-45 rounded-3xl animate-pulse"></div>
            
            <!-- Hexagonal dots pattern -->
            <div class="absolute right-20 top-20 grid grid-cols-8 gap-2 opacity-30">
              {#each Array(64) as _, i}
                <div class="w-4 h-4 bg-blue-300 rounded-full animate-pulse" style="animation-delay: {i * 0.1}s"></div>
              {/each}
            </div>
          </div>
        </div>
      </div>

      <!-- Action buttons -->
      <div class="absolute right-8 top-1/2 transform -translate-y-1/2 space-y-4">
        <button class="w-16 h-16 bg-orange-500 hover:bg-orange-600 text-white rounded-lg shadow-lg transition-all duration-300 flex items-center justify-center hover:scale-110 hover:shadow-xl">
          <Phone size={24} />
        </button>
        <button class="w-16 h-16 bg-orange-500 hover:bg-orange-600 text-white rounded-lg shadow-lg transition-all duration-300 flex items-center justify-center hover:scale-110 hover:shadow-xl">
          <Mail size={24} />
        </button>
        <button onclick={() => navigate('/rdv')} class="w-16 h-16 bg-orange-500 hover:bg-orange-600 text-white rounded-lg shadow-lg transition-all duration-300 flex items-center justify-center hover:scale-110 hover:shadow-xl">
          <Calendar size={24} />
        </button>
      </div>
    </section>

    <!-- Content Section -->
    <section bind:this={contentRef} class="py-16 bg-white animate-on-scroll">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-800 mb-8">
            FRD Services Plomberie Chauffage, Spécialiste du dépannage urgent
          </h2>
          <p class="text-lg text-gray-600 leading-relaxed">
            <strong>FRD Services PLOMBERIE CHAUFFAGE</strong> est spécialiste du dépannage urgent. Nous intervenons pour des interventions urgentes en 
            plomberie et chauffage sur toute l'Île-de-France mais également sur Orléans (Loiret 45), Tours (Indre-et-Loire 37) et Caen 
            (Calvados 14). Nous couvrons également les travaux d'entretien, d'installation de vos appareils sanitaires et équipement de 
            chauffage et climatisation.
          </p>
        </div>
      </div>
    </section>

    <!-- Services Grid -->
    <section bind:this={servicesRef} class="py-16 bg-gray-50 animate-on-scroll">
      <div class="container mx-auto px-4">
        <h2 class="text-3xl font-bold text-center text-gray-800 mb-12">Nos Services</h2>
        
        <!-- Main Services Grid -->
        <div class="grid lg:grid-cols-2 gap-8 mb-8">
          
          <!-- PLOMBERIE -->
          <div class="bg-white p-8 rounded-lg shadow-md hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll">
            <div class="flex items-start mb-6">
              <div class="w-16 h-16 bg-blue-500 rounded-lg mr-6 flex items-center justify-center flex-shrink-0">
                <div class="w-8 h-8 bg-white rounded"></div>
              </div>
              <div class="flex-1">
                <h3 class="text-xl font-bold text-gray-800 mb-2">PLOMBERIE</h3>
                <p class="text-gray-600 mb-4">Dépannage urgent, installation et rénovation de plomberie</p>
                <button onclick={() => openServiceModal('plomberie')} class="text-blue-600 hover:text-blue-800 font-semibold transition-colors">
                  En savoir +
                </button>
              </div>
            </div>
          </div>

          <!-- CHAUFFAGE -->
          <div class="bg-white p-8 rounded-lg shadow-md hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll">
            <div class="flex items-start mb-6">
              <div class="w-16 h-16 bg-orange-500 rounded-lg mr-6 flex items-center justify-center flex-shrink-0">
                <div class="w-8 h-8 bg-white rounded-full"></div>
              </div>
              <div class="flex-1">
                <h3 class="text-xl font-bold text-gray-800 mb-2">CHAUFFAGE</h3>
                <p class="text-gray-600 mb-2">La solution chauffage adaptée à votre logement</p>
                <p class="text-gray-600 mb-2">Dépannage, entretien et installation de vos équipements de chauffage et climatisation.</p>
                <p class="text-sm text-green-600 font-semibold mb-4">FRD Services qualifiée RGE Chauffage + et PG</p>
                <button onclick={() => openServiceModal('chauffage')} class="text-blue-600 hover:text-blue-800 font-semibold transition-colors">
                  En savoir +
                </button>
              </div>
            </div>
          </div>

          <!-- DÉGORGEMENT -->
          <div class="bg-white p-8 rounded-lg shadow-md hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll">
            <div class="flex items-start mb-6">
              <div class="w-16 h-16 bg-blue-400 rounded-lg mr-6 flex items-center justify-center flex-shrink-0">
                <div class="w-8 h-8 bg-white rounded-lg"></div>
              </div>
              <div class="flex-1">
                <h3 class="text-xl font-bold text-gray-800 mb-2">DÉGORGEMENT</h3>
                <p class="text-gray-600 mb-2">Débouchage canalisations 7J/7</p>
                <p class="text-gray-600 mb-4">Dépannage urgent débouchage canalisation (à haute pression), curage, travaux d'assainissement</p>
                <button onclick={() => openServiceModal('debouchage')} class="text-blue-600 hover:text-blue-800 font-semibold transition-colors">
                  En savoir +
                </button>
              </div>
            </div>
          </div>

          <!-- BALLON EAU CHAUDE -->
          <div class="bg-white p-8 rounded-lg shadow-md hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll">
            <div class="flex items-start mb-6">
              <div class="w-16 h-16 bg-red-500 rounded-lg mr-6 flex items-center justify-center flex-shrink-0">
                <div class="w-8 h-8 bg-white rounded-full"></div>
              </div>
              <div class="flex-1">
                <h3 class="text-xl font-bold text-gray-800 mb-2">BALLON EAU CHAUDE / CHAUFFE EAU</h3>
                <p class="text-gray-600 mb-2">Un grand choix de chauffe-eau et ballon d'eau chaude, marque & stock</p>
                <p class="text-gray-600 mb-2">Dépannage, entretien, installation ballon d'eau chaude, chauffe-eau électrique, chauffe-eau thermodynamique</p>
                <p class="text-sm text-green-600 font-semibold mb-4">FRD Services qualifiée RGE</p>
                <button onclick={() => openServiceModal('ballon')} class="text-blue-600 hover:text-blue-800 font-semibold transition-colors">
                  En savoir +
                </button>
              </div>
            </div>
          </div>

          <!-- CHAUDIÈRE GAZ -->
          <div class="bg-white p-8 rounded-lg shadow-md hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll">
            <div class="flex items-start mb-6">
              <div class="w-16 h-16 bg-yellow-500 rounded-lg mr-6 flex items-center justify-center flex-shrink-0">
                <div class="w-8 h-8 bg-white rounded"></div>
              </div>
              <div class="flex-1">
                <h3 class="text-xl font-bold text-gray-800 mb-2">CHAUDIÈRE GAZ</h3>
                <p class="text-gray-600 mb-2">Un grand choix de chauffe-eau et ballon d'eau chaude, marque & stock</p>
                <p class="text-gray-600 mb-2">Entretien, dépannage et remplacement de votre ancienne chaudière par une chaudière à gaz</p>
                <p class="text-sm text-green-600 font-semibold mb-4">FRD Services qualifiée RGE et PG</p>
                <button onclick={() => openServiceModal('chaudiere')} class="text-blue-600 hover:text-blue-800 font-semibold transition-colors">
                  En savoir +
                </button>
              </div>
            </div>
          </div>

          <!-- POMPE À CHALEUR -->
          <div class="bg-white p-8 rounded-lg shadow-md hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll">
            <div class="flex items-start mb-6">
              <div class="w-16 h-16 bg-green-500 rounded-lg mr-6 flex items-center justify-center flex-shrink-0">
                <div class="w-8 h-8 bg-white rounded-full"></div>
              </div>
              <div class="flex-1">
                <h3 class="text-xl font-bold text-gray-800 mb-2">POMPE À CHALEUR / CLIMATISATION</h3>
                <p class="text-gray-600 mb-2">La solution climatisation pour rafraîchir votre habitation</p>
                <p class="text-gray-600 mb-2">Entretien pompe à chaleur, installation pompe à chaleur air/air et air/eau</p>
                <p class="text-sm text-green-600 font-semibold mb-4">FRD Services qualifiée RGE et agréée QUALIPAC</p>
                <button onclick={() => openServiceModal('pompe')} class="text-blue-600 hover:text-blue-800 font-semibold transition-colors">
                  En savoir +
                </button>
              </div>
            </div>
          </div>

        </div>
      </div>
    </section>

    <!-- Service Details Modal -->
    {#if isModalOpen && selectedService}
<div class="fixed inset-0 bg-white/30 backdrop-blur-md flex items-center justify-center z-50 p-4 animate-fade-in" role="dialog" aria-modal="true">
        <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto transform transition-all duration-300 scale-100" role="dialog" aria-modal="true">
          <!-- Modal Header -->
          <div class="flex items-center justify-between p-6 border-b">
            <div>
              <h3 class="text-2xl font-bold text-gray-800">{selectedService.title}</h3>
              <p class="text-gray-600">{selectedService.subtitle}</p>
            </div>
            <button onclick={closeModal} class="text-gray-400 hover:text-gray-600 text-2xl font-bold transition-colors" aria-label="Close">
              ×
            </button>
          </div>
          
          <!-- Modal Content -->
          <div class="p-6">
            <p class="text-gray-700 mb-6 leading-relaxed">{selectedService.description}</p>
            
            <!-- Features List -->
            <div class="mb-6">
              <h4 class="text-lg font-semibold text-gray-800 mb-4">Nos prestations :</h4>
              <ul class="space-y-2">
                {#each selectedService.features as feature}
                  <li class="flex items-center text-gray-700">
                    <div class="w-2 h-2 bg-blue-500 rounded-full mr-3"></div>
                    {feature}
                  </li>
                {/each}
              </ul>
            </div>
            
            <!-- Certifications -->
            {#if selectedService.certifications.length > 0}
              <div class="mb-6">
                <h4 class="text-lg font-semibold text-gray-800 mb-4">Certifications :</h4>
                <div class="flex flex-wrap gap-2">
                  {#each selectedService.certifications as cert}
                    <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-semibold">
                      {cert}
                    </span>
                  {/each}
                </div>
              </div>
            {/if}
            
            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-4">
              <button onclick={() => navigate('/rdv')} class="flex-1 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-semibold transition-colors">
                Prendre rendez-vous
              </button>
              <button class="flex-1 bg-orange-500 hover:bg-orange-600 text-white px-6 py-3 rounded-lg font-semibold transition-colors">
                Appeler maintenant
              </button>
            </div>
          </div>
        </div>
      </div>
    {/if}
  </div>

{:else if $currentRoute === '/rdv'}
  <RdvFlow />
{:else}
  <!-- 404 Page -->
  <div class="min-h-screen bg-gray-100 flex items-center justify-center">
    <div class="text-center">
      <h1 class="text-4xl font-bold text-gray-800 mb-4">404 - Page non trouvée</h1>
      <button onclick={() => navigate('/')} class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
        Retour à l'accueil
      </button>
    </div>
  </div>
{/if}

<!-- Footer -->
<footer class="bg-gray-800 text-white py-12 ">
  <div class="container mx-auto px-4">
    <div class="grid md:grid-cols-4 gap-8">
      <div>
        <h4 class="text-lg font-bold mb-4">FRD Services</h4>
        <p class="text-gray-300">Spécialiste du dépannage urgent en plomberie et chauffage.</p>
      </div>
      <div>
        <h4 class="text-lg font-bold mb-4">Services</h4>
        <ul class="space-y-2 text-gray-300">
          <li>Plomberie</li>
          <li>Chauffage</li>
          <li>Climatisation</li>
          <li>Débouchage</li>
        </ul>
      </div>
      <div>
        <h4 class="text-lg font-bold mb-4">Zones d'intervention</h4>
        <ul class="space-y-2 text-gray-300">
          <li>Île-de-France</li>
          <li>Orléans (45)</li>
          <li>Tours (37)</li>
          <li>Caen (14)</li>
        </ul>
      </div>
      <div>
        <h4 class="text-lg font-bold mb-4">Contact</h4>
        <div class="space-y-2 text-gray-300">
          <p>Urgences 24h/24</p>
          <p>Devis gratuit</p>
        </div>
      </div>
    </div>
    <div class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-400">
      <p>&copy; 2024 FRD Services. Tous droits réservés.</p>
    </div>
  </div>
</footer>
