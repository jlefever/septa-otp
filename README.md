# SEPTA OpenTripPlanner

This is an example [OpenTripPlanner](https://www.opentripplanner.org/) server. It uses data publicly available from [SEPTA](https://github.com/septadev/GTFS).

## Usage

Build the Docker image and run.

```
docker build . -t septa-otp
docker run -p 8080:8080 septa-otp
```

Check out the OpenTripPlanner API docs [here](http://dev.opentripplanner.org/apidoc/2.0.0/index.html).

## Example

Once you have an instance running locally, you can get a list of stops from:

```
http://localhost:8080/otp/routers/default/index/stops
```

Say you are living in Levittown, PA and would like to get to 34th Street Station (the closest train station to Drexel's CCI). You want to leave at 5:00PM on July 1st, 2021. Here, `2:90702` and `1:19026` are the IDs of Levittown and 34th Street Station, respectively.

```
http://localhost:8080/otp/routers/default/plan?&mode=TRANSIT&fromPlace=2:90702&toPlace=1:19026&date=2021-07-01&time=5:00PM
```

The most useful part of this response is the list of [itineraries](http://dev.opentripplanner.org/apidoc/2.0.0/json_ApiItinerary.html). Each itinerary describes how to get from point A to point B. If you want to see all possible itineraries for the whole day, we can start at 12:00AM and look over the next 24 hours (or 86,400 seconds).

```
http://localhost:8080/otp/routers/default/plan?&mode=TRANSIT&fromPlace=2:90702&toPlace=1:19026&date=2021-07-01&time=12:00AM&searchWindow=86400
```

Finally, the parameter `showIntermediateStops=true` will show us all the stops between our source and destination which might be useful in some cases.

See the responses of these HTTP requests in the `examples/` directory. You can check out the rest of the parameters for trip planning [here](http://dev.opentripplanner.org/apidoc/2.0.0/resource_PlannerResource.html).
