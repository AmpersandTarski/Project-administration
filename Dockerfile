FROM ampersandtarski/prototype-framework:namespaces

# Line to add specific compiler version (from Ampersand image)
# COPY --from=ampersandtarski/ampersand:v5.0.1 /bin/ampersand /usr/local/bin
# Line to copy from local ampersand bin
COPY ./ampersand /usr/local/bin/ampersand
RUN chmod +x /usr/local/bin/ampersand

COPY src /usr/local/project/

# Run ampersand compiler to generated new frontend and backend json model files (in generics folder)
RUN ampersand proto --no-frontend /usr/local/project/ProjectAdministration.adl \
  --proto-dir /var/www/backend \
  --crud-defaults cRud \
  --verbose

RUN ampersand proto --frontend-version Angular --no-backend /usr/local/project/ProjectAdministration.adl \
  --proto-dir /var/www/frontend/src/app/generated \
  --crud-defaults cRud \
  --verbose

WORKDIR /var/www/frontend

RUN npx ng build

# Copy output from frontend build
RUN cp -r /var/www/frontend/dist/prototype-frontend/* /var/www/html
