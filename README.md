# README

# Debugging

1. Start everything with `docker compose up`
2. Open a new terminal and run `docker attach mimir-backend`
3. Place a `bybebug` statement in the code
4. Interact with the terminal that ran `docker attach mimir-backend`
5. Press c and enter to continue the execution


# FRONTEN11D
# Build and Push image
````bash
cd frontend && docker build -t europe-west1-docker.pkg.dev/mimir-460713/docker-images/frontend . &&
docker push europe-west1-docker.pkg.dev/mimir-460713/docker-images/frontend
````

# Build, publish and deploy directly: 
````bash
cd frontend && docker build -t europe-west1-docker.pkg.dev/mimir-460713/docker-images/frontend . &&
docker push europe-west1-docker.pkg.dev/mimir-460713/docker-images/frontend &&
gcloud run deploy frontend-cloud \
     --platform managed \
     --region europe-west1 \
     --allow-unauthenticated \
     --image europe-west1-docker.pkg.dev/mimir-433819/docker-images/frontend:latest  
````





# BACKEND
# Build and Push image
````bash
docker build -t europe-west1-docker.pkg.dev/mimir-460713/docker-images/backend . && 
docker push europe-west1-docker.pkg.dev/mimir-460713/docker-images/backend
````

# Deploy latest cloud run
````bash
gcloud run deploy backend 
     --platform managed \
     --region europe-west1 \
     --allow-unauthenticated \
     --image europe-west1-docker.pkg.dev/mimir-460713/docker-images/backend:latest  
````

# Build, publish and deploy directly: 
````bash
cd backend && docker build -t europe-west1-docker.pkg.dev/mimir-460713/docker-images/backend . && 
docker push europe-west1-docker.pkg.dev/mimir-460713/docker-images/backend &&
gcloud run deploy backend-cloud \
     --platform managed \
     --region europe-west1 \
     --allow-unauthenticated \
     --image europe-west1-docker.pkg.dev/mimir-460713/docker-images/backend:latest  
````

# Execute migrate job
````bash
gcloud run jobs execute migrate-job \
      --region europe-west1
````

# Deploy migrate job 
````bash
gcloud run jobs create migrate-job \
     --region europe-west1 \
     --image europe-west1-docker.pkg.dev/mimir-460713/docker-images/backend:latest \
     --execute-now
````
