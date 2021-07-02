FROM openjdk:11

# Download OTP 2.0.0.
ADD https://repo1.maven.org/maven2/org/opentripplanner/otp/2.0.0/otp-2.0.0-shaded.jar /home/otp.jar

# Download SEPTA data from June 27, 2021.
ADD https://github.com/septadev/GTFS/releases/download/v202106271/gtfs_public.zip /home/septa.zip

# This archive has two files: google_rail.zip and google_bus.zip.
RUN ["unzip", "/home/septa.zip", "-d", "/home/"]

# For OTP to recognize them, they must both be renamed so they have ".gtfs.zip" as their extension.
RUN ["mv", "/home/google_rail.zip", "/home/septa_rail.gtfs.zip"]
RUN ["mv", "/home/google_bus.zip", "/home/septa_bus.gtfs.zip"]

# Use OTP to preemptively build the graph from this SEPTA data.
RUN ["java", "-jar", "/home/otp.jar", "--build", "--save", "/home/"]

# Now that the graph is built, we can delete these files to make a smaller image.
RUN ["rm", "/home/septa.zip", "/home/septa_rail.gtfs.zip", "/home/septa_bus.gtfs.zip"]

# This is OTP's default port.
EXPOSE 8080

# Set our entrypoint to start OTP.
ENTRYPOINT ["java", "-jar", "/home/otp.jar", "--load", "/home/"]