var request = require('sync-request');
var express = require('express');
var app = express();

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get('/', function(req, res){
	if(req.query.json_string != undefined && req.query.json_string.length > 0){
		var lat = "";
		var lon = "";
		var key = "AIzaSyBBVXWQdM85XFrhNJNMS4qc-lKdoBDieMk";
		var key_nearby="AIzaSyDZbSlea9jZ-xi57zCrbHjz2R9RCLMgN8Q";
		var radius = "";
		if(req.query.place=="here"){
			var here = JSON.parse(req.query.json_string);
			lat = here.lat;
			lon = here.lon;
		}
		else{
			var addr = encodeURIComponent(req.query.location_custom);
			var url = "https://maps.googleapis.com/maps/api/geocode/json?address="+addr+"&key="+key;
			var requ = request("GET",url);
			var here = JSON.parse(requ.getBody('utf8'));
			lat = here.results[0].geometry.location.lat;
			lon = here.results[0].geometry.location.lng;
		}
		if(req.query.distance.length > 0){
			radius = (parseInt(req.query.distance) * 1609.344).toString();
		}
		else{
			radius = "16093.44";
		}
		var category = req.query.category;
		var keyword = encodeURIComponent(req.query.keyword);
		var urlSearch="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+encodeURIComponent(lat)+","+encodeURIComponent(lon)+"&radius="+encodeURIComponent(radius)+"&type="+category+"&keyword="+keyword+"&key="+key_nearby;
		var nearby_req = request("GET",urlSearch);
		var json_nearby = nearby_req.getBody('utf8');
		nearby=JSON.parse(json_nearby);
		res.send(json_nearby);
	}
	if(req.query.next_page != undefined && req.query.next_page.length > 0){
		var key_near="AIzaSyDZbSlea9jZ-xi57zCrbHjz2R9RCLMgN8Q";
		var url="https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken="+req.query.next_page+"&key="+key_near;
		var next_req = request("GET",url);
		var next = next_req.getBody("utf8");
		res.send(next);
	}
	if(req.query.name.length != undefined && req.query.name.length > 0){
		'use strict';
		const yelp = require('yelp-fusion');
		const apiKey = "pRElKY8AJIBwiSBvoLllKefSdpWKPYVWLpLAQj4dVnsS3-WmHqFx7LKi1JR0BsaT-ahgCZx4e5jfKRzmeflEAKUKqPrQqGIpbSr5HI6EUKML7H9FsjNh5XQfuaC4WnYx";
		const client = yelp.client(apiKey);
		const searchRequest = {
			name: req.query.name,
			address1: req.query.address1,
			city: req.query.city,
			state: req.query.state,
			country: req.query.country
		};

		client.businessMatch('best', searchRequest).then(response => {
			var bestMatch = response.jsonBody;
			if(bestMatch.businesses.length > 0 && bestMatch.businesses[0].location.zip_code==req.query.zip){
				var id = bestMatch.businesses[0].id;
				client.reviews(id).then(results => {
					res.send(JSON.stringify(results.jsonBody));
				}).catch(e => {
					console.log(e);
					res.send(JSON.stringify({}));
				});
			}
			else{
				res.send(JSON.stringify(bestMatch));
			}
		}).catch(e => {
			console.log(e);
			res.send(JSON.stringify({}));
		});
	}
});

app.listen(3000);