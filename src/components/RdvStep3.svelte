<script >
  import { CheckCircle, Calendar, User, Mail, Phone, MapPin, ArrowLeft, Home } from 'lucide-svelte';
  import { navigate } from '../lib/router';
  import { supabase } from '../lib/supabase.js';
  import { onMount } from 'svelte';
    import GoBack from './GoBack.svelte';
  
  let step1Data = $state();
  let step2Data = $state();
  let isSubmitting = $state(false);
  let isSubmitted = $state(false);
  let submitMessage = $state('');
  
  onMount(() => {
    const stored1 = sessionStorage.getItem('rdv_step1');
    const stored2 = sessionStorage.getItem('rdv_step2');
    
    if (stored1 && stored2) {
      step1Data = JSON.parse(stored1);
      step2Data = JSON.parse(stored2);
    } else {
      navigate('/rdv');
    }
  });
  
  async function submitAppointment() {
    if (!step1Data || !step2Data) return;
    
    isSubmitting = true;
    
    try {
      const { data, error } = await supabase
        .from('appointments')
        .insert([
          {
            first_name: step2Data.firstName,
            last_name: step2Data.lastName,
            email: step2Data.email,
            phone: step2Data.phone,
            service: step1Data.selectedService,
            urgency: step1Data.urgency,
            preferred_date: step2Data.preferredDate || null,
            preferred_time: step2Data.preferredTime || null,
            address: step2Data.address,
            message: step2Data.message,
            status: 'pending',
            created_at: new Date().toISOString()
          }
        ]);

      if (error) throw error;

      isSubmitted = true;
      submitMessage = 'Votre demande de rendez-vous a été envoyée avec succès !';
      
      // Clear session storage
      sessionStorage.removeItem('rdv_step1');
      sessionStorage.removeItem('rdv_step2');
      
    } catch (error) {
      console.error('Error submitting appointment:', error);
      submitMessage = 'Une erreur est survenue. Veuillez réessayer.';
    } finally {
      isSubmitting = false;
    }
  }
  
  function handleBack() {
    navigate('/rdv/step2');
  }
  
  function goHome() {
    navigate('/');
  }
</script>
<GoBack />
<div class="min-h-screen bg-gradient-to-br from-blue-50 to-orange-50 py-12">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      
      {#if !isSubmitted}
        <!-- Header -->
        <div class="text-center mb-12">
          <div class="flex items-center justify-center mb-6">
            <CheckCircle class="w-12 h-12 text-blue-600 mr-4" />
            <h1 class="text-4xl font-bold text-gray-800">Récapitulatif</h1>
          </div>
          <p class="text-xl text-gray-600">Étape 3 sur 3 : Vérifiez vos informations</p>
          
          <!-- Progress bar -->
          <div class="w-full bg-gray-200 rounded-full h-2 mt-6">
            <div class="bg-blue-600 h-2 rounded-full w-full transition-all duration-300"></div>
          </div>
        </div>

        {#if step1Data && step2Data}
          <!-- Service Summary -->
          <div class="bg-white rounded-2xl shadow-xl p-8 mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Votre demande</h2>
            
            <div class="grid md:grid-cols-2 gap-8">
              <!-- Service Details -->
              <div>
                <h3 class="text-lg font-semibold text-gray-700 mb-4 flex items-center">
                  <Calendar class="w-5 h-5 mr-2" />
                  Service demandé
                </h3>
                <div class="bg-blue-50 rounded-lg p-4">
                  <p class="font-semibold text-blue-800 capitalize">{step1Data.selectedService}</p>
                  <p class="text-blue-600 capitalize">Urgence : {step1Data.urgency}</p>
                </div>
              </div>

              <!-- Contact Info -->
              <div>
                <h3 class="text-lg font-semibold text-gray-700 mb-4 flex items-center">
                  <User class="w-5 h-5 mr-2" />
                  Vos coordonnées
                </h3>
                <div class="space-y-2">
                  <p class="flex items-center text-gray-600">
                    <User class="w-4 h-4 mr-2" />
                    {step2Data.firstName} {step2Data.lastName}
                  </p>
                  <p class="flex items-center text-gray-600">
                    <Mail class="w-4 h-4 mr-2" />
                    {step2Data.email}
                  </p>
                  <p class="flex items-center text-gray-600">
                    <Phone class="w-4 h-4 mr-2" />
                    {step2Data.phone}
                  </p>
                </div>
              </div>
            </div>

            <!-- Address -->
            <div class="mt-8">
              <h3 class="text-lg font-semibold text-gray-700 mb-4 flex items-center">
                <MapPin class="w-5 h-5 mr-2" />
                Adresse d'intervention
              </h3>
              <div class="bg-gray-50 rounded-lg p-4">
                <p class="text-gray-700">{step2Data.address}</p>
              </div>
            </div>

            <!-- Date and Time -->
            {#if step2Data.preferredDate || step2Data.preferredTime}
              <div class="mt-8">
                <h3 class="text-lg font-semibold text-gray-700 mb-4 flex items-center">
                  <Calendar class="w-5 h-5 mr-2" />
                  Créneaux souhaités
                </h3>
                <div class="bg-green-50 rounded-lg p-4">
                  {#if step2Data.preferredDate}
                    <p class="text-green-700">Date : {new Date(step2Data.preferredDate).toLocaleDateString('fr-FR')}</p>
                  {/if}
                  {#if step2Data.preferredTime}
                    <p class="text-green-700">Heure : {step2Data.preferredTime}</p>
                  {/if}
                </div>
              </div>
            {/if}

            <!-- Message -->
            {#if step2Data.message}
              <div class="mt-8">
                <h3 class="text-lg font-semibold text-gray-700 mb-4">Description</h3>
                <div class="bg-gray-50 rounded-lg p-4">
                  <p class="text-gray-700">{step2Data.message}</p>
                </div>
              </div>
            {/if}
          </div>

          <!-- Submit Section -->
          <div class="bg-white rounded-2xl shadow-xl p-8 mb-8">
            <div class="text-center">
              <h3 class="text-xl font-semibold text-gray-800 mb-4">Confirmer votre demande</h3>
              <p class="text-gray-600 mb-6">
                En confirmant, vous acceptez que nous vous contactions pour planifier votre intervention.
              </p>
              
              <button
                onclick={submitAppointment}
                disabled={isSubmitting}
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
          </div>
        {/if}

        <!-- Navigation -->
        <div class="flex justify-between items-center">
          <button onclick={handleBack} class="px-6 py-3 text-gray-600 hover:text-gray-800 transition-colors flex items-center">
            <ArrowLeft class="w-5 h-5 mr-2" />
            Retour
          </button>
        </div>

      {:else}
        <!-- Success Message -->
        <div class="text-center">
          <div class="bg-white rounded-2xl shadow-xl p-12">
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
    </div>
  </div>
</div>
