def f = new File("unpackaged/settings/Address.settings")

def lst = new XmlSlurper().parse(f)
println "Country ISO Code,Country Integration Value,Country Label,State ISO Code,State Integration Value,State Label"
lst.countriesAndStates.countries.each { c ->
    if(c.states.size() == 0) println "${c.isoCode},${c.integrationValue},${c.label},,,"
    else {
        c.states.each { state ->
            println "${c.isoCode},${c.integrationValue},${c.label},${state.isoCode},${state.integrationValue},${state.label}"
        }
    }
}