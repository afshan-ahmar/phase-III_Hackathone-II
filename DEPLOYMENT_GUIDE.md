# Phase III Deployment Guide

## Frontend (Vercel) ✅ DEPLOYED
- **URL**: https://frontend-nine-sigma-10.vercel.app
- **Status**: Live and running

## Backend Deployment Instructions

### Option 1: Deploy to Railway (Recommended)

1. **Install Railway CLI**:
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**:
   ```bash
   railway login
   ```

3. **Deploy from local directory**:
   ```bash
   cd New2_phase2_heckathone/backend
   railway init
   railway up
   ```

4. **Add environment variables in Railway dashboard**:
   - `OPENAI_API_KEY`: Your OpenAI API key
   - `SECRET_KEY`: Your JWT secret key (generate a secure random string)
   - `ALGORITHM`: HS256
   - `ACCESS_TOKEN_EXPIRE_MINUTES`: 30

5. **Get your backend URL** from Railway dashboard (e.g., `https://your-app.railway.app`)

### Option 2: Deploy to Render

1. Go to https://render.com
2. Create new Web Service
3. Choose "Deploy from local Git"
4. Point to: `New2_phase2_heckathone/backend`
5. Configure:
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn src.main:app --host 0.0.0.0 --port $PORT`
6. Add environment variables (same as Railway)

### After Backend Deployment

Update frontend to use production backend:

1. Go to Vercel dashboard: https://vercel.com/afshan-ahmars-projects/frontend/settings/environment-variables
2. Add environment variable:
   - **Key**: `NEXT_PUBLIC_API_URL`
   - **Value**: `https://your-backend-url.railway.app` (your actual backend URL)
3. Redeploy frontend:
   ```bash
   cd New2_phase2_heckathone/frontend
   vercel --prod
   ```

## Testing the Deployed Application

1. Visit your frontend URL
2. Register/login with a user account
3. Navigate to `/chat` to test the AI chatbot
4. Try commands like:
   - "Create a todo: Buy groceries"
   - "List all my todos"
   - "Update todo 1 to completed"
   - "Delete todo 2"

## Deployment Files Created

- ✅ `backend/Procfile` - Process configuration
- ✅ `backend/railway.json` - Railway configuration
- ✅ `backend/runtime.txt` - Python version
- ✅ `frontend/vercel.json` - Vercel configuration

All files are ready in your local repository for deployment.
