FROM maven:3.8.2-jdk-11
WORKDIR /ppp_viviendas
COPY . .
RUN mvn clean install
CMD mvn spring-boot:run