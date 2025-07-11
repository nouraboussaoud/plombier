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
  import Mentions from "./components/Mentions.svelte";

  let selectedService = $state<(typeof services)[keyof typeof services] | null>(
    null,
  );
  let isModalOpen = $state(false);
  let scrollY = $state(0);
  let isOpen = $state(false);
  let isVisible = $state(false);
  let contentRef = $state();
  let heroRef = $state();
  let servicesRef = $state();
  let galleryContainer = $state();
  let galleryContainerGaz = $state();
  let galleryContainerSalle = $state();
  let galleryContainerAvant = $state();
  let galleryContainerWc = $state();
  let galleryContainerBb = $state();

  onMount(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          isVisible = true;
          observer.unobserve(entry.target);
        }
      },
      { threshold: 0.1 },
    );

    if (contentRef && contentRef instanceof Element) {
      observer.observe(contentRef);
    }

    return () => observer.disconnect();
  });

  // Scroll animations

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
    { label: "NOS PROJETS", key: "projets" },
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

  function scrollGallery(amount: number) {
    if (galleryContainer) {
      const container = galleryContainer as HTMLElement;
      container.scrollLeft += amount;
    }
  }

  function scrollGalleryGaz(amount: number) {
    if (galleryContainerGaz) {
      const container = galleryContainerGaz as HTMLElement;
      container.scrollLeft += amount;
    }
  }

  function scrollGallerySalle(amount: number) {
    if (galleryContainerSalle) {
      const container = galleryContainerSalle as HTMLElement;
      container.scrollLeft += amount;
    }
  }

  function scrollGalleryAvant(amount: number) {
    if (galleryContainerAvant) {
      const container = galleryContainerAvant as HTMLElement;
      container.scrollLeft += amount;
    }
  }

  function scrollGalleryWc(amount: number) {
    if (galleryContainerWc) {
      const container = galleryContainerWc as HTMLElement;
      container.scrollLeft += amount;
    }
  }

  function scrollGalleryBb(amount: number) {
    if (galleryContainerBb) {
      const container = galleryContainerBb as HTMLElement;
      container.scrollLeft += amount;
    }
  }
</script>

<svelte:window bind:scrollY />

