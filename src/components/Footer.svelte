<script lang="ts">
    import { onMount } from "svelte";
    import { navigate } from "../lib/router";
    import Nous from "./Nous.svelte";
    import App from "../App.svelte";
    
    // Footer links data
    const footerLinks = {
        FRD: [
            { text: "Qui sommes-nous ?", page: "/qui-sommes-nous" },
            { text: "Nous contacter", page: "/nous-contacter" },
            { text: "Nos engagements", page: "/nos-engagements" },
            { text: "CGV", page: "/cgv" },
            {
                text: "Politique de confidentialité",
                page: "/politique-confidentialite",
            },
            { text: "Mentions légales", page: "/mentions-legales" },
        ],
        devis: [
            { text: "Devis chauffe-eau électrique", href: "#" },
            { text: "Devis chauffe-eau thermodynamique", href: "#" },
            { text: "Devis chaudière gaz", href: "#" },
            { text: "Devis pompe à chaleur", href: "#" },
            { text: "Devis climatisation", href: "#" },
        ],
        projets: [
            { text: "Salle de bains", href: "#" },
            { text: "Installation pompe à chaleur", href: "#" },
            { text: "Remplacement chaudière gaz", href: "#" },
            { text: "Remplacement chauffe-eau", href: "#" },
            { text: "Installation climatisation", href: "#" },
        ],
    };

    const locations =
        "Paris 75 (siège) | Melun (77) | Versailles (78) | Monthéry (91) | Saint-Maur-des-Fossés (94) | Caen (14) | Orléans (45) | Tours (37)";

    function navigateAndScrollToTop(page: string) {
        // Remove hash for legal pages to make them accessible via direct URLs
        if (page === "/cgv" || page === "/mentions-legales") {
            navigate(page);
        } else {
            navigate("/#" + page);
        }
        setTimeout(() => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }, 100);
    }

    function navigateToRdvAndScrollToTop() {
        navigate("/rdv");
        setTimeout(() => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }, 100);
    }
    
    function navigateToHome() {
        navigate("/");
        setTimeout(() => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }, 100);
    }
</script>

<footer class="bg-blue-500 text-white py-8">
  <div class="container mx-auto px-8 max-sm:px-4">
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
      <!-- Column 1: Logo and Contact Info -->
      <div>
        <div class="bg-white rounded-lg p-4 mb-6">
          <div class="flex flex-col items-center">
            <img src="/logo.png" alt="FRD Services" class="h-16 mb-2" />
            <div class="text-blue-600 font-bold text-xl">FRD Services</div>
            <div class="text-sm text-gray-600">Plomberie</div>
            <div class="text-sm text-gray-600">Chauffage</div>
            <div class="text-sm text-gray-600">Climatisation</div>
          </div>
          <div class="text-xs text-gray-600 mt-2 text-center">
            Spécialiste du dépannage urgent
          </div>
        </div>

        <div class="mb-6">
          <p class="text-sm mb-1">Contactez-nous au</p>
          <p class="text-xl font-bold">
            <a href="tel:+33745880862">+33 7 45 88 08 62</a>
          </p>
        </div>

        <div class="mb-6">
          <h3 class="font-semibold mb-2">HORAIRES D'OUVERTURE</h3>
          <div class="text-sm">
            <p>Du lundi au vendredi :</p>
            <p>de 8h00 à 18h30</p>
          </div>
        </div>
      </div>

      <!-- Column 2: FRD Services -->
      <div>
        <h3 class="text-lg font-semibold mb-4">FRD Services</h3>
        <ul class="space-y-2">
          <li>
            <button
              on:click={() => navigateAndScrollToTop("/qui-sommes-nous")}
              class="text-white hover:underline text-sm"
            >
              Qui sommes-nous ?
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateAndScrollToTop("/nous-contacter")}
              class="text-white hover:underline text-sm"
            >
              Nous contacter
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateAndScrollToTop("/nos-engagements")}
              class="text-white hover:underline text-sm"
            >
              Nos engagements
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateAndScrollToTop("/cgv")}
              class="text-white hover:underline text-sm"
            >
              CGV
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateAndScrollToTop("/politique-confidentialite")}
              class="text-white hover:underline text-sm"
            >
              Politique de confidentialité
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateAndScrollToTop("/mentions-legales")}
              class="text-white hover:underline text-sm"
            >
              Mentions légales
            </button>
          </li>
        </ul>
      </div>

      <!-- Column 3: OBTENIR UN DEVIS GRATUIT -->
      <div>
        <h3 class="text-lg font-semibold mb-4">OBTENIR UN DEVIS GRATUIT</h3>
        <ul class="space-y-2">
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Devis chauffe-eau électrique
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Devis chauffe-eau thermodynamique
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Devis chaudière gaz
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Devis pompe à chaleur
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Devis climatisation
            </button>
          </li>
        </ul>
      </div>

      <!-- Column 4: VOUS AVEZ UN PROJET ? -->
      <div>
        <h3 class="text-lg font-semibold mb-4">VOUS AVEZ UN PROJET ?</h3>
        <ul class="space-y-2">
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Salle de bains
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Installation pompe à chaleur
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Remplacement chaudière gaz
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Remplacement chauffe-eau
            </button>
          </li>
          <li>
            <button
              on:click={() => navigateToRdvAndScrollToTop()}
              class="text-white hover:underline text-sm"
            >
              Installation climatisation
            </button>
          </li>
        </ul>
      </div>
    </div>

    <!-- Copyright -->
    <div class="mt-8 pt-4 border-t border-blue-400 text-center">
      <p>© FRD SERVICES — Tous droits réservés.</p>
    </div>
  </div>
</footer>
