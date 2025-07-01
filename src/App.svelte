<script lang="ts">
    import { onMount } from 'svelte';

    // State management with runes
    let currentSection = $state('accueil');
    let menuOpen = $state(false);
    let selectedService = $state('');

    const services = [
        {
            id: 'fuite',
            nom: 'Réparation de fuites',
            description: 'Détection et réparation de fuites d\'eau',
            prix: 'À partir de 80€',
            icon: '💧',
            urgence: true
        },
        {
            id: 'debouchage',
            nom: 'Débouchage canalisations',
            description: 'Débouchage WC, évier, douche',
            prix: 'À partir de 120€',
            icon: '🔧',
            urgence: true
        },
        {
            id: 'chauffage',
            nom: 'Installation chauffage',
            description: 'Installation et maintenance chauffage',
            prix: 'Devis gratuit',
            icon: '🔥',
            urgence: false
        },
        {
            id: 'sanitaire',
            nom: 'Installation sanitaire',
            description: 'WC, lavabo, douche, baignoire',
            prix: 'Devis gratuit',
            icon: '🚿',
            urgence: false
        }
    ];

    // Form data
    let formData = $state({
        nom: '',
        telephone: '',
        email: '',
        adresse: '',
        description: '',
        urgence: false
    });

    // Event handlers
    function handleQuickQuote(event: Event) {
        event.preventDefault();
        alert('Merci pour votre demande ! Nous vous contactons dans les plus brefs délais.');
    }

    function handleContactForm(event: Event) {
        event.preventDefault();
        alert('Votre demande a été envoyée avec succès ! Nous vous recontactons rapidement.');
    }


</script>

