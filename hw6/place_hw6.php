<!DOCTYPE html>
<html>
<head><title>Travel and Entertainment Search</title>
	<meta charset="UTF-8">
	<style>
		table{
			border-collapse: collapse;
			border: 3px solid #ddd;
			background-color: #f2f2f2;
			width: 700px;
			position: relative;
			left:280px;
			top:100px;
		}
		.first th{
			font-size: 35px;
			border-bottom: 3px solid #ddd;
			height:40px;
			font-weight: normal;
		}
		.first td{
			height:150px;
			line-height: 160%;
			text-align: left;
		}
		.second th{
			width:500px;
			border: 2px solid #ddd;
		}
		.second td{
			width:500px;
			border: 2px solid #ddd;
			text-align: left;
		}
		.third th,td{
			border: 0px;
			text-align: center;
		}
		.forth th{
			border: 1px solid #ddd;
		}
		.forth td{
			border: 1px solid #ddd;
			text-align: left;
		}
		a:link, a:visited, a:hover, a:active{
			text-decoration: none;
			color: black;
		}
		#map{
			height:200px;
			width:300px;
		}
		.text{
			position: relative;
			left:20px;
		}
	</style>
	<script type="text/javascript">
		function cumulativeOffset(element) {
    		var top = 0, left = 0;
		    do {
		        top += element.offsetTop  || 0;
		        left += element.offsetLeft || 0;
		        element = element.offsetParent;
		    } while(element);

		    return {
		        top: top,
		        left: left
		    };
		};
		function setBackgroundColorOnMouseOver(id){
			document.getElementById(id).style.backgroundColor="#c2c2c2";
		};
		function setBackgroundColorOnMouseOut(id){
			document.getElementById(id).style.backgroundColor="#f2f2f2";
		};
		function clearAll(){
			document.getElementById("keyword").value="";
			document.getElementById("category").value="default";
			document.getElementById("distance").value="";
			document.getElementById("location_custom").value="";
			document.getElementById("location_custom").disabled=true;
			document.getElementById("here").checked=true;
			document.getElementById("display").innerHTML="";
			document.getElementById("reviewTable").innerHTML="";
			document.getElementById("map").style.visibility="hidden";
			document.getElementById("select").style.visibility="hidden";
			curIndex=-1;
		};
		function radioChange(){
			var x = document.getElementById("here");
			if(x.checked == true){
				document.getElementById("location_custom").disabled=true;
			}
			else{
				document.getElementById("location_custom").disabled=false;
			}
		};
		function requestGeo(url){
			xmlhttp=new XMLHttpRequest();
			xmlhttp.open("GET",url,false);
			xmlhttp.send();
			jsonObj=JSON.parse(xmlhttp.responseText);
			return jsonObj;
		};
		function getPlaceDetails(i){
			var myObj=records["results"][i];
			document.getElementById("reviews").value=myObj["place_id"];
			document.getElementById("form").submit();
		};
		function showMaps(i){
			directionsService = new google.maps.DirectionsService();
  			directionsDisplay = new google.maps.DirectionsRenderer();
			destination = new google.maps.LatLng(records["results"][i]["geometry"]["location"]["lat"],records["results"][i]["geometry"]["location"]["lng"]);
			origin=new google.maps.LatLng(lati,long);
	        var map = new google.maps.Map(document.getElementById('map'), {
	          zoom: 15,
	          center: destination
	        });
	        marker = new google.maps.Marker({
	          position: destination,
	          map: map
	        });
	        directionsDisplay.setMap(map);
	        var x=document.getElementById("map");
	        var y=document.getElementById("select");
	        var res=cumulativeOffset(document.getElementById("address"+i));
	        x.style.left=(res.left+0)+"px";
	        x.style.top=(res.top+18)+"px";
	        y.style.left=x.style.left;
	        y.style.top=x.style.top;
	        if(curIndex!=i){
	        	x.style.visibility="visible";
	        	y.style.visibility="visible";
	        	curIndex=i;
	        }
	        else{
	        	x.style.visibility="hidden";
	        	y.style.visibility="hidden";
	        	curIndex=-1;
	        }
		};
		function calcRoute(selectedMode){
			marker.setMap(null);
			var request = {
				origin: origin,
				destination: destination,
				travelMode: google.maps.TravelMode[selectedMode]
			};
			directionsService.route(request, function(response, status) {
				if (status == 'OK') {
					directionsDisplay.setDirections(response);
				}
			});
		};
		function hiddenAll(){
			var reviewTable=document.getElementById("reviewTable");
			var text="";
			text+="<tr><th style='height:70px'>"+name+"</th></tr>";
			text+="<tr><td>click to show reviews</td></tr>";
			text+="<tr><td style='height:40px'><a href='javascript:void(0);' onclick='showReviews()'><img style='width:30px' src='http://cs-server.usc.edu:45678/hw/hw6/images/arrow_down.png'></img></a></td></tr>";
			text+="<tr><td>click to show photos</td></tr>";
			text+="<tr><td style='height:40px'><a href='javascript:void(0);' onclick='showPhotos()'><img style='width:30px' src='http://cs-server.usc.edu:45678/hw/hw6/images/arrow_down.png'></img></a></td></tr>";
			reviewTable.innerHTML=text;
		};
		function showPhotos(){
			var reviewTable=document.getElementById("reviewTable");
			var text="";
			text+="<tr><th style='height:70px'>"+name+"</th></tr>";
			text+="<tr><td>click to show reviews</td></tr>";
			text+="<tr><td style='height:40px'><a href='javascript:void(0);' onclick='showReviews()'><img style='width:30px' src='http://cs-server.usc.edu:45678/hw/hw6/images/arrow_down.png'></img></a></td></tr>";

			text+="<tr><td>click to hide photos</td></tr>";
			text+="<tr><td style='height:40px'><a href='javascript:void(0);' onclick='hiddenAll()'><img style='width:30px' src='http://cs-server.usc.edu:45678/hw/hw6/images/arrow_up.png'></img></a></td></tr>";
			if(photo === undefined || photo.length==0){
				text+="<tr><th style='border:2px solid #ddd;'>No Photos Found</th><tr>";
			}
			else{
				text+="<tr><td><table class='forth' style='background-color:white;border:1px solid #ddd;position:relative;left:130px;top:0px'>";
				var i=0;
				for(;i<5&&i<photo.length;i++){
					text+="<tr><td style='height:450px'><a href='http://cs-server.usc.edu:33738/photo"+i+".png' target='_blank'><img style='width:600px;height:400px;position:relative;left:45px;top:0px' src='http://cs-server.usc.edu:33738/photo"+i+".png'></img></a></td></tr>";
				}
				text+="</table></td></tr>"
			}
			text+="<tr><td style='height:100px'></td></tr>"
			reviewTable.innerHTML=text;
		};
		function showReviews(){
			var reviewTable=document.getElementById("reviewTable");
			var text="";
			text+="<tr><th style='height:70px'>"+name+"</th></tr>";
			text+="<tr><td>click to hide reviews</td></tr>";
			text+="<tr><td style='height:40px'><a href='javascript:void(0);' onclick='hiddenAll()'><img style='width:30px' src='http://cs-server.usc.edu:45678/hw/hw6/images/arrow_up.png'></img></a></td></tr>";
			if(review === undefined || review.length==0){
				text+="<tr><th style='border:2px solid #ddd;'>No Reviews Found</th><tr>";
			}
			else{
				text+="<tr><td><table class='forth' style='background-color:white;border:1px solid #ddd;position:relative;left:130px;top:0px'>";
				var i=0;
				for(;i<5&&i<review.length;i++){
					text+="<tr><th><img style='width:30px' src='"+review[i]["profile_photo_url"]+"'></img>"+review[i]["author_name"]+"</th></tr>";
					text+="<tr><td>"+review[i]["text"]+"</td></tr>";
				}
				text+="</table></td></tr>"
			}
			text+="<tr><td>click to show photos</td></tr>";
			text+="<tr><td style='height:40px'><a href='javascript:void(0);' onclick='showPhotos()'><img style='width:30px' src='http://cs-server.usc.edu:45678/hw/hw6/images/arrow_down.png'></img></a></td></tr>";
			text+="<tr><td style='height:100px'></td></tr>"
			reviewTable.innerHTML=text;
		};
		function initMaps(){
			var pos = {lat: 0, lng: 0};
	        var map = new google.maps.Map(document.getElementById('map'), {
	          zoom: 10,
	          center: pos
	        });
	        var marker = new google.maps.Marker({
	          position: pos,
	          map: map
	        });
		};
	</script>
	<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyASvPHHRiBPCp6jqXdLZHYAKws9kVCJuUI&callback=initMaps">
    </script>
