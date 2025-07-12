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
    Thermometer,
    Wind,
    Hammer,
  } from "lucide-svelte";
  import { navigate } from "../lib/router.js";
  import { supabase } from "../lib/supabase.js";

  let currentStep = $state(1);
  let selectedServiceType = $state("");
  let selectedCategory = $state("");
  let selectedSubCategory = $state("");
  let selectedProblem = $state("");

  // Contact form data
  let contactData = $state({
    firstName: "",
    lastName: "",
    email: "",
    phone: "",
    address: "",
    preferredDate: "",
    preferredTime: "",
    message: "",
  });

  let isSubmitting = $state(false);
  let isSubmitted = $state(false);
  let submitMessage = $state("");

  // Get today's date in YYYY-MM-DD format for date input
  const today = new Date().toISOString().split("T")[0];

  // Step 1: Main service types
  const serviceTypes = [
    {
      id: "depannage",
      name: "DÉPANNAGE",
      description: "Intervention d'urgence pour réparer",
      icon: Wrench,
      color: "bg-red-500",
      available: true,
    },
    {
      id: "installation",
      name: "INSTALLATION",
      description: "Pose et installation d'équipements",
      icon: Settings,
      color: "bg-blue-500",
      available: true,
    },
    {
      id: "entretien",
      name: "ENTRETIEN",
      description: "Maintenance préventive",
      icon: CheckCircle,
      color: "bg-green-500",
      available: true,
    },
  ];

  // Step 2: Installation sub-categories
  const installationTypes = [
    {
      id: "installation-equipement",
      name: "UNE INSTALLATION D'ÉQUIPEMENT",
      description: "Installation de nouveaux équipements",
      icon: Settings,
      color: "bg-blue-500",
    },
    {
      id: "remplacement-equipement",
      name: "UN REMPLACEMENT D'ÉQUIPEMENT",
      description: "Remplacement d'équipements existants",
      icon: Hammer,
      color: "bg-orange-500",
    },
  ];

  // Categories for dépannage
  const depannageCategories = [
    {
      id: "wc",
      name: "WC",
      description: "Toilettes et sanitaires",
      icon: Home,
      image: "/wc.jpeg",
      color: "bg-blue-500",
      available: true,
    },
    {
      id: "douche-baignoire",
      name: "DOUCHE ET BAIGNOIRE",
      description: "(INCLUS ROBINETTERIE)",
      icon: Droplets,
      image: "/2.jpeg",
      color: "bg-blue-400",
      available: true,
    },
    {
      id: "lavabo-evier",
      name: "LAVABO ET ÉVIER",
      description: "(INCLUS ROBINETTERIE)",
      icon: Droplets,
      color: "bg-cyan-500",
      image: "/3.jpeg",
      available: true,
    },
    {
      id: "canalisation",
      name: "CANALISATION ET TUYAUTERIE",
      description: "(HORS DOUCHE, BAIGNOIRE, LAVABO, ÉVIER)",
      icon: Settings,
      image: "/4.jpeg",
      color: "bg-gray-500",
      available: true,
    },
    {
      id: "tuyau-machine",
      name: "TUYAU",
      description: "(MACHINE À LAVER, LAVE VAISSELLE)",
      icon: Settings,
      color: "bg-purple-500",
      image: "/5.jpeg",
      available: true,
    },
    {
      id: "ballon-chaudiere",
      name: "BALLON D'EAU CHAUDE, CHAUFFE-EAU",
      description: "CHAUDIÈRE, PAC AIR-EAU, PAC AIR-AIR",
      icon: Zap,
      image: "/6.jpeg",
      color: "bg-orange-500",
      available: true,
    },
  ];

  // Categories for installation
  const installationCategories = [
    {
      id: "wc",
      name: "WC",
      description: "Installation de toilettes",
      icon: Home,
      color: "bg-blue-500",
      basePrice: 350,
    },
    {
      id: "bac-douche",
      name: "BAC À DOUCHE",
      description: "Installation de bac à douche",
      icon: Droplets,
      color: "bg-blue-400",
      basePrice: 450,
    },
    {
      id: "baignoire",
      name: "BAIGNOIRE",
      description: "Installation de baignoire",
      icon: Droplets,
      color: "bg-cyan-500",
      basePrice: 650,
    },
    {
      id: "lavabo",
      name: "LAVABO",
      description: "Installation de lavabo",
      icon: Droplets,
      color: "bg-teal-500",
      basePrice: 280,
    },
    {
      id: "evier",
      name: "EVIER",
      description: "Installation d'évier",
      icon: Droplets,
      color: "bg-indigo-500",
      basePrice: 320,
    },
    {
      id: "robinet",
      name: "ROBINET",
      description: "Installation de robinetterie",
      icon: Settings,
      color: "bg-gray-500",
      basePrice: 150,
    },
    {
      id: "ballon-eau-chaude",
      name: "BALLON D'EAU CHAUDE",
      description: "Installation de ballon d'eau chaude",
      icon: Thermometer,
      color: "bg-red-500",
      basePrice: 850,
    },
    {
      id: "chaudiere-gaz",
      name: "CHAUDIÈRE GAZ",
      description: "Installation de chaudière gaz",
      icon: Zap,
      color: "bg-orange-500",
      basePrice: 1200,
    },
    {
      id: "chauffe-eau-gaz",
      name: "CHAUFFE-EAU GAZ / THERMODYNAMIQUE",
      description: "Installation de chauffe-eau",
      icon: Thermometer,
      color: "bg-yellow-500",
      basePrice: 950,
    },
    {
      id: "pac-air-eau",
      name: "POMPE À CHALEUR AIR-EAU",
      description: "Installation PAC air-eau",
      icon: Wind,
      color: "bg-green-500",
      basePrice: 2500,
    },
    {
      id: "pac-air-air",
      name: "POMPE À CHALEUR AIR-AIR",
      description: "Installation PAC air-air",
      icon: Wind,
      color: "bg-emerald-500",
      basePrice: 1800,
    },
  ];

  // Categories for entretien
  const entretienCategories = [
    {
      id: "ballon-eau-chaude",
      name: "UN BALLON D'EAU CHAUDE",
      description: "Contrat d'entretien ballon",
      icon: Thermometer,
      color: "bg-red-500",
      basePrice: 120,
      frequency: "annuel",
    },
    {
      id: "chaudiere",
      name: "UNE CHAUDIÈRE",
      description: "Contrat d'entretien chaudière",
      icon: Zap,
      color: "bg-orange-500",
      basePrice: 150,
      frequency: "annuel",
    },
    {
      id: "chauffe-eau-gaz",
      name: "UN CHAUFFE-EAU GAZ",
      description: "Contrat d'entretien chauffe-eau gaz",
      icon: Thermometer,
      color: "bg-yellow-500",
      basePrice: 130,
      frequency: "annuel",
    },
    {
      id: "chauffe-eau-thermodynamique",
      name: "UN CHAUFFE-EAU THERMODYNAMIQUE",
      description: "Contrat d'entretien thermodynamique",
      icon: Thermometer,
      color: "bg-amber-500",
      basePrice: 140,
      frequency: "annuel",
    },
    {
      id: "pompe-chaleur",
      name: "UNE POMPE À CHALEUR",
      description: "Contrat d'entretien PAC",
      icon: Wind,
      color: "bg-green-500",
      basePrice: 180,
      frequency: "annuel",
    },
    {
      id: "climatisation-reversible",
      name: "UNE CLIMATISATION RÉVERSIBLE",
      description: "Contrat d'entretien climatisation",
      icon: Wind,
      color: "bg-blue-600",
      basePrice: 160,
      frequency: "annuel",
    },
  ];

  // Problems for WC (dépannage)
  const wcProblems = [
    {
      id: "wc-bouches",
      name: "WC bouchés (engorgement)",
      description: "Toilettes obstruées, évacuation difficile",
      icon: "🚽",
      urgency: "urgent",
      needsSanibroyeur: true,
      basePrice: 80,
    },
    {
      id: "fuite",
      name: "Fuite (recherche de fuite)",
      description: "Fuite d'eau visible ou suspectée",
      icon: "💧",
      urgency: "rapide",
      needsWcType: true,
      basePrice: 90,
    },
    {
      id: "fonctionnement-defectueux",
      name: "Fonctionnement défectueux",
      description: "Chasse d'eau, mécanisme défaillant",
      icon: "⚙️",
      urgency: "planifie",
      needsWcType: true,
      basePrice: 70,
    },
  ];

  // Problems for Douche et Baignoire
  const doucheBaignoireProblems = [
    {
      id: "fuite-douche",
      name: "Fuite douche/baignoire",
      description: "Fuite au niveau de la douche ou baignoire",
      icon: "🚿",
      urgency: "rapide",
      basePrice: 90,
    },
    {
      id: "evacuation-bouchee",
      name: "Évacuation bouchée",
      description: "Évacuation douche/baignoire obstruée",
      icon: "🔧",
      urgency: "urgent",
      basePrice: 100,
    },
    {
      id: "robinetterie-defaillante",
      name: "Robinetterie défaillante",
      description: "Problème de robinet ou mitigeur",
      icon: "🚰",
      urgency: "planifie",
      basePrice: 80,
    },
  ];

  // Problems for Lavabo et Évier
  const labavoEvierProblems = [
    {
      id: "fuite-lavabo",
      name: "Fuite lavabo/évier",
      description: "Fuite au niveau du lavabo ou évier",
      icon: "🚰",
      urgency: "rapide",
      basePrice: 85,
    },
    {
      id: "evacuation-lente",
      name: "Évacuation lente",
      description: "Évacuation qui se vide lentement",
      icon: "⏳",
      urgency: "planifie",
      basePrice: 75,
    },
    {
      id: "robinet-casse",
      name: "Robinet cassé",
      description: "Robinet défaillant ou cassé",
      icon: "🔧",
      urgency: "rapide",
      basePrice: 90,
    },
  ];

  // Problems for Canalisation et Tuyauterie
  const canalisationProblems = [
    {
      id: "canalisation-bouchee",
      name: "Canalisation bouchée",
      description: "Obstruction dans les canalisations",
      icon: "🚫",
      urgency: "urgent",
      basePrice: 120,
    },
    {
      id: "fuite-canalisation",
      name: "Fuite canalisation",
      description: "Fuite dans la tuyauterie",
      icon: "💧",
      urgency: "urgent",
      basePrice: 110,
    },
    {
      id: "odeur-remontee",
      name: "Odeur remontée",
      description: "Mauvaises odeurs des canalisations",
      icon: "💨",
      urgency: "planifie",
      basePrice: 95,
    },
  ];

  // Problems for Tuyau Machine
  const tuyauMachineProblems = [
    {
      id: "fuite-tuyau-machine",
      name: "Fuite tuyau machine",
      description: "Fuite sur tuyau machine à laver/lave-vaisselle",
      icon: "🔧",
      urgency: "urgent",
      basePrice: 80,
    },
    {
      id: "raccordement-defaillant",
      name: "Raccordement défaillant",
      description: "Problème de raccordement machine",
      icon: "⚙️",
      urgency: "rapide",
      basePrice: 75,
    },
    {
      id: "installation-tuyau",
      name: "Installation nouveau tuyau",
      description: "Installation ou remplacement tuyau",
      icon: "🔨",
      urgency: "planifie",
      basePrice: 85,
    },
  ];

  // Problems for Ballon/Chaudière
  const ballonChaudiereProblems = [
    {
      id: "panne-ballon",
      name: "Panne ballon eau chaude",
      description: "Ballon d'eau chaude en panne",
      icon: "🔥",
      urgency: "urgent",
      basePrice: 150,
    },
    {
      id: "fuite-ballon",
      name: "Fuite ballon/chaudière",
      description: "Fuite sur ballon ou chaudière",
      icon: "💧",
      urgency: "urgent",
      basePrice: 140,
    },
    {
      id: "probleme-chauffe-eau",
      name: "Problème chauffe-eau",
      description: "Dysfonctionnement chauffe-eau",
      icon: "⚡",
      urgency: "rapide",
      basePrice: 130,
    },
  ];

  // State variables for dépannage
  let hasSanibroyeur = $state("");
  let wcType = $state("");
  let houseAge = $state("");

  // WC Types
  const wcTypes = [
    { id: "simple", name: "WC Simple", description: "WC classique au sol" },
    { id: "suspendu", name: "WC Suspendu", description: "WC fixé au mur" },
    { id: "autre", name: "Autre", description: "Autre type de WC" },
  ];

  // House age options for TVA
  const houseAgeOptions = [
    {
      id: "plus-2-ans",
      name: "Maison de plus de 2 ans",
      description: "TVA 10%",
      tva: 10,
    },
    {
      id: "moins-2-ans",
      name: "Maison de moins de 2 ans / Professionnel",
      description: "TVA 20%",
      tva: 20,
    },
  ];

  function getCurrentProblems() {
    switch (selectedCategory) {
      case "wc":
        return wcProblems;
      case "douche-baignoire":
        return doucheBaignoireProblems;
      case "lavabo-evier":
        return labavoEvierProblems;
      case "canalisation":
        return canalisationProblems;
      case "tuyau-machine":
        return tuyauMachineProblems;
      case "ballon-chaudiere":
        return ballonChaudiereProblems;
      default:
        return [];
    }
  }

  // Price calculation function
  function calculatePrice() {
    if (selectedServiceType === "depannage" && selectedProblemData) {
      let basePrice = 0;

      // Base prices for WC problems
      if (selectedCategory === "wc") {
        if (selectedProblem === "wc-bouches") {
          if (hasSanibroyeur === "oui") {
            basePrice = 150; // Prix fixe avec sanibroyeur
          } else {
            basePrice = 80; // Prix de base sans sanibroyeur
          }
        } else if (selectedProblem === "fuite") {
          basePrice =
            wcType === "suspendu" ? 120 : wcType === "simple" ? 90 : 100;
        } else if (selectedProblem === "fonctionnement-defectueux") {
          basePrice =
            wcType === "suspendu" ? 100 : wcType === "simple" ? 70 : 85;
        }
      } else {
        // For other categories, use the base price from the problem definition
        basePrice = selectedProblemData.basePrice || 100;
      }

      // Apply TVA for dépannage
      const selectedHouseAge = houseAgeOptions.find((h) => h.id === houseAge);
      if (selectedHouseAge) {
        const tvaMultiplier = 1 + selectedHouseAge.tva / 100;
        return Math.round(basePrice * tvaMultiplier);
      }

      return basePrice;
    } else if (selectedServiceType === "installation") {
      // Installation pricing
      const category = installationCategories.find(
        (c) => c.id === selectedCategory,
      );
      if (category) {
        let basePrice = category.basePrice;

        // Apply multiplier for replacement vs new installation
        if (selectedSubCategory === "remplacement-equipement") {
          basePrice = Math.round(basePrice * 0.8); // 20% discount for replacement
        }

        // Apply TVA (assume 20% for installation)
        return Math.round(basePrice * 1.2);
      }
    } else if (selectedServiceType === "entretien") {
      // Entretien pricing
      const category = entretienCategories.find(
        (c) => c.id === selectedCategory,
      );
      if (category) {
        // Apply TVA (10% for maintenance)
        return Math.round(category.basePrice * 1.1);
      }
    }

    return null;
  }

  // Navigation functions
  function handleServiceTypeSelect(serviceId: string) {
    selectedServiceType = serviceId;
    if (serviceId === "depannage") {
      currentStep = 2; // Go to dépannage category selection
    } else if (serviceId === "installation") {
      currentStep = 10; // Go to installation type selection
    } else if (serviceId === "entretien") {
      currentStep = 20; // Go to entretien category selection
    }
  }

  function handleInstallationTypeSelect(typeId: string) {
    selectedSubCategory = typeId;
    currentStep = 11; // Go to installation category selection
  }

  function handleCategorySelect(categoryId: string) {
    selectedCategory = categoryId;
    if (selectedServiceType === "depannage") {
      // Check if this category has specific problems
      const problems = getCurrentProblems();
      if (problems.length > 0) {
        currentStep = 3; // Go to problem selection
      } else {
        currentStep = 6; // Go directly to house age question
      }
    } else {
      // For installation and entretien, go directly to summary
      currentStep = 30; // Go to summary
    }
  }

  function handleProblemSelect(problemId: string) {
    selectedProblem = problemId;

    if (selectedCategory === "wc") {
      const problem = wcProblems.find((p) => p.id === problemId);
      if (problem?.needsSanibroyeur) {
        currentStep = 4; // Sanibroyeur question
      } else if (problem?.needsWcType) {
        currentStep = 5; // WC type question
      } else {
        currentStep = 6; // House age question
      }
    } else {
      // For other categories, go directly to house age question
      currentStep = 6;
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
      const serviceDescription =
        selectedServiceType === "depannage"
          ? `${selectedServiceType}-${selectedCategory}-${selectedProblem}`
          : selectedServiceType === "installation"
            ? `${selectedServiceType}-${selectedSubCategory}-${selectedCategory}`
            : `${selectedServiceType}-${selectedCategory}`;

      const appointmentData = {
        first_name: contactData.firstName,
        last_name: contactData.lastName,
        email: contactData.email,
        phone: contactData.phone,
        service: serviceDescription,
        urgency: selectedProblemData?.urgency || "planifie",
        preferred_date: contactData.preferredDate || null,
        preferred_time: contactData.preferredTime || null,
        address: contactData.address,
        message: contactData.message,
        status: "pending",
        created_at: new Date().toISOString(),
      };

      const { data, error } = await supabase
        .from("appointments")
        .insert([appointmentData])
        .select()
        .single();

      if (error) throw error;

      isSubmitted = true;
      submitMessage =
        "Votre demande de rendez-vous a été envoyée avec succès !";
      currentStep = 9;
    } catch (error) {
      console.error("Error submitting appointment:", error);
      submitMessage = "Une erreur est survenue. Veuillez réessayer.";
    } finally {
      isSubmitting = false;
    }
  }

  function goBack() {
    if (currentStep > 1) {
      // Handle specific back navigation logic
      if (currentStep === 6) {
        // Coming from house age question
        if (selectedProblem === "wc-bouches") {
          currentStep = 4; // Back to sanibroyeur question
        } else if (
          selectedProblem &&
          (selectedProblem === "fuite" ||
            selectedProblem === "fonctionnement-defectueux")
        ) {
          currentStep = 5; // Back to WC type question
        } else {
          currentStep = 3; // Back to problem selection
        }
      } else if (currentStep === 5) {
        currentStep = 3; // Back to problem selection
      } else if (currentStep === 4) {
        currentStep = 3; // Back to problem selection
      } else if (currentStep === 11) {
        currentStep = 10; // Back to installation type selection
      } else if (currentStep === 10 || currentStep === 20) {
        currentStep = 1; // Back to service type selection
      } else if (currentStep === 30) {
        // Back from summary
        if (selectedServiceType === "depannage") {
          currentStep = 2;
        } else if (selectedServiceType === "installation") {
          currentStep = 11;
        } else if (selectedServiceType === "entretien") {
          currentStep = 20;
        }
      } else {
        currentStep = currentStep - 1;
      }
    }
  }

  function resetFlow() {
    currentStep = 1;
    selectedServiceType = "";
    selectedCategory = "";
    selectedSubCategory = "";
    selectedProblem = "";
    hasSanibroyeur = "";
    wcType = "";
    houseAge = "";
    contactData = {
      firstName: "",
      lastName: "",
      email: "",
      phone: "",
      address: "",
      preferredDate: "",
      preferredTime: "",
      message: "",
    };
  }

  function goHome() {
    navigate("/");
  }

  // Derived values
  const selectedProblemData = $derived.by(() => {
    if (selectedCategory === "wc") {
      return wcProblems.find((p) => p.id === selectedProblem);
    } else if (selectedCategory === "douche-baignoire") {
      return doucheBaignoireProblems.find((p) => p.id === selectedProblem);
    } else if (selectedCategory === "lavabo-evier") {
      return labavoEvierProblems.find((p) => p.id === selectedProblem);
    } else if (selectedCategory === "canalisation") {
      return canalisationProblems.find((p) => p.id === selectedProblem);
    } else if (selectedCategory === "tuyau-machine") {
      return tuyauMachineProblems.find((p) => p.id === selectedProblem);
    } else if (selectedCategory === "ballon-chaudiere") {
      return ballonChaudiereProblems.find((p) => p.id === selectedProblem);
    }
    return null;
  });

  const maxSteps = $derived(isSubmitted ? 9 : 8);

  // Get current categories based on service type
  const currentCategories = $derived.by(() => {
    if (selectedServiceType === "depannage") return depannageCategories;
    if (selectedServiceType === "installation") return installationCategories;
    if (selectedServiceType === "entretien") return entretienCategories;
    return [];
  });
