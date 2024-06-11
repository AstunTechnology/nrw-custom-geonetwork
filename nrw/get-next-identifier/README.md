# Instructions for creating get-next-identifier pages

## PostgreSQL

We're just using this to sanity-check the value from ElasticSearch now

Create the following query to return the 5 or 6 numeric characters from a standard formatted UUID and output them in descending order:

	select uuid, substring(uuid from'\d{5,}')::numeric as identifier from metadata where length(uuid) < 13 order by identifier desc;


## ElasticSearch

Load the three included ndjson files as Kibana saved objects. This should add an additional field to the `gn-records` index pattern called `Identifier`, a visualisation called `newmaxid` and a dashboard called `get-next-identifier`.

If not, the additional field in the gn-records index pattern should be named Identifier and have this as the value:

```
def uuid = doc['uuid'].value;
if (uuid.length() > 12) {
    emit(1.0);
} else {
    int stripped_uuid_index = uuid.lastIndexOf('_');
    String stripped_uuid = uuid.substring(stripped_uuid_index+1);
    if (stripped_uuid.startsWith("DS")) {
        double numeric_uuid = Double.parseDouble(stripped_uuid.substring(2));
        emit(numeric_uuid + 1.0);
    } else {
        emit(Double.parseDouble(uuid.substring(stripped_uuid_index+1)));
    }
    
}
```

newmaxid should be a classic kibana aggregation metric that returns the max of the above Identifier.

get-next-identifier should be a dashboard containing the above metric with an auto-refreshing interval of 5 seconds. Get a sharing link as a saved object, with no filter bar, using the short url and public url.


## GeoNetwork

Paste the iframe code above into `nrw/geonetwork/catalog/templates/editor/new-metadata-horizontal.html`

