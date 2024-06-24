declare variable $error as xs:int external;
declare variable $year as xs:int external;
declare variable $type as xs:string external;

declare function local:getDriverInfo($data, $stats) as element(driver) {
        <driver>
            <full_name>{ data($data/@full_name) }</full_name>
            <country>{ data($data/@country) }</country>
            <birth_date>{ data($data/@birthday) }</birth_date>
            <birth_place>{ data($data/@birth_place) }</birth_place>
			<rank>{ data($stats/@rank) }</rank>
            {
                if ($data/*:car/*:manufacturer) then
                    <car>{ data(($data/*:car/*:manufacturer/@name)[1]) }</car>
                else ()
            }
            <statistics>
                <season_points>{ data($stats/@points) }</season_points>
                <wins>{ data($stats/@wins) }</wins>
            </statistics>
        </driver>
};

declare function local:apiError() as element(error) {
	<error>
		Illegal Arguments error: 
		API Key missing 
		Declare environment variable SPORTRADAR_API with command: 
		$ export SPORTRADAR_API="*valid api key*" /// 
	</error>
};

declare function local:yearError() as element(error) {
	<error>
		Illegal Arguments error: 
		Valid years: 2013 to 2024
		Recieved: Year {$year} /// 
	</error>
};

declare function local:typeError() as element(error) {
	<error>
		Illegal Arguments error: 
		Valid types: sc, xf, cw, go and mc
		Recieved: {$type} /// 
	</error>
};

if($error = 1)
  then
      let $series := doc("drivers_standings.xml")//*:series
	  let $season := $series/*:season
      let $filteredDrivers := $season/*:driver[@id]

	  return
      <nascar_data xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation= "nascar_data.xsd">
          <year>{ data($season/@year) }</year>
          <serie_type>{ data($series/@name) }</serie_type>
          <drivers>
              {
                  for $driver in $filteredDrivers
				  let $data := doc("drivers_list.xml")//*:series/*:season/*:driver[@id = $driver/@id]
				  let $stats := $season/*:driver[@id = $driver/@id]
                  return local:getDriverInfo($data, $stats)
              }
          </drivers>
      </nascar_data>

else 
	<nascar_data xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation= "nascar_data.xsd">
	{
		if($error mod 2 = 0)
		then
			if($error mod 3 = 0)
			then
				if($error mod 5 = 0)
				then
					(local:apiError(), local:yearError(), local:typeError())
				else
					(local:apiError(), local:yearError())
			else 
				if($error mod 5 = 0)
				then
					(local:apiError(), local:typeError())
				else
					local:apiError()
		else
		if($error mod 3 = 0)
		then
			if($error mod 5 = 0)
			then
				(local:yearError(), local:typeError())
			else
				local:yearError()
		else
			local:typeError()
	}
	</nascar_data>