</head>
<body>
<table class="first">
<tr><th><i>Travel and Entertainment Search</i></th></tr>
<tr><td><form method="POST" id="form">
<b>Keyword</b><input type="text" name="keyword" id="keyword" value="" required><br>
<b>Category</b>
<select name="category" id="category">
	<option value="default">default</option>
	<option value="cafe">cafe</option>
	<option value="bakery">bakery</option>
	<option value="restaurant">restaurant</option>
	<option value="beauty_salon">beauty salon</option>
	<option value="casino">casino</option>
	<option value="movie_theater">movie theater</option>
	<option value="lodging">lodging</option>
	<option value="airport">airport</option>
	<option value="train_station">train station</option>
	<option value="subway_station">subway station</option>
	<option value="bus_station">bus station</option>
</select><br>

<script type="text/javascript">
	document.getElementById("keyword").value= "<?php echo isset($_POST["keyword"]) ? $_POST["keyword"] : "" ?>";
	document.getElementById("category").value = "<?php echo isset($_POST["category"]) ? $_POST["category"] : "default" ?>";
</script>

<b>Distance (miles)</b><input type="text" name="distance" id="distance" placeholder="10" value=""><b> from</b>
<div style="display:inline-block;vertical-align: top">
	<input type="radio" name="location" id="here" value="here" onchange="radioChange()">Here<br>
	<input type="radio" name="location" id="other_place" value="" onchange="radioChange()"><input type="text" name="location_custom" id="location_custom" placeholder="location" value="" required disabled>
