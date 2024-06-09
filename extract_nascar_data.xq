xquery version "3.1";

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
            {
                if ($driver/*:car/*:manufacturer) then
                    <car>{ $driver/*:car/*:manufacturer/@name }</car>
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

let $standings := doc("drivers_standings.xml")//*:series/*:season/*:driver
let $filteredDrivers := $standings[@id]

let $nascar_data :=
<nascar_data>
    <year>{ $year }</year>
    <serie_type>{ $type }</serie_type>
    <drivers>
        {
            for $driver in $filteredDrivers
            return local:getDriverInfo($driver/@id)
        }
    </drivers>
</nascar_data>

return (
    file:write("nascar_data.xml", $nascar_data),
    $nascar_data
)
