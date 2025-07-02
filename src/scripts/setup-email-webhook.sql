-- Enable the http extension for making HTTP requests
CREATE EXTENSION IF NOT EXISTS http;

-- Create a function that will send the email via Resend API
CREATE OR REPLACE FUNCTION send_appointment_email()
RETURNS TRIGGER AS $$
DECLARE
  webhook_url TEXT := 'https://api.resend.com/emails';
  resend_api_key TEXT := 're_iGCHd1xy_8yfjz5SCgKTgrXkHaYTZJQ7S'; -- Replace with your actual API key
  admin_email TEXT := 'nour.aboussaoud@esprit.tn'; -- Replace with your email
  urgency_text TEXT;
  urgency_color TEXT;
  email_subject TEXT;
  email_html TEXT;
  response_status INTEGER;
  response_content TEXT;
BEGIN
  -- Format urgency text and color
  CASE NEW.urgency
    WHEN 'urgent' THEN 
      urgency_text := 'URGENT - Intervention dans les 2h';
      urgency_color := '#ef4444';
    WHEN 'rapide' THEN 
      urgency_text := 'RAPIDE - Intervention sous 24h';
      urgency_color := '#f97316';
    WHEN 'planifie' THEN 
      urgency_text := 'PLANIFIÉ - Rendez-vous programmé';
      urgency_color := '#22c55e';
    ELSE 
      urgency_text := NEW.urgency;
      urgency_color := '#6b7280';
  END CASE;

  -- Create email subject
  email_subject := '🚨 Nouvelle demande RDV ' || UPPER(NEW.urgency) || ' - ' || NEW.first_name || ' ' || NEW.last_name;

  -- Create HTML email content
  email_html := '<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle demande RDV - FRD Services</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
    <div style="background: linear-gradient(135deg, #3b82f6, #f97316); padding: 20px; border-radius: 10px 10px 0 0; text-align: center;">
        <h1 style="color: white; margin: 0; font-size: 24px;">🔧 FRD Services - Nouvelle demande RDV</h1>
    </div>
    
    <div style="background: #f8fafc; padding: 20px; border: 1px solid #e2e8f0;">
        <div style="background: ' || urgency_color || '; color: white; padding: 10px; border-radius: 5px; text-align: center; margin-bottom: 20px; font-weight: bold;">
            ' || urgency_text || '
        </div>
        
        <h2 style="color: #1e40af; border-bottom: 2px solid #3b82f6; padding-bottom: 10px;">👤 Informations client</h2>
        <table style="width: 100%; margin-bottom: 20px; border-collapse: collapse;">
            <tr>
                <td style="padding: 8px; font-weight: bold; width: 30%; background: #f8fafc;">Nom complet:</td>
                <td style="padding: 8px;">' || NEW.first_name || ' ' || NEW.last_name || '</td>
            </tr>
            <tr>
                <td style="padding: 8px; font-weight: bold; background: #f1f5f9;">Email:</td>
                <td style="padding: 8px;"><a href="mailto:' || NEW.email || '" style="color: #3b82f6; text-decoration: none;">' || NEW.email || '</a></td>
            </tr>
            <tr>
                <td style="padding: 8px; font-weight: bold; background: #f8fafc;">Téléphone:</td>
                <td style="padding: 8px;"><a href="tel:' || NEW.phone || '" style="color: #3b82f6; text-decoration: none; font-weight: bold;">' || NEW.phone || '</a></td>
            </tr>
        </table>

        <h2 style="color: #1e40af; border-bottom: 2px solid #3b82f6; padding-bottom: 10px;">🔧 Détails de l''intervention</h2>
        <table style="width: 100%; margin-bottom: 20px; border-collapse: collapse;">
            <tr>
                <td style="padding: 8px; font-weight: bold; width: 30%; background: #f8fafc;">Service:</td>
                <td style="padding: 8px; text-transform: capitalize; font-weight: bold; color: #1e40af;">' || NEW.service || '</td>
            </tr>
            <tr>
                <td style="padding: 8px; font-weight: bold; background: #f1f5f9;">Date souhaitée:</td>
                <td style="padding: 8px;">' || COALESCE(TO_CHAR(NEW.preferred_date, 'DD/MM/YYYY'), 'Non spécifiée') || '</td>
            </tr>
            <tr>
                <td style="padding: 8px; font-weight: bold; background: #f8fafc;">Heure souhaitée:</td>
                <td style="padding: 8px;">' || COALESCE(NEW.preferred_time::TEXT, 'Non spécifiée') || '</td>
            </tr>
        </table>

        <h2 style="color: #1e40af; border-bottom: 2px solid #3b82f6; padding-bottom: 10px;">📍 Adresse d''intervention</h2>
        <div style="background: white; padding: 15px; border-radius: 5px; border-left: 4px solid #3b82f6; margin-bottom: 20px; font-weight: bold;">
            ' || REPLACE(NEW.address, E'\n', '<br>') || '
        </div>' ||
        
        CASE 
          WHEN NEW.message IS NOT NULL AND NEW.message != '' THEN
            '<h2 style="color: #1e40af; border-bottom: 2px solid #3b82f6; padding-bottom: 10px;">💬 Message du client</h2>
            <div style="background: white; padding: 15px; border-radius: 5px; border-left: 4px solid #f97316; margin-bottom: 20px;">
                ' || REPLACE(NEW.message, E'\n', '<br>') || '
            </div>'
          ELSE ''
        END || '

        <h2 style="color: #1e40af; border-bottom: 2px solid #3b82f6; padding-bottom: 10px;">ℹ️ Informations système</h2>
        <table style="width: 100%; margin-bottom: 20px; border-collapse: collapse;">
            <tr>
                <td style="padding: 8px; font-weight: bold; width: 30%; background: #f8fafc;">ID de la demande:</td>
                <td style="padding: 8px; font-weight: bold; color: #1e40af;">#' || NEW.id || '</td>
            </tr>
            <tr>
                <td style="padding: 8px; font-weight: bold; background: #f1f5f9;">Date de création:</td>
                <td style="padding: 8px;">' || TO_CHAR(NEW.created_at, 'DD/MM/YYYY à HH24:MI') || '</td>
            </tr>
        </table>

        <div style="text-align: center; margin-top: 30px;">
            <a href="tel:' || NEW.phone || '" style="background: #22c55e; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; margin: 0 10px; display: inline-block; font-weight: bold;">📞 Appeler le client</a>
            <a href="mailto:' || NEW.email || '" style="background: #3b82f6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; margin: 0 10px; display: inline-block; font-weight: bold;">📧 Envoyer un email</a>
        </div>
    </div>
    
    <div style="background: #1f2937; color: white; padding: 15px; border-radius: 0 0 10px 10px; text-align: center; font-size: 12px;">
        <p style="margin: 0; font-weight: bold;">FRD Services Plomberie Chauffage Climatisation</p>
        <p style="margin: 5px 0 0 0;">Spécialiste du dépannage urgent</p>
    </div>
</body>
</html>';

  -- Send email using Resend API
  SELECT status, content INTO response_status, response_content
  FROM http((
    'POST',
    webhook_url,
    ARRAY[
      http_header('Authorization', 'Bearer ' || resend_api_key),
      http_header('Content-Type', 'application/json')
    ],
    'application/json',
    json_build_object(
      'from', 'FRD Services Notifications <onboarding@resend.dev>', -- Replace with your verified domain
      'to', ARRAY[admin_email],
      'subject', email_subject,
      'html', email_html
    )::text
  ));

  -- Log the response
  IF response_status = 200 THEN
    RAISE NOTICE 'Email sent successfully for appointment ID: %. Response: %', NEW.id, response_content;
  ELSE
    RAISE WARNING 'Failed to send email for appointment ID: %. Status: %. Response: %', NEW.id, response_status, response_content;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail the insert
    RAISE WARNING 'Error sending email for appointment ID: %. Error: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS appointment_email_notification ON appointments;

-- Create the trigger
CREATE TRIGGER appointment_email_notification
  AFTER INSERT ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION send_appointment_email();

-- Test the setup (optional - you can comment this out)
-- This will show you if the function was created successfully
SELECT 'Email notification system setup completed successfully!' as status;