</div><br>
<input type="hidden" name="json_string" id="json_string" value="">
<input type="hidden" name="reviews" id="reviews" value="">
<input style="position: relative;left:55px;" type="submit" name="search" id="search" value="Search" disabled><button type="button" style="position: relative;left: 58px;"onclick="clearAll()">Clear</button><br>
</form></td></tr>
</table>

<script type="text/javascript">
	document.getElementById("distance").value="<?php echo isset($_POST["distance"]) ? $_POST["distance"] : "" ?>";
	document.getElementById("here").checked=<?php if(!isset($_POST["location"]) || $_POST["location"]=="here"){echo "true";} else{echo "false";} ?>;
	document.getElementById("other_place").checked=<?php if(isset($_POST["location"]) && $_POST["location"]==""){echo "true";}else{echo "false";} ?>;
	document.getElementById("location_custom").value="<?php echo isset($_POST["location_custom"]) ? $_POST["location_custom"] : "" ?>";

	var x=document.getElementById("other_place");
	if(x.checked==true){
		document.getElementById("location_custom").disabled=false;
	}
	var localGeo=requestGeo("http://ip-api.com/json");
	if(localGeo) {
		document.getElementById("search").disabled=false;
	}
	var str_json = JSON.stringify(localGeo);
	document.getElementById("json_string").value=str_json;
</script>

<table class="second" style="background-color: white;width: 1050px;position: relative;left:150px;top:120px;border: 2px solid #ddd" id="display"></table>
<table class="third" style="background-color: white;width: 950px;position: relative;left:150px;top:120px;border: 0px" id="reviewTable"></table>
<div style="position: absolute;left:0;top:0;visibility: hidden;" id="map"></div>
<div style="position: absolute;left:0;top:0;visibility: hidden;" id="select">
	<table class="third" style="width:100px;border: 0px;position: relative;left: 0;top:0">
		<tr><td id='WALKING' style="background-color:#f2f2f2" onmouseover="setBackgroundColorOnMouseOver('WALKING')" onmouseout="setBackgroundColorOnMouseOut('WALKING')"><a href="javascript:void(0);" onclick="calcRoute('WALKING')">Walk there</a></td></tr>
		<tr><td id='BICYCLING' style="background-color:#f2f2f2" onmouseover="setBackgroundColorOnMouseOver('BICYCLING')" onmouseout="setBackgroundColorOnMouseOut('BICYCLING')"><a href="javascript:void(0);" onclick="calcRoute('BICYCLING')">Bike there</a></td></tr>
		<tr><td id='DRIVING' style="background-color:#f2f2f2" onmouseover="setBackgroundColorOnMouseOver('DRIVING')" onmouseout="setBackgroundColorOnMouseOut('DRIVING')"><a href="javascript:void(0);" onclick="calcRoute('DRIVING')">Drive there</a></td></tr>
	</table>