</script>

<div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-orange-50">
  <!-- Progress Bar -->

  {#if !isSubmitted}
    <div class="bg-white border-b max-sm:hidden">
      <div class="container mx-auto px-4 py-4">
        <div class="flex items-center justify-center space-x-4">
          {#each Array(maxSteps)
            .fill(0)
            .map((_, i) => i + 1) as step}
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
                  class="w-12 h-1 mx-2"
                  class:bg-blue-500={step < currentStep}
                  class:bg-gray-200={step >= currentStep}
                ></div>
              {/if}
            </div>
          {/each}
        </div>
      </div>
    </div>
  {/if}

  <div class="container mx-auto px-4 py-8">
    <div class="max-w-5xl mx-auto">
      <!-- Step 1: Service Type Selection -->
      {#if currentStep === 1}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-blue-500 to-orange-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              Identifiez votre besoin
            </h2>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-3 gap-6">
              {#each serviceTypes as service}
                <button
                  type="button"
                  onclick={() => handleServiceTypeSelect(service.id)}
                  class="p-8 rounded-xl border-2 cursor-pointer transition-all duration-300 text-center hover:shadow-lg hover:border-blue-300 border-gray-200"
                  aria-label={`Select ${service.name}`}
                >
                  <div
                    class="w-16 h-16 {service.color} rounded-full flex items-center justify-center mx-auto mb-4"
                  >
                    <service.icon class="w-8 h-8 text-white" />
                  </div>
                  <h3 class="text-xl font-bold text-gray-800 mb-2">
                    {service.name}
                  </h3>
                  <p class="text-gray-600">{service.description}</p>
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 2: Dépannage Category Selection -->
      {#if currentStep === 2}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-red-500 to-orange-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              Choisissez la catégorie - DÉPANNAGE
            </h2>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {#each depannageCategories as category}
                <button
                  type="button"
                  onclick={() => handleCategorySelect(category.id)}
                  class="group relative rounded-xl border-2 border-gray-200 overflow-hidden cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-400 hover:scale-105 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
                  aria-label={`Select ${category.name}`}
                >
                  {#if category.image}
                    <!-- Image container with fixed aspect ratio -->
                    <div class="aspect-auto relative">
                      <img
                        src={category.image}
                        alt={category.name}
                        class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
                      />
                      <!-- Overlay for better text readability -->
                      <div
                        class="absolute inset-0 bg-white opacity-40 transition-opacity duration-300 group-hover:opacity-0"
                      ></div>
                    </div>

                    <!-- Text content overlay -->
                    <div
                      class="absolute bottom-0 left-0 right-0 p-4 text-black"
                    >
                      <h3 class="font-bold text-lg mb-1 drop-shadow-lg">
                        {category.name}
                      </h3>
                      <p class="text-sm drop-shadow-lg leading-relaxed">
                        {category.description}
                      </p>
                    </div>
                  {:else}
                    <!-- Non-image categories -->
                    <div
                      class="aspect-[4/3] flex flex-col items-center justify-center p-6 bg-gradient-to-br from-gray-50 to-gray-100 group-hover:from-blue-50 group-hover:to-blue-100 transition-colors duration-300"
                    >
                      <div
                        class="w-16 h-16 {category.color} rounded-2xl flex items-center justify-center mb-4 shadow-lg group-hover:shadow-xl transition-shadow duration-300"
                      >
                        <svelte:component
                          this={category.icon}
                          class="w-8 h-8 text-white"
                        />
                      </div>
                      <h3
                        class="font-bold text-gray-800 mb-2 text-center text-lg group-hover:text-blue-700 transition-colors duration-300"
                      >
                        {category.name}
                      </h3>
                      <p
                        class="text-sm text-gray-600 text-center leading-relaxed group-hover:text-gray-700 transition-colors duration-300"
                      >
                        {category.description}
                      </p>
                    </div>
                  {/if}
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 3: Problem Selection -->
      {#if currentStep === 3}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-blue-500 to-orange-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              Quel est plus précisément votre problème ?
            </h2>
            <p class="text-center text-blue-100 mt-2">
              Catégorie : {depannageCategories.find(
                (c) => c.id === selectedCategory,
              )?.name}
            </p>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-1 gap-6 max-w-2xl mx-auto">
              {#each getCurrentProblems() as problem}
                <button
                  type="button"
                  onclick={() => handleProblemSelect(problem.id)}
                  class="p-6 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-300 border-gray-200"
                  aria-label={`Select ${problem.name}`}
                >
                  <div class="flex items-center space-x-4">
                    <div class="text-4xl">{problem.icon}</div>
                    <div class="flex-1">
                      <h3 class="text-xl font-bold text-gray-800 mb-2">
                        {problem.name}
                      </h3>
                      <p class="text-gray-600 mb-3">{problem.description}</p>
                      <div class="flex items-center justify-between">
                        <span
                          class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border border-gray-300 text-gray-700 capitalize"
                        >
                          {problem.urgency}
                        </span>
                        {#if problem.basePrice}
                          <span class="text-lg font-semibold text-blue-600"
                            >À partir de {problem.basePrice}€</span
                          >
                        {/if}
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

      <!-- Step 4: Sanibroyeur Question -->
      {#if currentStep === 4}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-purple-500 to-blue-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              Votre WC est équipé d'un sanibroyeur ?
            </h2>
            <p class="text-center text-purple-100 mt-2">
              Cette information nous aide à estimer le prix
            </p>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-2 gap-6 max-w-2xl mx-auto">
              <button
                type="button"
                onclick={() => handleSanibroyeurSelect("oui")}
                class="p-8 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-green-300 border-gray-200 text-center"
              >
                <div class="text-6xl mb-4">✅</div>
                <h3 class="text-2xl font-bold text-gray-800 mb-2">OUI</h3>
                <p class="text-gray-600">Mon WC a un sanibroyeur</p>
                <div
                  class="mt-4 bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-semibold"
                >
                  Prix fixe : 150€ TTC
                </div>
              </button>

              <button
                type="button"
                onclick={() => handleSanibroyeurSelect("non")}
                class="p-8 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-300 border-gray-200 text-center"
              >
                <div class="text-6xl mb-4">❌</div>
                <h3 class="text-2xl font-bold text-gray-800 mb-2">NON</h3>
                <p class="text-gray-600">WC classique sans sanibroyeur</p>
                <div
                  class="mt-4 bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-semibold"
                >
                  À partir de 80€
                </div>
              </button>
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 5: WC Type Question -->
      {#if currentStep === 5}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-indigo-500 to-purple-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              Quel type de WC possédez-vous ?
            </h2>
            <p class="text-center text-indigo-100 mt-2">
              Le type de WC influence le tarif d'intervention
            </p>
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
                    {#if type.id === "simple"}
                      🚽
                    {:else if type.id === "suspendu"}
                      <img
                        src="/WC_suspendu.svg"
                        alt="WC Suspendu"
                        class="w-12 h-12 mx-auto"
                      />
                    {:else}
                      🛠️
                    {/if}
                  </div>
                  <h3 class="text-xl font-bold text-gray-800 mb-2">
                    {type.name}
                  </h3>
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
          <div
            class="bg-gradient-to-r from-green-500 to-teal-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              Âge de votre logement
            </h2>
            <p class="text-center text-green-100 mt-2">
              Pour appliquer le bon taux de TVA
            </p>
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
                    {#if option.id === "plus-2-ans"}
                      🏠
                    {:else}
                      🏗️
                    {/if}
                  </div>
                  <h3 class="text-xl font-bold text-gray-800 mb-2">
                    {option.name}
                  </h3>
                  <p class="text-gray-600 mb-3">{option.description}</p>
                  <div
                    class="bg-{option.tva === 10
                      ? 'green'
                      : 'orange'}-100 text-{option.tva === 10
                      ? 'green'
                      : 'orange'}-800 px-3 py-1 rounded-full text-sm font-semibold"
                  >
                    TVA {option.tva}%
                  </div>
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 7: Dépannage Summary -->
      {#if currentStep === 7}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-green-500 to-blue-500 text-white p-8"
          >
            <h2
              class="text-3xl font-bold text-center flex items-center justify-center"
            >
              <CheckCircle class="w-8 h-8 mr-3" />
              Récapitulatif de votre demande
            </h2>
          </div>
          <div class="p-8">
            <div class="max-w-2xl mx-auto">
              <!-- Service Summary -->
              <div class="bg-blue-50 rounded-lg p-6 mb-6">
                <h3 class="text-xl font-bold text-blue-800 mb-4">
                  Votre sélection
                </h3>
                <div class="space-y-3">
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Type de service :</span>
                    <span
                      class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-500 text-white"
                    >
                      DÉPANNAGE
                    </span>
                  </div>
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Catégorie :</span>
                    <span
                      class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border border-gray-300 text-gray-700"
                    >
                      {depannageCategories.find(
                        (c) => c.id === selectedCategory,
                      )?.name}
                    </span>
                  </div>
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Problème :</span>
                    <span class="font-semibold text-blue-700">
                      {selectedProblemData?.name}
                    </span>
                  </div>

                  {#if selectedProblem === "wc-bouches"}
                    <div class="flex justify-between items-center">
                      <span class="font-medium">Sanibroyeur :</span>
                      <span class="capitalize font-semibold"
                        >{hasSanibroyeur}</span
                      >
                    </div>
                  {/if}

                  {#if wcType}
                    <div class="flex justify-between items-center">
                      <span class="font-medium">Type de WC :</span>
                      <span class="capitalize font-semibold"
                        >{wcTypes.find((w) => w.id === wcType)?.name}</span
                      >
                    </div>
                  {/if}

                  <div class="flex justify-between items-center">
                    <span class="font-medium">TVA :</span>
                    <span class="font-semibold"
                      >{houseAgeOptions.find((h) => h.id === houseAge)
                        ?.tva}%</span
                    >
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
              <div
                class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 mb-8"
              >
                <h4 class="font-bold text-yellow-800 mb-3">
                  💡 Cette estimation inclut :
                </h4>
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
                <button
                  onclick={goToContactForm}
                  class="px-8 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg font-semibold transition-colors flex items-center justify-center"
                >
                  <Calendar class="w-5 h-5 mr-2" />
                  Prendre rendez-vous
                </button>
                <button
                  class="px-8 py-3 border border-gray-300 text-gray-700 bg-white hover:bg-gray-50 rounded-lg font-semibold transition-colors flex items-center justify-center"
                >
                  <a href="tel:+33745880862">
                    <Phone class="w-5 h-5 mr-2" />
                    Appeler maintenant
                  </a>
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

      <!-- Step 10: Installation Type Selection -->
      {#if currentStep === 10}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-blue-500 to-orange-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              Votre demande concerne :
            </h2>
            <p class="text-center text-blue-100 mt-2">INSTALLATION</p>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-2 gap-6 max-w-3xl mx-auto">
              {#each installationTypes as type}
                <button
                  type="button"
                  onclick={() => handleInstallationTypeSelect(type.id)}
                  class="p-8 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-300 border-gray-200 text-center"
                >
                  <div
                    class="w-16 h-16 {type.color} rounded-full flex items-center justify-center mx-auto mb-4"
                  >
                    <type.icon class="w-8 h-8 text-white" />
                  </div>
                  <h3 class="text-xl font-bold text-gray-800 mb-2">
                    {type.name}
                  </h3>
                  <p class="text-gray-600">{type.description}</p>
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 11: Installation Category Selection -->
      {#if currentStep === 11}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-blue-500 to-orange-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              Votre demande d'installation concerne :
            </h2>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {#each installationCategories as category}
                <button
                  type="button"
                  onclick={() => handleCategorySelect(category.id)}
                  class="p-6 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-300 border-gray-200"
                >
                  <div
                    class="w-12 h-12 {category.color} rounded-lg flex items-center justify-center mx-auto mb-4"
                  >
                    <category.icon class="w-6 h-6 text-white" />
                  </div>
                  <h3 class="font-bold text-gray-800 mb-2">{category.name}</h3>
                  <p class="text-sm text-gray-600">{category.description}</p>
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 20: Entretien Category Selection -->
      {#if currentStep === 20}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-blue-500 to-orange-500 text-white p-8"
          >
            <h2 class="text-3xl font-bold text-center">
              La souscription d'un contrat d'entretien (hors pièces) concerne :
            </h2>
          </div>
          <div class="p-8">
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {#each entretienCategories as category}
                <button
                  type="button"
                  onclick={() => handleCategorySelect(category.id)}
                  class="p-6 rounded-xl border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:border-blue-300 border-gray-200"
                >
                  <div
                    class="w-12 h-12 {category.color} rounded-lg flex items-center justify-center mx-auto mb-4"
                  >
                    <category.icon class="w-6 h-6 text-white" />
                  </div>
                  <h3 class="font-bold text-gray-800 mb-2">{category.name}</h3>
                  <p class="text-sm text-gray-600">{category.description}</p>
                </button>
              {/each}
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 30: General Summary (for Installation and Entretien) -->
      {#if currentStep === 30}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-green-500 to-blue-500 text-white p-8"
          >
            <h2
              class="text-3xl font-bold text-center flex items-center justify-center"
            >
              <CheckCircle class="w-8 h-8 mr-3" />
              Récapitulatif de votre demande
            </h2>
          </div>
          <div class="p-8">
            <div class="max-w-2xl mx-auto">
              <!-- Service Summary -->
              <div class="bg-blue-50 rounded-lg p-6 mb-6">
                <h3 class="text-xl font-bold text-blue-800 mb-4">
                  Votre sélection
                </h3>
                <div class="space-y-3">
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Type de service :</span>
                    <span
                      class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium {selectedServiceType ===
                      'installation'
                        ? 'bg-blue-500'
                        : 'bg-green-500'} text-white uppercase"
                    >
                      {selectedServiceType}
                    </span>
                  </div>
                  {#if selectedSubCategory}
                    <div class="flex justify-between items-center">
                      <span class="font-medium">Type :</span>
                      <span class="font-semibold text-blue-700">
                        {installationTypes.find(
                          (t) => t.id === selectedSubCategory,
                        )?.name}
                      </span>
                    </div>
                  {/if}
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Équipement :</span>
                    <span class="font-semibold text-blue-700">
                      {currentCategories.find((c) => c.id === selectedCategory)
                        ?.name}
                    </span>
                  </div>
                </div>
              </div>

              <!-- Price Information -->
              <div class="bg-green-50 rounded-lg p-6 mb-6">
                <h3 class="text-xl font-bold text-green-800 mb-4">
                  {selectedServiceType === "entretien"
                    ? "Prix annuel TTC"
                    : "Prix TTC"}
                </h3>
                <div class="text-center">
                  {#if calculatePrice()}
                    <div class="text-4xl font-bold text-green-600 mb-2">
                      {calculatePrice()}€
                    </div>
                    <p class="text-gray-600">
                      {selectedServiceType === "installation"
                        ? "Prix estimé pour l'installation"
                        : selectedServiceType === "entretien"
                          ? "Contrat d'entretien annuel"
                          : "Prix estimé"}
                    </p>
                  {:else}
                    <div class="text-2xl font-bold text-orange-600 mb-2">
                      Sur devis
                    </div>
                    <p class="text-gray-600">
                      Prix personnalisé selon vos besoins
                    </p>
                  {/if}
                </div>
              </div>

              <!-- What's included -->
              <div
                class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 mb-8"
              >
                <h4 class="font-bold text-yellow-800 mb-3">
                  💡 Notre prestation inclut :
                </h4>
                <ul class="text-sm text-yellow-700 space-y-2">
                  <li class="flex items-center">
                    <CheckCircle class="w-4 h-4 mr-2 text-green-600" />
                    Étude technique et devis gratuit
                  </li>
                  <li class="flex items-center">
                    <CheckCircle class="w-4 h-4 mr-2 text-green-600" />
                    {selectedServiceType === "installation"
                      ? "Installation professionnelle"
                      : "Contrat d'entretien personnalisé"}
                  </li>
                  <li class="flex items-center">
                    <CheckCircle class="w-4 h-4 mr-2 text-green-600" />
                    Garantie sur les travaux
                  </li>
                  <li class="flex items-center">
                    <CheckCircle class="w-4 h-4 mr-2 text-green-600" />
                    Suivi et conseils personnalisés
                  </li>
                </ul>
              </div>

              <!-- Action Buttons -->
              <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <button
                  onclick={goToContactForm}
                  class="px-8 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg font-semibold transition-colors flex items-center justify-center"
                >
                  <Calendar class="w-5 h-5 mr-2" />
                  Demander un devis
                </button>
                <button
                  class="px-8 py-3 border border-gray-300 text-gray-700 bg-white hover:bg-gray-50 rounded-lg font-semibold transition-colors flex items-center justify-center"
                >
                  <a href="tel:+33745880862">
                    <Phone class="w-5 h-5 mr-2" />
                    Appeler maintenant
                  </a>
                </button>
              </div>
            </div>
          </div>
        </div>
      {/if}

      <!-- Step 8: Contact Form -->
      {#if currentStep === 8}
        <div class="bg-white rounded-lg shadow-xl overflow-hidden">
          <div
            class="bg-gradient-to-r from-blue-500 to-green-500 text-white p-8"
          >
            <h2
              class="text-3xl font-bold text-center flex items-center justify-center"
            >
              <User class="w-8 h-8 mr-3" />
              Vos informations
            </h2>
          </div>
          <div class="p-8">
            <form
              onsubmit={(e) => {
                e.preventDefault();
                submitAppointment();
              }}
            >
              <!-- Personal Information -->
              <div class="grid md:grid-cols-2 gap-6 mb-6">
                <div>
                  <label
                    for="firstName"
                    class="block text-sm font-medium text-gray-700 mb-2"
                  >
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
                  <label
                    for="lastName"
                    class="block text-sm font-medium text-gray-700 mb-2"
                  >
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
                  <label
                    for="email"
                    class="block text-sm font-medium text-gray-700 mb-2"
                  >
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
                  <label
                    for="phone"
                    class="block text-sm font-medium text-gray-700 mb-2"
                  >
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
                <label
                  for="address"
                  class="block text-sm font-medium text-gray-700 mb-2"
                >
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
                  <label
                    for="preferredDate"
                    class="block text-sm font-medium text-gray-700 mb-2"
                  >
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
                  <label
                    for="preferredTime"
                    class="block text-sm font-medium text-gray-700 mb-2"
                  >
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
                <label
                  for="message"
                  class="block text-sm font-medium text-gray-700 mb-2"
                >
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
                  disabled={isSubmitting ||
                    !contactData.firstName ||
                    !contactData.lastName ||
                    !contactData.email ||
                    !contactData.phone ||
                    !contactData.address}
                  class="px-8 py-4 bg-green-600 hover:bg-green-700 disabled:bg-gray-400 text-white rounded-lg font-semibold transition-colors flex items-center mx-auto"
                >
                  {#if isSubmitting}
                    <div
                      class="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-2"
                    ></div>
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
          <div
            class="bg-gradient-to-r from-green-500 to-blue-500 text-white p-8"
          >
            <h2
              class="text-3xl font-bold text-center flex items-center justify-center"
            >
              <CheckCircle class="w-8 h-8 mr-3" />
              Demande envoyée !
            </h2>
          </div>
          <div class="p-12 text-center">
            <div
              class="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-8"
            >
              <CheckCircle class="w-12 h-12 text-green-600" />
            </div>

            <h1 class="text-4xl font-bold text-gray-800 mb-6">
              Demande envoyée !
            </h1>
            <p class="text-xl text-gray-600 mb-8">{submitMessage}</p>

            <div class="bg-blue-50 rounded-lg p-6 mb-8">
              <h3 class="font-semibold text-blue-800 mb-2">
                Prochaines étapes :
              </h3>
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
      {#if (currentStep > 1 && currentStep < 8) || currentStep === 10 || currentStep === 11 || currentStep === 20 || currentStep === 30}
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
          {#if currentStep < 7 && currentStep !== 30}
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
  {#if currentStep <= 30}
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
  {/if}
</div>
