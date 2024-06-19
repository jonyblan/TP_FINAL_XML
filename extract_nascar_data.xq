xquery version "3.1";

declare variable $error as xs:int external;
declare variable $year as xs:int external;
declare variable $type as xs:string external;

declare function local:getDriverInfo($driverId as xs:string) as element(driver) {
    let $driver := doc("drivers_list.xml")//*:series/*:season/*:driver[@id = $driverId]
    return
        <driver>
            <full_name>{ $driver/@full_name }</full_name>
            <country>{ $driver/@country }</country>
            <birth_date>{ $driver/@birthday }</birth_date>
            <birth_place>{ $driver/@birth_place }</birth_place>
			<rank>{ doc("drivers_standings.xml")//*:series/*:season/*:driver[@id = $driverId]/@rank }</rank>
            {
                if ($driver/*:car/*:manufacturer) then
                    <car>{ ($driver/*:car/*:manufacturer/@name)[1] }</car>
                else ()
            }
            <statistics>
                <season_points>{ doc("drivers_standings.xml")//*:series/*:season/*:driver[@id = $driverId]/@points }</season_points>
                <wins>{ doc("drivers_standings.xml")//*:series/*:season/*:driver[@id = $driverId]/@wins }</wins>
                <poles>{ doc("drivers_standings.xml")//*:series/*:season/*:driver[@id = $driverId]/@poles }</poles>
                <races_not_finished>{ doc("drivers_standings.xml")//*:series/*:season/*:driver[@id = $driverId]/@dnf }</races_not_finished>
                <laps_completed>{ doc("drivers_standings.xml")//*:series/*:season/*:driver[@id = $driverId]/@laps_completed }</laps_completed>
            </statistics>
        </driver>
};

if($error = 0)
  then
    let $standings := doc("drivers_standings.xml")//*:series/*:season/*:driver
    let $filteredDrivers := $standings[@id]
    let $nascar_data :=
    <nascar_data>
        <error></error>
        <year>{ doc("drivers_standings.xml")//*:series/*:season/@year }</year>
        <serie_type>{ doc("drivers_standings.xml")//*:series/@name }</serie_type>
        <drivers>
            {
                for $driver in $filteredDrivers
                return local:getDriverInfo($driver/@id)
            }
        </drivers>
    </nascar_data>
    return (file:write("nascar_data.xml", $nascar_data),$nascar_data)
  else
    let $nascar_data :=
      <nascar_data>
        <error>
          Illegal Arguments error: 
                Valid years: 2013 to 2024
                Valid types: sc, xf, cw, go, mc
                Recieved: Year {$year}, Type {$type} </error>
      </nascar_data>
    return(file:write("nascar_data.xml",$nascar_data),$nascar_data)