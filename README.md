# Plombier - Plumbing Service Booking App

A modern web application for booking plumbing services with integrated PayPal payments, built with Svelte, TypeScript, and Vite.

## Features

- Service booking flow (Dépannage, Installation, Entretien)
- Dynamic pricing calculation
- PayPal payment integration
- Responsive design with Tailwind CSS
- Supabase backend integration

## Environment Setup

### Local Development

1. Copy the environment example file:
```bash
cp .env.example .env.local
```

2. Update `.env.local` with your actual PayPal Client ID:
```
VITE_PAYPAL_CLIENT_ID=your_actual_paypal_client_id_here
```

### Production Deployment on Vercel

1. **Push your code to GitHub** (make sure `.env.local` is not committed)

2. **Deploy to Vercel:**
   - Connect your GitHub repository to Vercel
   - Or use Vercel CLI: `vercel --prod`

3. **Set Environment Variables in Vercel:**
   - Go to your Vercel project dashboard
   - Navigate to Settings → Environment Variables
   - Add the following variable:
     - **Name:** `VITE_PAYPAL_CLIENT_ID`
     - **Value:** Your PayPal Client ID (e.g., `AY8Fd1RgX98ZYcJMBxAWPFIpsMaJCKWfBfS4g6pNjpSLSXzzjAIvm85SHBeJMhGwcAo9yJJBFZSZYobl`)
     - **Environment:** Production (and Preview if needed)

4. **Redeploy** your application after setting the environment variables

## PayPal Configuration

### Getting PayPal Client ID

1. Go to [PayPal Developer Dashboard](https://developer.paypal.com/)
2. Create a new app or use existing one
3. Copy the Client ID from your app settings
4. For production, make sure to use the Live Client ID (not Sandbox)

### Environment Variables

- `VITE_PAYPAL_CLIENT_ID`: Your PayPal application's Client ID

**Important:** Never commit your actual PayPal Client ID to version control. Always use environment variables.

## Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Deployment Checklist

- [ ] PayPal Client ID moved to environment variables
- [ ] Environment variables set in Vercel dashboard
- [ ] Code pushed to GitHub
- [ ] Vercel deployment successful
- [ ] PayPal payments working in production

## Technical Stack

- **Frontend:** Svelte 5 + TypeScript
- **Styling:** Tailwind CSS
- **Build Tool:** Vite
- **Backend:** Supabase
- **Payments:** PayPal SDK
- **Deployment:** Vercel

## Troubleshooting

### PayPal Not Loading
- Check that `VITE_PAYPAL_CLIENT_ID` is set correctly
- Verify the Client ID is for the correct environment (Live vs Sandbox)
- Check browser console for errors

### Environment Variables Not Working
- Make sure environment variable names start with `VITE_`
- Restart development server after changing `.env.local`
- For Vercel, redeploy after setting environment variables
