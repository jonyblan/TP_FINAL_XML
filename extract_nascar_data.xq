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

if($error = 0)
  then
      let $series := doc("drivers_standings.xml")//*:series
	  let $season := $series/*:season
      let $filteredDrivers := $season/*:driver[@id]
      let $nascar_data :=
      <nascar_data xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation= "nascar_data.xsd">
          <year>{ data($season/@year) }</year>
          <serie_type>{ data($series/@name) }</serie_type>
          <drivers>
              {
                  for $driver in $filteredDrivers
				  let $data := doc("drivers_list.xml")//*:series/*:season/*:driver[@id = $driver/@id]
				  let $stats := doc("drivers_standings.xml")//*:series/*:season/*:driver[@id = $driver/@id]
                  return local:getDriverInfo($data, $stats)
              }
          </drivers>
      </nascar_data>
      return (file:write("nascar_data.xml", $nascar_data),$nascar_data)
    else
    if ($error = 1)
      then
        let $nascar_data :=
          <nascar_data>
            <error>
              Illegal Arguments error: 
                    Valid years: 2013 to 2024
                    Recieved: Year {$year}, </error>
          </nascar_data>
          return(file:write("nascar_data.xml",$nascar_data),$nascar_data)
    else
    if ($error = 2)
      then
      let $nascar_data :=
          <nascar_data>
            <error>
              Illegal Arguments error: 
                    Valid types: sc, xf, cw, go and mc
                    Recieved:  {$type}, </error>
          </nascar_data>
       return(file:write("nascar_data.xml",$nascar_data),$nascar_data)
     else
        let $nascar_data :=
            <nascar_data>
              <error>
                Illegal Arguments error: 
                    api key was empty 
                    expected arguments (in order): Year Type Api_key</error>
            </nascar_data>
       return(file:write("nascar_data.xml",$nascar_data),$nascar_data)