</div>

<?php
if(isset($_POST["search"])):
?>

<?php
$lat="";
$lon="";
$key="AIzaSyBBVXWQdM85XFrhNJNMS4qc-lKdoBDieMk";
$key_nearby="AIzaSyBxyXLzznNuDZAObsKYBy9nIpvkagUKDp4";
if($_POST["location"]=="here"){
	$here=json_decode($_POST["json_string"],true);
	$lat=$here["lat"];
	$lon=$here["lon"];
}
else{
	$addr=urlencode($_POST["location_custom"]);
	$url="https://maps.googleapis.com/maps/api/geocode/json?address=".$addr."&key=".$key;
	$here=json_decode(file_get_contents($url),true);
	$lat=$here["results"][0]["geometry"]["location"]["lat"];
	$lon=$here["results"][0]["geometry"]["location"]["lng"];
}
if(!empty($_POST["distance"])){
	$radius=strval((double)$_POST["distance"] * 1609.344);
}
else{
	$radius="16093.44";
}

$urlSearch="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=".urlencode($lat).",".urlencode($lon)."&radius=".urlencode($radius)."&type=".$_POST["category"]."&keyword=".urlencode($_POST["keyword"])."&key=".$key_nearby;
$json_nearby=file_get_contents($urlSearch);
$nearby=json_decode($json_nearby,true);
$jstring=json_encode($json_nearby);
?>
<?php endif; ?>

<?php
if(!empty($_POST["reviews"])){
	$key_place="AIzaSyCrt-RfennOA6pDC0I9-JtzxGCPKHmPz6w";
	$urlPlace="https://maps.googleapis.com/maps/api/place/details/json?placeid=".$_POST["reviews"]."&key=".$key_place;
	$json_place=file_get_contents($urlPlace);
	$places=json_decode($json_place,true);
	if(isset($places["result"]["photos"])){
		for($i=0;$i<5&&$i<sizeof($places["result"]["photos"]);$i++){
			$reference=$places["result"]["photos"][$i]["photo_reference"];
			$urlPhoto="https://maps.googleapis.com/maps/api/place/photo?maxwidth=750&photoreference=".$reference."&key=".$key_place;
			file_put_contents("photo".$i.".png", file_get_contents($urlPhoto));
		}
	}
	$placeString=json_encode($json_place);
}
?>

<script type="text/javascript">
	var json_records= <?php echo isset($jstring) ? "$jstring" : '""'; ?>;
	lati=<?php echo isset($lat) ? "$lat" : "0"; ?>;
	long=<?php echo isset($lon) ? "$lon" : "0"; ?>;
	curIndex=-1;
 	if(json_records!=""){
		records=JSON.parse(json_records);
		var table=document.getElementById("display");
		if(records["results"].length==0){
			table.innerHTML="<tr><th style='width:950px'>No Records has been found</th></tr>";
			table.style.backgroundColor="#e2e2e2";
		}
		else{
			var i=0;
			var text="";
			text+="<tr><th style='width:50px'>Category</th><th>Name</th><th>Address</th></tr>";
			for(;i<records["results"].length;i++){
				text+="<tr><td style='width:50px'>"+"<img style='width:40px' src='"+records["results"][i]["icon"]+"'></img>"+"</td><td><div class='text'><a href='javascript:void(0);' onclick='getPlaceDetails("+i+")'>"+records["results"][i]["name"]+"</a></div></td><td><div id='address"+i+"' class='text'><a href='javascript:void(0);' onclick='showMaps("+i+")'>"+records["results"][i]["vicinity"]+"</a></div></td></tr>";
			}
			table.innerHTML=text;
			document.getElementById("reviewTable").innerHTML="<tr><td style='height:150px'></td></tr>";
		}
	}
	var json_reviews= <?php echo isset($placeString) ? "$placeString" : '""'; ?>;
	if(json_reviews!=""){
		var object=JSON.parse(json_reviews);
		photo=object["result"]["photos"];
		review=object["result"]["reviews"];
		name=object["result"]["name"];
		hiddenAll();
	}
</script>

</body>
</html>

