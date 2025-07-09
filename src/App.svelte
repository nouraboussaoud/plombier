<script lang="ts">
  import {
    User,
    ShoppingCart,
    Phone,
    Mail,
    MapPin,
    Calendar,
  } from "lucide-svelte";
  import { onMount } from "svelte";
  import { currentRoute, initRouter, navigate } from "./lib/router.js";

  import Header from "./components/Header.svelte";
  import RdvFlow from "./components/RdvFlow.svelte";
  import Footer from "./components/Footer.svelte";
  import Nous from "./components/Nous.svelte";
  import Contact from "./components/Contact.svelte";
  import Cgv from "./components/CGV.svelte";
  import Engagements from "./components/Engagements.svelte";
  import Politique from "./components/Politique.svelte";

  let selectedService = $state<(typeof services)[keyof typeof services] | null>(
    null,
  );
  let isModalOpen = $state(false);
  let scrollY = $state(0);
  let isOpen = $state(false);

  // Scroll animations
  let heroRef = $state();
  let servicesRef = $state();
  let contentRef = $state();

  onMount(() => {
    initRouter();

    // Scroll animations
    const observerOptions = {
      threshold: 0.1,
      rootMargin: "0px 0px -50px 0px",
    };

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("animate-fade-in-up");
        }
      });
    }, observerOptions);

    // Observe elements for animation
    document.querySelectorAll(".animate-on-scroll").forEach((el) => {
      observer.observe(el);
    });

    // Scroll listener for parallax effects
    const handleScroll = () => {
      scrollY = window.scrollY;
    };

    window.addEventListener("scroll", handleScroll);

    return () => {
      observer.disconnect();
      window.removeEventListener("scroll", handleScroll);
    };
  });

  const services = {
    plomberie: {
      title: "PLOMBERIE",
      subtitle: "Dépannage urgent, installation et rénovation",
      description:
        "Service de plomberie complet disponible 24h/24 et 7j/7. Nos plombiers interviennent rapidement pour tous vos problèmes de plomberie urgents.",
      features: [
        "Dépannage urgent 24h/24",
        "Réparation de fuites",
        "Installation sanitaire complète",
        "Rénovation de salle de bain",
        "Débouchage d'urgence",
      ],
      certifications: [],
    },
    debouchage: {
      title: "DÉBOUCHAGE CANALISATIONS",
      subtitle: "Débouchage canalisations 7J/7",
      description:
        "Service de débouchage professionnel disponible 7 jours sur 7. Nous utilisons des équipements haute pression pour un débouchage efficace.",
      features: [
        "Débouchage haute pression",
        "Curage de canalisations",
        "Inspection vidéo",
        "Travaux d'assainissement",
        "Intervention d'urgence 7j/7",
      ],
      certifications: [],
    },
    chauffage: {
      title: "CHAUFFAGE",
      subtitle: "La solution chauffage adaptée à votre logement",
      description:
        "Spécialistes en chauffage, nous proposons des solutions adaptées à chaque logement. Installation, entretien et dépannage de tous types d'équipements.",
      features: [
        "Installation de chaudières",
        "Entretien annuel obligatoire",
        "Dépannage d'urgence",
        "Radiateurs et plancher chauffant",
        "Conseil en économie d'énergie",
      ],
      certifications: ["RGE Chauffage +", "PG"],
    },
    ballon: {
      title: "BALLON/CHAUFFE-EAU",
      subtitle: "Un grand choix de chauffe-eau et ballon d'eau chaude",
      description:
        "Large gamme de chauffe-eau et ballons d'eau chaude en stock. Installation, dépannage et entretien par nos techniciens certifiés.",
      features: [
        "Chauffe-eau électrique",
        "Chauffe-eau thermodynamique",
        "Ballon d'eau chaude",
        "Dépannage et entretien",
        "Stock permanent des grandes marques",
      ],
      certifications: ["RGE"],
    },
    chaudiere: {
      title: "CHAUDIÈRE GAZ",
      subtitle: "Entretien, dépannage et remplacement",
      description:
        "Spécialistes des chaudières gaz, nous assurons l'entretien, le dépannage et le remplacement de votre ancienne chaudière par une chaudière gaz moderne.",
      features: [
        "Entretien annuel chaudière gaz",
        "Dépannage d'urgence",
        "Remplacement chaudière",
        "Chaudières gaz condensation",
        "Conseil en économie d'énergie",
      ],
      certifications: ["RGE", "PG"],
    },
    pompe: {
      title: "POMPE À CHALEUR/CLIMATISATION",
      subtitle: "La solution climatisation pour rafraîchir votre habitation",
      description:
        "Installation et entretien de pompes à chaleur air/air et air/eu. Solutions de climatisation pour un confort optimal toute l'année.",
      features: [
        "Pompe à chaleur air/air",
        "Pompe à chaleur air/eau",
        "Climatisation réversible",
        "Entretien et maintenance",
        "Conseil en efficacité énergétique",
      ],
      certifications: ["RGE", "QUALIPAC"],
    },
  };

  const navItems = [
    { label: "PLOMBERIE", key: "plomberie" },
    { label: "DÉBOUCHAGE CANALISATIONS", key: "debouchage" },
    { label: "CHAUFFAGE", key: "chauffage" },
    { label: "BALLON/CHAUFFE-EAU", key: "ballon" },
    { label: "RDV INTERVENTION & DEVIS", key: "rdv" },
    { label: "CHAUDIÈRE GAZ", key: "chaudiere" },
    { label: "POMPE À CHALEUR/CLIMATISATION", key: "pompe" },
    { label: "VOS PROJETS", key: "projets" },
  ];

  function handleNavClick(key: string) {
    if (key === "rdv") {
      navigate("/rdv");
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

  function toggleMenu() {
    isOpen = !isOpen;
  }
</script>

<svelte:window bind:scrollY />

<div class="min-h-screen bg-white">
  <!-- Header -->
  <Header {navItems} {handleNavClick} {isOpen} toggleMenu={toggleMenu} />

  {#if $currentRoute === "/"}
    <!-- Hero Section -->
    <section
      bind:this={heroRef}
      class="relative min-h-[600px] overflow-hidden max-sm:min-h-[400px]"
    >
      <!-- Kitchen background image with parallax -->
      <div class="absolute inset-0 parallax-bg" style="--scroll: {scrollY}">
        <img
          src="/design.png"
          alt="Modern kitchen with boiler installation"
          class="w-full h-full object-cover max-sm:object-fill animate-fade-in"
        />
      </div>

      <!-- Action buttons -->
      <div
        class="absolute left-8 top-1/2 transform -translate-y-1/2 space-y-4 max-sm:left-1/6 max-sm:-translate-x-1/2 max-sm:top-1/3 max-sm:space-y-2"
      >
        <button
          class="w-18 h-18 text-orange-600 hover:text-orange-700 transition-all duration-300 flex items-center justify-center hover:scale-110 max-sm:w-12 max-sm:h-12"
        >
          <Phone size={36} class="max-sm:w-8 max-sm:h-8" />
        </button>
        <button
          class="w-18 h-18 text-orange-600 hover:text-orange-700 transition-all duration-300 flex items-center justify-center hover:scale-110 max-sm:w-12 max-sm:h-12"
        >
          <Mail size={36} class="max-sm:w-8 max-sm:h-8" />
        </button>
        <button
          on:click={() => navigate("/rdv")}
          class="w-18 h-18 text-orange-600 hover:text-orange-700 transition-all duration-300 flex items-center justify-center hover:scale-110 max-sm:w-12 max-sm:h-12"
        >
          <Calendar size={36} class="max-sm:w-8 max-sm:h-8" />
        </button>
      </div>
      <div
        class="absolute left-8 top-3/4 transform translate-x-1/2 flex space-x-4 max-sm:left-1/2 max-sm:-translate-x-1/2 max-sm:top-[70%] max-sm:flex-col max-sm:space-x-0 max-sm:space-y-2 max-sm:w-3/4"
      >
        <button
          class="p-3 bg-orange-600 hover:bg-orange-700 text-white rounded-4xl shadow-lg transition-all duration-300 flex items-center justify-center hover:scale-110 hover:shadow-xl max-sm:text-sm max-sm:p-2"
        >
          RDV Intervention & Devis
        </button>
        <button
          class="p-3 bg-orange-600 hover:bg-orange-700 text-white rounded-4xl shadow-lg transition-all duration-300 flex items-center justify-center hover:scale-110 hover:shadow-xl max-sm:text-sm max-sm:p-2"
        >
          FRD Services
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
            <strong>FRD Services,</strong> Spécialiste des interventions d'urgence
            en plomberie et chauffage FRD Services est une entreprise spécialisée
            dans les interventions d’urgence. Nous intervenons rapidement et efficacement
            dans tout Paris pour des travaux de plomberie et de chauffage. Nous couvrons
            également les travaux d’entretien, d’installation de vos appareils sanitaires,
            équipements de chauffage et de climatisation.
          </p>
        </div>
      </div>

      <div
        class="flex flex-col md:flex-row items-center justify-center gap-6 md:gap-12 px-20 py-8 max-sm:px-4"
      >
        <!-- Video Section -->
        <div class="w-full md:w-1/2 aspect-video">
          <video
            src="/video.mp4"
            autoplay
            playsinline
            controls
            class="w-auto h-auto rounded-lg shadow-md"
          ></video>
        </div>

        <!-- Text Section -->
        <div class="w-full md:w-1/2 text-center md:text-left space-y-4">
          <p class="text-xl text-gray-600 leading-relaxed">
            Fuite d’eau, débouchage de WC, canalisation bouchée, intervention
            sur ballon d’eau chaude, chauffe-eau électrique ou thermodynamique,
            désembouage de circuit de chauffage, remplacement de radiateurs à
            eau, entretien de chaudière gaz, installation de pompe à chaleur
            air/air ou air/eau, etc. Faites appel à FRD Services, les
            spécialistes de la PLOMBERIE, du CHAUFFAGE et de la CLIMATISATION,
            c’est notre métier !
          </p>
        </div>
      </div>
    </section>

    <!-- Services Grid -->
    <section bind:this={servicesRef} class="pt-16 bg-gray-50 animate-on-scroll">
      <div class="container mx-auto px-4">
        <h2 class="text-3xl font-bold text-center text-gray-800 mb-12">
          Nos Services
        </h2>

        <!-- Main Services Grid -->
        <div class="grid lg:grid-cols-3 md:grid-cols-2 grid-cols-1 gap-8 mb-8">
          <!-- PLOMBERIE -->
          <div
            class="relative bg-cover bg-center bg-no-repeat rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll cursor-pointer min-h-[300px]"
            style="background-image: url('service1.jpeg');"
            on:click={() => openServiceModal("plomberie")}
          >
            <div
              class="absolute inset-0 bg-gradient-to-br from-black/70 to-black/50 rounded-lg"
            ></div>
            <div class="relative z-10 p-6 h-full flex flex-col justify-between">
              <div>
                <h3 class="text-xl font-bold text-white mb-2">PLOMBERIE</h3>
                <p class="text-gray-200 text-sm mb-2">
                  Installation WC suspendu et WC lavant
                </p>
              </div>
              <div>
                <p class="text-gray-300 text-sm mb-4">
                  Dépannage urgent, installation et rénovation de plomberie
                </p>
                <button
                  class="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded text-sm font-semibold transition-colors"
                >
                  EN SAVOIR +
                </button>
              </div>
            </div>
          </div>

          <!-- CHAUFFAGE -->
          <div
            class="relative bg-cover bg-center bg-no-repeat rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll cursor-pointer min-h-[300px]"
            style="background-image: url('service2.jpeg');"
            on:click={() => openServiceModal("chauffage")}
          >
            <div
              class="absolute inset-0 bg-gradient-to-br from-black/70 to-black/50 rounded-lg"
            ></div>
            <div class="relative z-10 p-6 h-full flex flex-col justify-between">
              <div>
                <h3 class="text-xl font-bold text-white mb-2">CHAUFFAGE</h3>
                <p class="text-gray-200 text-sm mb-2">
                  La solution chauffage adaptée à votre logement
                </p>
              </div>
              <div>
                <p class="text-gray-300 text-sm mb-2">
                  Dépannage, entretien et installation de vos équipements de
                  chauffage et climatisation.
                </p>
                <p class="text-orange-400 text-xs font-semibold mb-4">
                  FRD Services qualifiée RGE Chauffage + et PG
                </p>
                <button
                  class="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded text-sm font-semibold transition-colors"
                >
                  EN SAVOIR +
                </button>
              </div>
            </div>
          </div>

          <!-- DÉGORGEMENT -->
          <div
            class="relative bg-cover bg-center bg-no-repeat rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll cursor-pointer min-h-[300px]"
            style="background-image: url('service6.jpeg');"
            on:click={() => openServiceModal("debouchage")}
          >
            <div
              class="absolute inset-0 bg-gradient-to-br from-black/70 to-black/50 rounded-lg"
            ></div>
            <div class="relative z-10 p-6 h-full flex flex-col justify-between">
              <div>
                <h3 class="text-xl font-bold text-white mb-2">DÉGORGEMENT</h3>
                <p class="text-gray-200 text-sm mb-2">
                  Débouchage canalisations 7J/7
                </p>
              </div>
              <div>
                <p class="text-gray-300 text-sm mb-4">
                  Dépannage urgent débouchage canalisation (à haute pression),
                  curage, travaux d'assainissement
                </p>
                <button
                  class="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded text-sm font-semibold transition-colors"
                >
                  EN SAVOIR +
                </button>
              </div>
            </div>
          </div>

          <!-- BALLON EAU CHAUDE -->
          <div
            class="relative bg-cover bg-center bg-no-repeat rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll cursor-pointer min-h-[300px]"
            style="background-image: url('service4.jpeg');"
            on:click={() => openServiceModal("ballon")}
          >
            <div
              class="absolute inset-0 bg-gradient-to-br from-black/70 to-black/50 rounded-lg"
            ></div>
            <div class="relative z-10 p-6 h-full flex flex-col justify-between">
              <div>
                <h3 class="text-xl font-bold text-white mb-2">
                  BALLON EAU CHAUDE / CHAUFFE EAU
                </h3>
                <p class="text-gray-200 text-sm mb-2">
                  Un grand choix de chauffe-eau et ballon d'eau chaude, marque &
                  stock
                </p>
              </div>
              <div>
                <p class="text-gray-300 text-sm mb-2">
                  Dépannage, entretien, installation ballon d'eau chaude,
                  chauffe-eau électrique, chauffe-eau thermodynamique
                </p>
                <p class="text-orange-400 text-xs font-semibold mb-4">
                  FRD Services qualifiée RGE
                </p>
                <button
                  class="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded text-sm font-semibold transition-colors"
                >
                  EN SAVOIR +
                </button>
              </div>
            </div>
          </div>

          <!-- CHAUDIÈRE GAZ -->
          <div
            class="relative bg-cover bg-center bg-no-repeat rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll cursor-pointer min-h-[300px]"
            style="background-image: url('service5.jpeg');"
            on:click={() => openServiceModal("chaudiere")}
          >
            <div
              class="absolute inset-0 bg-gradient-to-br from-black/70 to-black/50 rounded-lg"
            ></div>
            <div class="relative z-10 p-6 h-full flex flex-col justify-between">
              <div>
                <h3 class="text-xl font-bold text-white mb-2">CHAUDIÈRE GAZ</h3>
                <p class="text-gray-200 text-sm mb-2">
                  Un grand choix de chauffe-eau et ballon d'eau chaude, marque &
                  stock
                </p>
              </div>
              <div>
                <p class="text-gray-300 text-sm mb-2">
                  Entretien, dépannage et remplacement de votre ancienne
                  chaudière par une chaudière à gaz
                </p>
                <p class="text-orange-400 text-xs font-semibold mb-4">
                  FRD Services qualifiée RGE et PG
                </p>
                <button
                  class="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded text-sm font-semibold transition-colors"
                >
                  EN SAVOIR +
                </button>
              </div>
            </div>
          </div>

          <!-- POMPE À CHALEUR -->
          <div
            class="relative bg-cover bg-center bg-no-repeat rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 animate-on-scroll cursor-pointer min-h-[300px]"
            style="background-image: url('service3.jpeg');"
            on:click={() => openServiceModal("pompe")}
          >
            <div
              class="absolute inset-0 bg-gradient-to-br from-black/70 to-black/50 rounded-lg"
            ></div>
            <div class="relative z-10 p-6 h-full flex flex-col justify-between">
              <div>
                <h3 class="text-xl font-bold text-white mb-2">
                  POMPE À CHALEUR / CLIMATISATION
                </h3>
                <p class="text-gray-200 text-sm mb-2">
                  La solution climatisation pour rafraîchir votre habitation
                </p>
              </div>
              <div>
                <p class="text-gray-300 text-sm mb-2">
                  Entretien pompe à chaleur, installation pompe à chaleur
                  air/air et air/eau
                </p>
                <p class="text-orange-400 text-xs font-semibold mb-4">
                  FRD Services qualifiée RGE et agréée QUALIPAC
                </p>
                <button
                  class="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded text-sm font-semibold transition-colors"
                >
                  EN SAVOIR +
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="bg-gradient-to-br from-gray-50 to-gray-100 py-16 mt-16">
      <div class="container mx-auto px-20 max-sm:px-4">
        <div
          class="grid max-sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-4 gap-8"
        >
          <!-- Feature 1 -->
          <div class="group">
            <div
              class="relative overflow-hidden rounded-2xl shadow-lg transition-transform duration-300 group-hover:scale-105"
            >
              <div class="aspect-square">
                <img
                  src="a.jpeg"
                  alt="Estimation tarifaire avant le RDV"
                  class="w-full h-full object-contain transition-transform duration-300 group-hover:scale-105"
                />
                <div
                  class="absolute inset-0 bg-gradient-to-t to-transparent"
                ></div>
              </div>
            </div>
          </div>

          <!-- Feature 2 -->
          <div class="group">
            <div
              class="relative overflow-hidden rounded-2xl shadow-lg transition-transform duration-300 group-hover:scale-105"
            >
              <div class="aspect-square">
                <img
                  src="b.jpeg"
                  alt="Dépannage 7J/7 24H/24"
                  class="w-full h-full object-contain transition-transform duration-300 group-hover:scale-105"
                />
                <div class="absolute inset-0"></div>
              </div>
            </div>
          </div>

          <!-- Feature 3 -->
          <div class="group">
            <div
              class="relative overflow-hidden rounded-2xl shadow-lg transition-transform duration-300 group-hover:scale-105"
            >
              <div class="aspect-square">
                <img
                  src="c.jpeg"
                  alt="Intervention sur toute l'Île-de-France"
                  class="w-full h-full object-contain transition-transform duration-300 group-hover:scale-105"
                />
                <div class="absolute inset-0"></div>
              </div>
            </div>
          </div>

          <!-- Feature 4 -->
          <div class="group">
            <div
              class="relative overflow-hidden rounded-2xl shadow-lg transition-transform duration-300 group-hover:scale-105"
            >
              <div class="aspect-square">
                <img
                  src="d.jpeg"
                  alt="Une équipe qualifiée et certifiée"
                  class="w-full h-full object-contain transition-transform duration-300 group-hover:scale-105"
                />
                <div class="absolute inset-0"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Service Details Modal -->
    {#if isModalOpen && selectedService}
      <div
        class="fixed inset-0 bg-white/30 backdrop-blur-md flex items-center justify-center p-4 animate-fade-in"
        role="dialog"
        aria-modal="true"
      >
        <div
          class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto transform transition-all duration-300 scale-100"
          role="dialog"
          aria-modal="true"
        >
          <!-- Modal Header -->
          <div class="flex items-center justify-between p-6 border-b">
            <div>
              <h3 class="text-2xl font-bold text-gray-800">
                {selectedService.title}
              </h3>
              <p class="text-gray-600">{selectedService.subtitle}</p>
            </div>
            <button
              on:click={closeModal}
              class="text-gray-400 hover:text-gray-600 text-2xl font-bold transition-colors"
              aria-label="Close"
            >
              ×
            </button>
          </div>

          <!-- Modal Content -->
          <div class="p-6">
            <p class="text-gray-700 mb-6 leading-relaxed">
              {selectedService.description}
            </p>

            <!-- Features List -->
            <div class="mb-6">
              <h4 class="text-lg font-semibold text-gray-800 mb-4">
                Nos prestations :
              </h4>
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
                <h4 class="text-lg font-semibold text-gray-800 mb-4">
                  Certifications :
                </h4>
                <div class="flex flex-wrap gap-2">
                  {#each selectedService.certifications as cert}
                    <span
                      class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-semibold"
                    >
                      {cert}
                    </span>
                  {/each}
                </div>
              </div>
            {/if}

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-4">
              <button
                on:click={() => navigate("/rdv")}
                class="flex-1 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-semibold transition-colors"
              >
                Prendre rendez-vous
              </button>
              <button
                class="flex-1 bg-orange-500 hover:bg-orange-600 text-white px-6 py-3 rounded-lg font-semibold transition-colors"
              >
                Appeler maintenant
              </button>
            </div>
          </div>
        </div>
      </div>
    {/if}
  {:else if $currentRoute === "/rdv"}
    <RdvFlow />
  {:else if $currentRoute === "/#/qui-sommes-nous"}
    <Nous />
  {:else if $currentRoute === "/#/nous-contacter"}
    <Contact />
  {:else if $currentRoute === "/#/cgv"}
    <Cgv />
  {:else if $currentRoute === "/#/nos-engagements"}
    <Engagements />
  {:else if $currentRoute === "/#/politique-confidentialite"}
    <Politique />
  {:else}
    <!-- 404 Page -->
    <div class="min-h-screen bg-gray-100 flex items-center justify-center">
      <div class="text-center">
        <h1 class="text-4xl font-bold text-gray-800 mb-4">
          404 - Page non trouvée
        </h1>
        <button
          on:click={() => navigate("/")}
          class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
        >
          Retour à l'accueil
        </button>
      </div>
    </div>
  {/if}

  <!-- Footer -->
  <Footer />
</div>

<style>
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