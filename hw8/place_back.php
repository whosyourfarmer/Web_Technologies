<?php
header('Access-Control-Allow-Origin: *');
/*header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
header('Content-type: application/json');*/
?>

<?php
if(isset($_POST["json_string"]) && !empty($_POST["json_string"])):
?>
<?php
$lat="";
$lon="";
$key="AIzaSyBBVXWQdM85XFrhNJNMS4qc-lKdoBDieMk";
//$key_nearby="AIzaSyBxyXLzznNuDZAObsKYBy9nIpvkagUKDp4";
$key_nearby="AIzaSyDZbSlea9jZ-xi57zCrbHjz2R9RCLMgN8Q";
if($_POST["place"]=="here"){
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

echo $json_nearby;
?>
<?php endif; ?>


<?php
$API_KEY = "pRElKY8AJIBwiSBvoLllKefSdpWKPYVWLpLAQj4dVnsS3-WmHqFx7LKi1JR0BsaT-ahgCZx4e5jfKRzmeflEAKUKqPrQqGIpbSr5HI6EUKML7H9FsjNh5XQfuaC4WnYx";
function request($target) {
	try {
        $curl = curl_init();
        if (FALSE === $curl)
            throw new Exception('Failed to initialize');
        //$url = $host . $path . "?" . http_build_query($url_params);
        $url = $target;

        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,  // Capture response.
            CURLOPT_ENCODING => "",  // Accept gzip/deflate/whatever.
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => array(
                "authorization: Bearer " . "pRElKY8AJIBwiSBvoLllKefSdpWKPYVWLpLAQj4dVnsS3-WmHqFx7LKi1JR0BsaT-ahgCZx4e5jfKRzmeflEAKUKqPrQqGIpbSr5HI6EUKML7H9FsjNh5XQfuaC4WnYx",
                "cache-control: no-cache",
            ),
        ));

        $response = curl_exec($curl);

        if (FALSE === $response)
            throw new Exception(curl_error($curl), curl_errno($curl));
        $http_status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        if (200 != $http_status)
            throw new Exception($response, $http_status);

        curl_close($curl);
    } catch(Exception $e) {
        trigger_error(sprintf(
            'Curl failed with error #%d: %s',
            $e->getCode(), $e->getMessage()),
            E_USER_ERROR);
    }
    return $response;
}

if(!empty($_POST["name"])){
    $url = "https://api.yelp.com/v3/businesses/matches/best?"."name=".urlencode($_POST["name"])."&city=".urlencode($_POST["city"])."&state=".$_POST["state"]."&country=".$_POST["country"]."&address1=".urlencode($_POST["address1"]);
    $results = request($url);
    $bestMatch = json_decode($results,true);
    if(sizeof($bestMatch["businesses"])>0 && $bestMatch["businesses"][0]["location"]["zip_code"]==$_POST["zip"])
    {
    	$id = $bestMatch["businesses"][0]["id"];
    	$reviewsUrl = "https://api.yelp.com/v3/businesses/".$id."/reviews";
    	$reviews = request($reviewsUrl);
    	echo $reviews;
    }
    else{
    	echo $results;
    }
}
?>

<?php
if(!empty($_POST["next_page"])){
	//$key_near="AIzaSyBxyXLzznNuDZAObsKYBy9nIpvkagUKDp4";
	$key_near="AIzaSyDZbSlea9jZ-xi57zCrbHjz2R9RCLMgN8Q";
	$url="https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=".$_POST["next_page"]."&key=".$key_near;
	$next=file_get_contents($url);
	echo $next;
}
?>
