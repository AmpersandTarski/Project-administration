FROM prototype:new_frontend

COPY src /usr/local/project/

# Run ampersand compiler to generated new frontend and backend json model files (in generics folder)
RUN ampersand proto --no-frontend /usr/local/project/ProjectAdministration.adl \
  --proto-dir /var/www \
  --crud-defaults cRud \
  --verbose

RUN ampersand proto --frontend-version Angular --no-backend /usr/local/project/ProjectAdministration.adl \
  --proto-dir /var/www/frontend/src/app/generated \
  --crud-defaults cRud \
  --verbose

WORKDIR /var/www/frontend

RUN npx ng build

# Copy output from frontend-v3-builder
RUN cp -r /var/www/frontend/dist/prototype-frontend/* /var/www/public

RUN chown -R www-data:www-data /var/www/data
  # uncomment lines below if customizations are added to default prototype framework
  # && cd /var/www \
  # && composer install --prefer-dist --no-dev --profile