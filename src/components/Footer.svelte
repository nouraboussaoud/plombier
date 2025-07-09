<script lang="ts">
    import { onMount } from "svelte";
    import { navigate } from "../lib/router";
    import Nous from "./Nous.svelte";
    import App from "../App.svelte";
    import { push } from "svelte-spa-router";

    // Footer links data
    const footerLinks = {
        FRD: [
            { text: "Qui sommes-nous ?", page: "/#/qui-sommes-nous" },
            { text: "Nous contacter", page: "/#/nous-contacter" },
            { text: "Nos engagements", page: "/#/nos-engagements" },
            { text: "CGV", page: "/#/cgv" },
            {
                text: "Politique de confidentialité",
                page: "/#/politique-confidentialite",
            },
            { text: "Mentions légales", page: "/#/mentions-legales" },
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
        navigate(page);
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
</script>

<footer
    class="bg-gradient-to-r from-blue-500 to-blue-400 text-white relative overflow-hidden"
>
    <!-- Honeycomb Pattern Background -->
    <div class="absolute inset-0 opacity-10">
        <svg
            class="w-full h-full"
            viewBox="0 0 1200 400"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
        >
            <defs>
                <pattern
                    id="honeycomb"
                    x="0"
                    y="0"
                    width="60"
                    height="52"
                    patternUnits="userSpaceOnUse"
                >
                    <polygon
                        points="30,0 45,8.7 45,26.1 30,34.8 15,26.1 15,8.7"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="1"
                    />
                </pattern>
            </defs>
            <rect width="100%" height="100%" fill="url(#honeycomb)" />
        </svg>
    </div>

    <div class="container mx-auto px-6 py-12 relative z-10">
        <div class="grid grid-cols-1 lg:grid-cols-5 gap-8">
            <!-- Company Info Column -->
            <div class="lg:col-span-1">
                <!-- Logo -->
                <div class="bg-white rounded-lg p-4 inline-block mb-6">
                    <div class="flex items-center">
                        <div
                            class=" rounded-full flex items-center justify-center mr-2"
                        >
                            <img src="logo.png" alt="" />
                        </div>
                        <div>
                            <div class="text-blue-600 font-bold text-xl">
                                FRD Services
                            </div>
                            <div class="text-xs text-gray-600">
                                Plomberie Chauffage
                            </div>
                            <div class="text-xs text-gray-600">
                                Climatisation
                            </div>
                        </div>
                    </div>
                    <div class="text-xs text-gray-600 mt-1">
                        Spécialiste du dépannage urgent
                    </div>
                </div>

                <!-- Contact Info -->
                <div class="mb-6">
                    <p class="text-sm mb-2">Contactez-nous au</p>
                    <p class="text-xl font-bold">99 99 99 99</p>
                </div>

                <!-- Hours -->
                <div class="mb-6">
                    <h3 class="font-semibold mb-3">HORAIRES D'OUVERTURE</h3>
                    <div class="text-sm space-y-1">
                        <p>Du lundi au vendredi :</p>
                        <p>de 8h00 à 18h30</p>
                        <p class="pt-2">Le samedi : de 8h30 à 16h30</p>
                    </div>
                </div>

                <!-- Social Media -->
                <div>
                    <p class="text-sm mb-3">Suivez-vous sur :</p>
                    <div class="flex space-x-3">
                        <a
                            href="#"
                            class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center hover:bg-blue-700 transition-colors"
                        >
                            <svg
                                class="w-4 h-4 fill-current"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"
                                />
                            </svg>
                        </a>
                        <a
                            href="#"
                            class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center hover:bg-blue-700 transition-colors"
                        >
                            <svg
                                class="w-4 h-4 fill-current"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"
                                />
                            </svg>
                        </a>
                    </div>
                </div>
            </div>

            <!-- FRD Links -->
            <div class="lg:col-span-1">
                <h3 class="font-semibold mb-6">FRD Services</h3>
                <ul class="space-y-3">
                    {#each footerLinks.FRD as link}
                        <li>
                            <button
                                onclick={() => navigateAndScrollToTop(link.page)}
                                class="text-sm hover:text-blue-200 transition-colors"
                            >
                                {link.text}
                            </button>
                        </li>
                    {/each}
                </ul>
            </div>

            <!-- Devis Links -->
            <div class="lg:col-span-1">
                <h3 class="font-semibold mb-6">OBTENIR UN DEVIS GRATUIT</h3>
                <ul class="space-y-3">
                    {#each footerLinks.devis as link}
                        <li>
                            <button
                                onclick={() => navigateToRdvAndScrollToTop()}
                                class="text-sm hover:text-blue-200 transition-colors cursor-pointer"
                            >
                                {link.text}
                            </button>
                        </li>
                    {/each}
                </ul>
            </div>

            <!-- Projects Links -->
            <div class="lg:col-span-1">
                <h3 class="font-semibold mb-6">VOUS AVEZ UN PROJET ?</h3>
                <ul class="space-y-3">
                    {#each footerLinks.projets as link}
                        <li>
                            <a
                                href={link.href}
                                class="text-sm hover:text-blue-200 transition-colors"
                                onclick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
                            >
                                {link.text}
                            </a>
                        </li>
                    {/each}
                </ul>
            </div>
        </div>

        <!-- Copyright -->
        <div class="text-center">
            <p class="text-sm">© FRD SERVICES — Tous droits réservés.</p>
        </div>
    </div>
</footer>