<div class="min-h-screen bg-white">
  <!-- Header -->
  <Header {navItems} {handleNavClick} {isOpen} {toggleMenu} />

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
          alt="plombier"
          class="w-full h-full object-cover max-sm:hidden animate-fade-in"
        />
        <img
          src="/design-mobile.png"
          alt="plombier"
          class="w-full h-full hidden max-sm:block animate-fade-in"
        />
      </div>

      <!-- Action buttons -->
      <div
        class="absolute left-8 top-1/2 transform -translate-y-1/2 space-y-4 max-sm:left-1/6 max-sm:-translate-x-1/2 max-sm:top-1/3 max-sm:space-y-2"
      >
        <a
          href="tel:0755533226"
          class="w-18 h-18 text-orange-600 hover:text-orange-700 transition-all duration-300 flex items-center justify-center hover:scale-110 max-sm:w-12 max-sm:h-12"
        >
          <Phone size={36} class="max-sm:w-8 max-sm:h-8" />
        </a>
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
        on:click={() => navigate("/rdv")}
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
    <section bind:this={contentRef} class="relative py-20 overflow-hidden">
      <!-- Background Elements -->
      <div
        class="absolute inset-0 bg-gradient-to-br from-blue-50 via-white to-cyan-50"
      ></div>
      <div
        class="absolute top-0 left-0 w-72 h-72 bg-blue-100 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-pulse"
      ></div>
      <div
        class="absolute bottom-0 right-0 w-72 h-72 bg-cyan-100 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-pulse"
        style="animation-delay: 2s;"
      ></div>

      <!-- Content Container -->
      <div class="relative container mx-auto px-4">
        <!-- Header Section -->
        <div class="max-w-5xl mx-auto text-center mb-16">
          <div
            class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-full mb-8 transform transition-all duration-700 {isVisible
              ? 'translate-y-0 opacity-100'
              : 'translate-y-8 opacity-0'}"
          >
            <svg
              class="w-8 h-8 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 8.172V5L8 4z"
              ></path>
            </svg>
          </div>

          <h2
            class="text-4xl md:text-5xl lg:text-6xl font-bold bg-gradient-to-r from-gray-800 via-blue-600 to-cyan-600 bg-clip-text text-transparent mb-6 transform transition-all duration-700 leading-tight {isVisible
              ? 'translate-y-0 opacity-100'
              : 'translate-y-8 opacity-0'}"
            style="transition-delay: 0.1s;"
          >
            FRD Services
          </h2>

          <div
            class="w-24 h-1 bg-gradient-to-r from-blue-500 to-cyan-500 mx-auto mb-6 transform transition-all duration-700 {isVisible
              ? 'scale-x-100 opacity-100'
              : 'scale-x-0 opacity-0'}"
            style="transition-delay: 0.2s;"
          ></div>

          <p
            class="text-xl md:text-2xl text-gray-600 font-medium mb-4 transform transition-all duration-700 {isVisible
              ? 'translate-y-0 opacity-100'
              : 'translate-y-8 opacity-0'}"
            style="transition-delay: 0.3s;"
          >
            Spécialiste du dépannage urgent
          </p>

          <p
            class="text-lg text-gray-600 leading-relaxed max-w-3xl mx-auto transform transition-all duration-700 {isVisible
              ? 'translate-y-0 opacity-100'
              : 'translate-y-8 opacity-0'}"
            style="transition-delay: 0.4s;"
          >
            <span class="font-semibold text-blue-600">FRD Services</span>,
            Spécialiste des interventions d'urgence en plomberie et chauffage
            FRD Services est une entreprise spécialisée dans les interventions
            d’urgence. Nous intervenons rapidement et efficacement dans tout
            Paris pour des travaux de plomberie et de chauffage. Nous couvrons
            également les travaux d’entretien, d’installation de vos appareils
            sanitaires, équipements de chauffage et de climatisation.
          </p>
        </div>

        <!-- Main Content Section -->
        <div
          class="flex flex-col lg:flex-row items-center justify-center gap-8 lg:gap-16 max-w-6xl mx-auto"
        >
          <!-- Video Section -->
          <div
            class="w-full lg:w-1/2 transform transition-all duration-700 {isVisible
              ? 'translate-x-0 opacity-100'
              : '-translate-x-8 opacity-0'}"
            style="transition-delay: 0.5s;"
          >
            <div class="relative group">
              <div
                class="absolute -inset-4 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-2xl blur opacity-25 group-hover:opacity-40 transition duration-300"
              ></div>
              <div class="relative">
                <video
                  src="/video.mp4"
                  autoplay
                  playsinline
                  controls
                  class="w-full h-auto rounded-xl shadow-2xl border-4 border-white/50 backdrop-blur-sm transition-transform duration-300 hover:scale-105"
                ></video>
                <div
                  class="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent rounded-xl pointer-events-none"
                ></div>
              </div>
            </div>
          </div>

          <!-- Text Section -->
          <div
            class="w-full lg:w-1/2 text-center lg:text-left space-y-6 transform transition-all duration-700 {isVisible
              ? 'translate-x-0 opacity-100'
              : 'translate-x-8 opacity-0'}"
            style="transition-delay: 0.6s;"
          >
            <div
              class="bg-white/70 backdrop-blur-sm rounded-2xl p-8 shadow-xl border border-white/20 hover:shadow-2xl transition-shadow duration-300"
            >
              <div class="space-y-4">
                <div
                  class="flex items-start space-x-3 p-3 rounded-lg hover:bg-blue-50/50 transition-colors duration-200"
                >
                  Fuite d’eau, débouchage de WC, canalisation bouchée,
                  intervention sur ballon d’eau chaude, chauffe-eau électrique
                  ou thermodynamique, désembouage de circuit de chauffage,
                  remplacement de radiateurs à eau, entretien de chaudière gaz,
                  installation de pompe à chaleur air/air ou air/eau, etc.
                </div>
              </div>

              <div
                class="mt-8 p-6 bg-gradient-to-r from-blue-50 to-cyan-50 rounded-xl border-l-4 border-blue-500 hover:shadow-lg transition-shadow duration-300"
              >
                <p
                  class="text-lg font-semibold text-gray-800 text-center lg:text-left"
                >
                  Faites appel à <span class="text-blue-600">FRD Services</span
                  >, les spécialistes de la
                  <span class="font-bold text-blue-600">PLOMBERIE</span>, du
                  <span class="font-bold text-blue-600">CHAUFFAGE</span> et de
                  la
                  <span class="font-bold text-blue-600">CLIMATISATION</span>
                </p>
                <p
                  class="text-blue-600 font-medium mt-2 text-center lg:text-left"
                >
                  C'est notre métier !
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Call to Action -->
        <div
          class="mt-16 text-center transform transition-all duration-700 {isVisible
            ? 'translate-y-0 opacity-100'
            : 'translate-y-8 opacity-0'}"
          style="transition-delay: 0.7s;"
        >
          <div
            class="inline-flex items-center justify-center space-x-6 bg-gradient-to-r from-blue-500 to-cyan-500 text-white px-8 py-4 rounded-full shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105"
          >
            <svg
              class="w-6 h-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"
              ></path>
            </svg>
            <span class="text-lg font-semibold"
              >Contactez-nous pour une intervention rapide</span
            >
          </div>
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

    <!-- First Gallery Section - Remplacement réseaux -->
    <section class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <!-- Title with centered orange underline -->
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">
            Remplacement réseaux eaux usées, eaux vannes et eaux pluviales en fonte
          </h2>
          <div class="w-24 h-1 bg-orange-500 mx-auto"></div>
        </div>
        
        <!-- Gallery Container - Clean Design -->
        <div class="relative max-w-6xl mx-auto">
          <!-- Navigation Arrows -->
          <button 
            class="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGallery(-300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <!-- Gallery Images - Clean Design -->
          <div bind:this={galleryContainer} class="flex overflow-x-auto gap-6 pb-4 scrollbar-hide px-12" id="gallery-container">
            <!-- Images 1-25 -->
            {#each Array(25) as _, i}
              <div class="flex-shrink-0 w-72 h-56 rounded-lg overflow-hidden shadow-md">
                <img
                  src={`/gallery/${i+1}.jpg`}
                  alt={`Remplacement réseau ${i+1}`}
                  class="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                />
              </div>
            {/each}
          </div>
          
          <!-- Right Arrow -->
          <button 
            class="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGallery(300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      </div>
      
      <!-- Divider line -->
      <div class="max-w-6xl mx-auto mt-16 border-t border-gray-200"></div>
    </section>

    <!-- Second Gallery Section - Distribution réseaux -->
    <section class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <!-- Title with centered orange underline -->
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">
            Distribution réseaux eau, gaz, air
          </h2>
          <div class="w-24 h-1 bg-orange-500 mx-auto"></div>
        </div>
        
        <!-- Gallery Container - Clean Design -->
        <div class="relative max-w-6xl mx-auto">
          <!-- Navigation Arrows -->
          <button 
            class="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGalleryGaz(-300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <!-- Gallery Images - Clean Design -->
          <div bind:this={galleryContainerGaz} class="flex overflow-x-auto gap-6 pb-4 scrollbar-hide px-12" id="gallery-container-gaz">
            <!-- Images 1-17 from gaz folder -->
            {#each Array(17) as _, i}
              <div class="flex-shrink-0 w-72 h-56 rounded-lg overflow-hidden shadow-md">
                <img
                  src={`/gaz/${i+1}.jpg`}
                  alt={`Distribution réseau ${i+1}`}
                  class="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                />
              </div>
            {/each}
          </div>
          
          <!-- Right Arrow -->
          <button 
            class="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGalleryGaz(300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      </div>
    </section>

    <!-- Third Gallery Section - Rénovation de salle de bain -->
    <section class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <!-- Title with centered orange underline -->
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">
            Rénovation de salle de bain
          </h2>
          <div class="w-24 h-1 bg-orange-500 mx-auto"></div>
        </div>
        
        <!-- Gallery Container - Clean Design -->
        <div class="relative max-w-6xl mx-auto">
          <!-- Navigation Arrows -->
          <button 
            class="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGallerySalle(-300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <!-- Gallery Images - Clean Design -->
          <div bind:this={galleryContainerSalle} class="flex overflow-x-auto gap-6 pb-4 scrollbar-hide px-12" id="gallery-container-salle">
            <!-- Images 1-15 from salle folder -->
            {#each Array(15) as _, i}
              <div class="flex-shrink-0 w-72 h-56 rounded-lg overflow-hidden shadow-md">
                <img
                  src={`/salle/${i+1}.jpg`}
                  alt={`Rénovation salle de bain ${i+1}`}
                  class="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                />
              </div>
            {/each}
          </div>
          
          <!-- Right Arrow -->
          <button 
            class="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGallerySalle(300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      </div>
    </section>

    <!-- Fourth Gallery Section - Rénovation de salle de bain avant/après -->
    <section class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <!-- Title with centered orange underline -->
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">
            Rénovation de salle de bain avant/après
          </h2>
          <div class="w-24 h-1 bg-orange-500 mx-auto"></div>
        </div>
        
        <!-- Gallery Container - Clean Design -->
        <div class="relative max-w-6xl mx-auto">
          <!-- Navigation Arrows -->
          <button 
            class="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGalleryAvant(-300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <!-- Gallery Images - Clean Design -->
          <div bind:this={galleryContainerAvant} class="flex overflow-x-auto gap-6 pb-4 scrollbar-hide px-12" id="gallery-container-avant">
            <!-- Images 1-16 from avant folder -->
            {#each Array(16) as _, i}
              <div class="flex-shrink-0 w-72 h-56 rounded-lg overflow-hidden shadow-md">
                <img
                  src={`/avant/${i+1}.jpg`}
                  alt={`Rénovation salle de bain avant/après ${i+1}`}
                  class="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                />
              </div>
            {/each}
          </div>
          
          <!-- Right Arrow -->
          <button 
            class="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGalleryAvant(300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      </div>
    </section>

    <!-- Fifth Gallery Section - Rénovation de salle de bain et WC -->
    <section class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <!-- Title with centered orange underline -->
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">
            Rénovation de salle de bain et WC
          </h2>
          <div class="w-24 h-1 bg-orange-500 mx-auto"></div>
        </div>
        
        <!-- Gallery Container - Clean Design -->
        <div class="relative max-w-6xl mx-auto">
          <!-- Navigation Arrows -->
          <button 
            class="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGalleryWc(-300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <!-- Gallery Images - Clean Design -->
          <div bind:this={galleryContainerWc} class="flex overflow-x-auto gap-6 pb-4 scrollbar-hide px-12" id="gallery-container-wc">
            <!-- Images 1-5 from wc folder -->
            {#each Array(5) as _, i}
              <div class="flex-shrink-0 w-72 h-56 rounded-lg overflow-hidden shadow-md">
                <img
                  src={`/wc/${i+1}.jpg`}
                  alt={`Rénovation salle de bain et WC ${i+1}`}
                  class="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                />
              </div>
            {/each}
          </div>
          
          <!-- Right Arrow -->
          <button 
            class="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGalleryWc(300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      </div>
    </section>

    <!-- Sixth Gallery Section - Remplacement de bouches de lavage -->
    <section class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <!-- Title with centered orange underline -->
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">
            Remplacement de bouches de lavage sur les places de marché de la ville d'Issy-les-Moulineaux
          </h2>
          <div class="w-24 h-1 bg-orange-500 mx-auto"></div>
        </div>
        
        <!-- Gallery Container - Clean Design -->
        <div class="relative max-w-6xl mx-auto">
          <!-- Navigation Arrows -->
          <button 
            class="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGalleryBb(-300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <!-- Gallery Images - Clean Design -->
          <div bind:this={galleryContainerBb} class="flex overflow-x-auto gap-6 pb-4 scrollbar-hide px-12" id="gallery-container-bb">
            <!-- Images 1-12 from bb folder -->
            {#each Array(12) as _, i}
              <div class="flex-shrink-0 w-72 h-56 rounded-lg overflow-hidden shadow-md">
                <img
                  src={`/bb/${i+1}.jpg`}
                  alt={`Remplacement de bouches de lavage ${i+1}`}
                  class="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                />
              </div>
            {/each}
          </div>
          
          <!-- Right Arrow -->
          <button 
            class="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white/90 rounded-full p-3 shadow-md hover:bg-white transition-colors"
            on:click={() => scrollGalleryBb(300)}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-700" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
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
        class="fixed inset-0 bg-white/30 backdrop-blur-md flex items-center justify-center p-4 animate-fade-in z-40"
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
              <a
                href="tel:0755533226"
                class="flex-1 bg-orange-500 hover:bg-orange-600 text-white px-6 py-3 rounded-lg font-semibold transition-colors text-center"
              >
                Appeler maintenant
              </a>
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
  {:else if $currentRoute === "/#/mentions-legales"}
    <Mentions />
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
  .scrollbar-hide {
    -ms-overflow-style: none;  /* IE and Edge */
    scrollbar-width: none;  /* Firefox */
  }
  
  .scrollbar-hide::-webkit-scrollbar {
    display: none;  /* Chrome, Safari and Opera */
  }
</style>