<style>
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    @keyframes slideUp {
        from { transform: translateY(50px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    @keyframes float {
        0%, 100% { transform: translateY(0px); }
        50% { transform: translateY(-10px); }
    }
    @keyframes pulseGlow {
        from { box-shadow: 0 0 20px rgba(59, 130, 246, 0.5); }
        to { box-shadow: 0 0 30px rgba(59, 130, 246, 0.8), 0 0 40px rgba(59, 130, 246, 0.3); }
    }
    .glass-effect {
        backdrop-filter: blur(10px);
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
    }
    .gradient-text {
        background: linear-gradient(135deg, #3b82f6, #06b6d4);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
</style>

<div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-cyan-50">
    <!-- Header -->
    <header class="fixed top-0 w-full z-50 glass-effect border-b border-white/20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center animate-fade-in">
                    <div class="text-2xl font-bold gradient-text">🔧 PlombiPro</div>
                </div>
                
                <!-- Desktop Menu -->
                <nav class="hidden md:flex space-x-8">
                    <button onclick={() => currentSection = 'accueil'} 
                            class="text-gray-700 hover:text-blue-500 transition-colors duration-300 font-medium">
                        Accueil
                    </button>
                    <button onclick={() => currentSection = 'services'} 
                            class="text-gray-700 hover:text-blue-500 transition-colors duration-300 font-medium">
                        Services
                    </button>
                    <button onclick={() => currentSection = 'urgence'} 
                            class="text-gray-700 hover:text-blue-500 transition-colors duration-300 font-medium">
                        Urgence 24h/7j
                    </button>
                    <button onclick={() => currentSection = 'contact'} 
                            class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-all duration-300 animate-pulse-glow">
                        Contact
                    </button>
                </nav>

                <!-- Mobile Menu Button -->
                <button onclick={() => menuOpen = !menuOpen} class="md:hidden">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                    </svg>
                </button>
            </div>
        </div>

        <!-- Mobile Menu -->
        {#if menuOpen}
        <div class="md:hidden">
            <div class="px-2 pt-2 pb-3 space-y-1 glass-effect">
                <button onclick={() => { currentSection = 'accueil'; menuOpen = false; }} 
                        class="block px-3 py-2 text-gray-700 hover:text-blue-500">Accueil</button>
                <button onclick={() => { currentSection = 'services'; menuOpen = false; }} 
                        class="block px-3 py-2 text-gray-700 hover:text-blue-500">Services</button>
                <button onclick={() => { currentSection = 'urgence'; menuOpen = false; }} 
                        class="block px-3 py-2 text-gray-700 hover:text-blue-500">Urgence 24h/7j</button>
                <button onclick={() => { currentSection = 'contact'; menuOpen = false; }} 
                        class="block px-3 py-2 text-gray-700 hover:text-blue-500">Contact</button>
            </div>
        </div>
        {/if}
    </header>
    
    <!-- Main Content -->
    <main>
        {#if currentSection === 'accueil'}
        <section class="pt-24 pb-16 px-4">
            <div class="max-w-7xl mx-auto">
                <div class="grid lg:grid-cols-2 gap-12 items-center">
                    <div class="animate-slide-up">
                        <h1 class="text-5xl lg:text-6xl font-bold mb-6">
                            <span class="gradient-text">Plomberie</span> & 
                            <span class="text-orange-500">Chauffage</span>
                        </h1>
                        <p class="text-xl text-gray-600 mb-8 leading-relaxed">
                            Service d'intervention rapide et professionnel. 
                            Dépannage 24h/7j dans toute l'Île-de-France.
                        </p>
                        
                        <div class="flex flex-col sm:flex-row gap-4 mb-8">
                            <button onclick={() => currentSection = 'urgence'} 
                                    class="bg-red-500 text-white px-8 py-4 rounded-xl font-semibold hover:bg-red-600 transform hover:scale-105 transition-all duration-300 animate-pulse-glow">
                                🚨 Urgence 24h/7j
                            </button>
                            <button onclick={() => currentSection = 'services'} 
                                    class="bg-blue-500 text-white px-8 py-4 rounded-xl font-semibold hover:bg-blue-700 transform hover:scale-105 transition-all duration-300">
                                Voir nos services
                            </button>
                        </div>

                        <div class="grid grid-cols-3 gap-6 text-center">
                            <div class="animate-float">
                                <div class="text-3xl font-bold text-blue-500">+500</div>
                                <div class="text-gray-600">Interventions</div>
                            </div>
                            <div class="animate-float" style="animation-delay: 0.5s">
                                <div class="text-3xl font-bold text-orange-500">24h/7j</div>
                                <div class="text-gray-600">Disponibilité</div>
                            </div>
                            <div class="animate-float" style="animation-delay: 1s">
                                <div class="text-3xl font-bold text-cyan-500">98%</div>
                                <div class="text-gray-600">Satisfaction</div>
                            </div>
                        </div>
                    </div>

                    <div class="relative animate-fade-in">
                        <div class="glass-effect rounded-3xl p-8 transform hover:scale-105 transition-all duration-500">
                            <h3 class="text-2xl font-bold mb-6 text-center gradient-text">Devis Gratuit en Ligne</h3>
                            <form class="space-y-4" onsubmit={handleQuickQuote}>
                                <select class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                    <option value="">Sélectionnez votre besoin</option>
                                    {#each services as service}
                                    <option value={service.id}>{service.nom}</option>
                                    {/each}
                                </select>
                                <input type="text" placeholder="Votre nom" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <input type="tel" placeholder="Téléphone" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <textarea placeholder="Décrivez votre problème..." class="w-full p-3 border border-gray-300 rounded-lg h-24 focus:ring-2 focus:ring-blue-500 focus:border-transparent"></textarea>
                                <button type="submit" class="w-full bg-gradient-to-r from-blue-500 to-cyan-500 text-white py-3 rounded-lg font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-300">
                                    Obtenir mon devis gratuit
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        {/if}

        {#if currentSection === 'services'}
        <section class="py-16 px-4">
            <div class="max-w-7xl mx-auto">
                <div class="text-center mb-12 animate-fade-in">
                    <h2 class="text-4xl font-bold mb-4 gradient-text">Nos Services</h2>
                    <p class="text-xl text-gray-600">Solutions complètes de plomberie et chauffage</p>
                </div>

                <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                    {#each services as service, index}
                    <div class="glass-effect rounded-2xl p-6 text-center transform hover:scale-105 transition-all duration-500 animate-slide-up" style="animation-delay: {index * 0.1}s">
                        <div class="text-4xl mb-4 animate-float" style="animation-delay: {index * 0.2}s">{service.icon}</div>
                        <h3 class="text-xl font-bold mb-3 text-gray-800">{service.nom}</h3>
                        <p class="text-gray-600 mb-4">{service.description}</p>
                        <div class="text-lg font-semibold text-blue-500 mb-4">{service.prix}</div>
                        {#if service.urgence}
                        <span class="bg-red-100 text-red-600 px-3 py-1 rounded-full text-sm font-medium">Urgence</span>
                        {/if}
                        <button onclick={() => { selectedService = service.id; currentSection = 'contact'; }} 
                                class="mt-4 w-full bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-700 transition-colors">
                            Demander un devis
                        </button>
                    </div>
                    {/each}
                </div>

                <div class="mt-16 text-center">
                    <div class="glass-effect rounded-3xl p-8 max-w-4xl mx-auto">
                        <h3 class="text-2xl font-bold mb-6 gradient-text">Pourquoi choisir PlombiPro ?</h3>
                        <div class="grid md:grid-cols-3 gap-8 Knutson">
                            <div class="animate-fade-in">
                                <div class="text-3xl mb-3">⚡</div>
                                <h4 class="font-semibold mb-2">Intervention Rapide</h4>
                                <p class="text-gray-600">Délai d'intervention moyen de 30 minutes en urgence</p>
                            </div>
                            <div class="animate-fade-in" style="animation-delay: 0.2s">
                                <div class="text-3xl mb-3">✅</div>
                                <h4 class="font-semibold mb-2">Garantie Qualité</h4>
                                <p class="text-gray-600">Travaux garantis 2 ans, artisans certifiés RGE</p>
                            </div>
                            <div class="animate-fade-in" style="animation-delay: 0.4s">
                                <div class="text-3xl mb-3">💰</div>
                                <h4 class="font-semibold mb-2">Tarifs Transparents</h4>
                                <p class="text-gray-600">Devis gratuit, prix fixe, pas de surprise</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        {/if}

        {#if currentSection === 'urgence'}
        <section class="py-16 px-4">
            <div class="max-w-4xl mx-auto text-center">
                <div class="bg-gradient-to-r from-red-500 to-orange-500 text-white rounded-3xl p-12 animate-pulse-glow">
                    <div class="text-6xl mb-6 animate-float">🚨</div>
                    <h2 class="text-4xl font-bold mb-6">Urgence Plomberie 24h/7j</h2>
                    <p class="text-xl mb-8">Fuite d'eau, canalisation bouchée, panne de chauffage ?<br>Nous intervenons en moins de 30 minutes !</p>
                    
                    <div class="flex flex-col sm:flex-row gap-4 justify-center mb-8">
                        <a href="tel:0123456789" class="bg-white text-red-500 px-8 py-4 rounded-xl font-bold text-xl hover:bg-gray-100 transform hover:scale-105 transition-all duration-300">
                            📞 01 23 45 67 89
                        </a>
                        <button onclick={() => currentSection = 'contact'} 
                                class="bg-yellow-400 text-red-500 px-8 py-4 rounded-xl font-bold hover:bg-yellow-300 transform hover:scale-105 transition-all duration-300">
                            Demande d'intervention
                        </button>
                    </div>

                    <div class="grid md:grid-cols-3 gap-6 text-center">
                        <div class="bg-white/20 rounded-xl p-4">
                            <div class="text-2xl mb-2">⏰</div>
                            <div class="font-semibold">Intervention</div>
                            <div> 30 minutes</div>
                        </div>
                        <div class="bg-white/20 rounded-xl p-4">
                            <div class="text-2xl mb-2">🛠️</div>
                            <div class="font-semibold">Matériel</div>
                            <div>Toujours disponible</div>
                        </div>
                        <div class="bg-white/20 rounded-xl p-4">
                            <div class="text-2xl mb-2">🎯</div>
                            <div class="font-semibold">Zone</div>
                            <div>Île-de-France</div>
                        </div>
                    </div>
                </div>

                <div class="mt-12 grid md:grid-cols-2 gap-8">
                    <div class="glass-effect rounded-2xl p-6">
                        <h3 class="text-xl font-bold mb-4 text-red-500">Situations d'urgence</h3>
                        <ul class="text-left space-y-2">
                            <li class="flex items-center"><span class="text-red-500 mr-2">•</span> Fuite d'eau importante</li>
                            <li class="flex items-center"><span class="text-red-500 mr-2">•</span> Canalisation complètement bouchée</li>
                            <li class="flex items-center"><span class="text-red-500 mr-2">•</span> Panne totale de chauffage</li>
                            <li class="flex items-center"><span class="text-red-500 mr-2">•</span> WC hors service</li>
                            <li class="flex items-center"><span class="text-red-500 mr-2">•</span> Chauffe-eau en panne</li>
                        </ul>
                    </div>
                    <div class="glass-effect rounded-2xl p-6">
                        <h3 class="text-xl font-bold mb-4 text-blue-500">Notre engagement</h3>
                        <ul class="text-left space-y-2">
                            <li class="flex items-center"><span class="text-blue-500 mr-2">•</span> Devis gratuit même en urgence</li>
                            <li class="flex items-center"><span class="text-blue-500 mr-2">•</span> Tarif transparent, pas de surprise</li>
                            <li class="flex items-center"><span class="text-blue-500 mr-2">•</span> Travaux garantis</li>
                            <li class="flex items-center"><span class="text-blue-500 mr-2">•</span> Paiement facilité</li>
                            <li class="flex items-center"><span class="text-blue-500 mr-2">•</span> Artisans qualifiés</li>
                        </ul>
                    </div>
                </div>
            </div>
        </section>
        {/if}

        {#if currentSection === 'contact'}
        <section class="py-16 px-4">
            <div class="max-w-6xl mx-auto">
                <div class="text-center mb-12 animate-fade-in">
                    <h2 class="text-4xl font-bold mb-4 gradient-text">Contactez-nous</h2>
                    <p class="text-xl text-gray-600">Devis gratuit et sans engagement</p>
                </div>

                <div class="grid lg:grid-cols-2 gap-12">
                    <div class="glass-effect rounded-3xl p-8 animate-slide-up">
                        <h3 class="text-2xl font-bold mb-6">Demande de devis</h3>
                        <form class="space-y-4" onsubmit={handleContactForm}>
                            <div class="grid md:grid-cols-2 gap-4">
                                <input type="text" placeholder="Nom *" required class="p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" bind:value={formData.nom}>
                                <input type="tel" placeholder="Téléphone *" required class="p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" bind:value={formData.telephone}>
                            </div>
                            <input type="email" placeholder="Email *" required class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" bind:value={formData.email}>
                            <input type="text" placeholder="Adresse d'intervention" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" bind:value={formData.adresse}>
                            
                            <select class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent" bind:value={selectedService}>
                                <option value="">Type d'intervention</option>
                                {#each services as service}
                                <option value={service.id} selected={selectedService === service.id}>{service.nom}</option>
                                {/each}
                            </select>
                            
                            <textarea placeholder="Description détaillée du problème *" required class="w-full p-3 border border-gray-300 rounded-lg h-32 focus:ring-2 focus:ring-blue-500 focus:border-transparent" bind:value={formData.description}></textarea>
                            
                            <div class="flex items-center space-x-2">
                                <input type="checkbox" id="urgence" class="w-4 h-4 text-red-500 focus:ring-red-500" bind:checked={formData.urgence}>
                                <label for="urgence" class="text-red-500 font-medium">Intervention d'urgence</label>
                            </div>
                            
                            <button type="submit" class="w-full bg-gradient-to-r from-blue-500 to-cyan-500 text-white py-4 rounded-lg font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-300">
                                Envoyer ma demande
                            </button>
                        </form>
                    </div>

                    <div class="space-y-8 animate-fade-in">
                        <div class="glass-effect rounded-2xl p-6">
                            <h3 class="text-xl font-bold mb-4 gradient-text">Coordonnées</h3>
                            <div class="space-y-3">
                                <div class="flex items-center">
                                    <span class="text-2xl mr-3">📞</span>
                                    <div>
                                        <div class="font-semibold">Urgence 24h/7j</div>
                                        <div class="text-blue-500">01 23 45 67 89</div>
                                    </div>
                                </div>
                                <div class="flex items-center">
                                    <span class="text-2xl mr-3">📧</span>
                                    <div>
                                        <div class="font-semibold">Email</div>
                                        <div class="text-blue-500">contact@plombipro.fr</div>
                                    </div>
                                </div>
                                <div class="flex items-center">
                                    <span class="text-2xl mr-3">📍</span>
                                    <div>
                                        <div class="font-semibold">Zone d'intervention</div>
                                        <div class="text-gray-600">Paris et Île-de-France</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="glass-effect rounded-2xl p-6">
                            <h3 class="text-xl font-bold mb-4 gradient-text">Horaires</h3>
                            <div class="space-y-2">
                                <div class="flex justify-between">
                                    <span>Lundi - Vendredi</span>
                                    <span class="font-semibold">8h00 - 19h00</span>
                                </div>
                                <div class="flex justify-between">
                                    <span>Samedi</span>
                                    <span class="font-semibold">8h00 - 17h00</span>
                                </div>
                                <div class="flex justify-between">
                                    <span>Dimanche</span>
                                    <span class="font-semibold">9h00 - 16h00</span>
                                </div>
                                <div class="border-t pt-2 mt-3">
                                    <div class="text-red-500 font-semibold">🚨 Urgences : 24h/7j</div>
                                </div>
                            </div>
                        </div>

                        <div class="glass-effect rounded-2xl p-6">
                            <h3 class="text-xl font-bold mb-4 gradient-text">Moyens de paiement</h3>
                            <div class="grid grid-cols-2 gap-4 text-center">
                                <div class="bg-white/50 rounded-lg p-3">💳 Carte bancaire</div>
                                <div class="bg-white/50 rounded-lg p-3">💵 Espèces</div>
                                <div class="bg-white/50 rounded-lg p-3">🏦 Virement</div>
                                <div class="bg-white/50 rounded-lg p-3">📝 Chèque</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        {/if}
    </main>
    
    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-12">
        <div class="max-w-7xl mx-auto px-4">
            <div class="grid md:grid-cols-4 gap-8">
                <div>
                    <div class="text-2xl font-bold mb-4 gradient-text">🔧 PlombiPro</div>
                    <p class="text-gray-300 mb-4">Votre expert en plomberie et chauffage en Île-de-France. Service professionnel et intervention rapide.</p>
                    <div class="flex space-x-4">
                        <a href="#" class="text-gray-300 hover:text-white transition-colors">📘</a>
                        <a href="#" class="text-gray-300 hover:text-white transition-colors">📷</a>
                        <a href="#" class="text-gray-300 hover:text-white transition-colors">🐦</a>
                    </div>
                </div>
                
                <div>
                    <h4 class="font-bold mb-4">Services</h4>
                    <ul class="space-y-2 text-gray-300">
                        <li><a href="#" class="hover:text-white transition-colors">Réparation fuites</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Débouchage</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Installation chauffage</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Sanitaire</a></li>
                    </ul>
                </div>
                
                <div>
                    <h4 class="font-bold mb-4">Informations</h4>
                    <ul class="space-y-2 text-gray-300">
                        <li><a href="#" class="hover:text-white transition-colors">Devis gratuit</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Zone d'intervention</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Garanties</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Urgences</a></li>
                    </ul>
                </div>
                
                <div>
                    <h4 class="font-bold mb-4">Contact</h4>
                    <div class="space-y-2 text-gray-300">
                        <div class="flex items-center">
                            <span class="mr-2">📞</span>
                            <span>01 23 45 67 89</span>
                        </div>
                        <div class="flex items-center">
                            <span class="mr-2">📧</span>
                            <span>contact@plombipro.fr</span>
                        </div>
                        <div class="flex items-center">
                            <span class="mr-2">📍</span>
                            <span>Paris & Île-de-France</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-400">
                <p>© 2024 PlombiPro. Tous droits réservés. | Mentions légales | Politique de confidentialité</p>
            </div>
        </div>
    </footer>
    
    <!-- Floating Action Button -->
    <div class="fixed bottom-6 right-6 z-50">
        <a href="tel:0123456789" class="bg-red-500 text-white p-4 rounded-full shadow-lg hover:bg-red-600 transition-all duration-300 animate-pulse-glow block text-center">
            <div class="text-2xl">📞</div>
            <div class="text-xs font-semibold mt-1">Urgence</div>
        </a>
    </div>
</div>