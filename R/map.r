# map.R
# Time-stamp: <16 Nov 2016 21:21:27 c:/x/rpack/pals/R/map.R>
# Copyright: Kevin Wright, 2016. License: GPL-3.

#' Test palette with a ColorBrewer map.
#'
#' Display a palette on a choropleth map similar to ColorBrewer.
#' 
#' Broad bands of color are easy to distinguish.
#' Does the palette allow visibility of outlier counties in the larger regions?
#' Does the palette allow identification of colors when the
#' pattern is more complex (as in the lower left corner of the map)?
#'
#' Notes. The map shown by the ColorBrewer website is an SVG here
#' https://github.com/axismaps/colorbrewer/tree/master/map/map.svg
#' which contains the class identifier for each polygon, for 3 to 12 classes.
#' Unfortunately, the polygons have no other identification (e.g. FIPS, county name).
#' We used the identify.map function in R to manually define the classes
#' similar to the 12-class map of ColorBewer.
#' This proved to be too tedious to do more than once, so our maps of 1-11 classes were
#' created by combining classes from the 12-class map.  The ColorBrewer website
#' sometimes used this strategy to combine classes, but not always.
#' The 'outlier' counties and 'random region' in this version are very similar to
#' the 12-region map of ColorBrewer, but there are a few differences, mostly
#' intentional.
#' Also, the map projection used here is different from ColorBrewer.
#' 
#' @param pal A palette function or a vector of colors.
#' 
#' @param n Number of colors to return.
#' 
#' @return None.
#' 
#' @import maps
#' @import mapproj
#' @export
#' @examples
#' pal.map()
#' pal.map(viridis)
#' 
#' @author Kevin Wright
#' 
#' @references
#' http://www.personal.psu.edu/cab38/Pub_scans/Brewer_pubs.html
#' Map based on www.ColorBrewer.org, by Cynthia A. Brewer, Penn State.
#' 
pal.map <- function(pal=brewer.paired, n=12) {

  if(n > 12) {
    message("Re-setting n=12.")
    n = 12
  }
  
  if(is.function(pal))
    pal <- pal(n)

  requireNamespace("maps")
  co.names <- maps::map("county",
                  xlim=c(-100,-79), ylim=c(29.5,42), mar=c(0,0,0,0), plot=FALSE)$names
  co.fips <- maps::county.fips$fips[match(co.names, maps::county.fips$polyname)]

  # Each row is a region. Column number is the number of classes, 1..12
  # Each element is the class for the region
  # region number:        1  2  3  4  5  6  7  8  9 10 11 12
  regionclass <- matrix(c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2,
                          1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3,
                          1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4,
                          1, 1, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5,
                          1, 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 6,
                          1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 6, 7,
                          1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8,
                          1, 2, 3, 3, 4, 5, 6, 5, 7, 7, 8, 9,
                          1, 2, 3, 4, 4, 5, 6, 6, 7, 8, 9, 10,
                          1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 10, 11,
                          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), nrow=12, byrow=TRUE)

  # The codes for ColorBrewer county colors seem to be here:
  # colorbrewer-master/map/map.svg
  # For example, one line seems to label a county
  # q2 for 12 level-palette
  # q2 for 11 level-palette
  # q2-12 q2-11 q2-10 q2-9 q1-8 q1-6 q1-5 q0-3 q1-7 q1-4
  # https://www.w3.org/TR/SVG/paths.html#PathData
  # <path m=move to, l=line, z=close>
  # There doesn't seem to be an easy way to read an svg file
  # lib(rsvg)
  # setwd("c:/x/colorbrewer-master/map/")
  # Draw image
  # rsvg_png("map.svg", "test.png", width=1000, height=1000)
  # Read raw data. No class info included
  # co <- rsvg_raw("c:/x/colorbrewer-master/map/map.svg")

  mapcols <- rep(c('white'), length=length(co.names))

  # The numbers below are FIPS codes for each county, classed into regions
  
  # lt blue
  reg1 <- c(20009, 20025, 20033, 20047, 20051, 20057, 20065, 20083, 20089,
            20097, 20123, 20135, 20137, 20141, 20145, 20147, 20163, 20165,
            20167, 20183, 20195, 31001, 31003, 31009, 31011, 31019, 31021,
            31023, 31035, 31037, 31039, 31041, 31047, 31053, 31055, 31059,
            31061, 31065, 31071, 31073, 31077, 31079, 31081, 31083, 31093,
            31099, 31109, 31115, 31119, 31121, 31125, 31129, 31137, 31141,
            31143, 31151, 31153, 31155, 31159, 31163, 31167, 31169, 31175,
            31177, 31181, 31183, 31185)
  mapcols[match(reg1,co.fips)] <- pal[regionclass[1,n]]

  # blue
  reg2 <- c(19001, 19003, 19009, 19029, 19039, 19049, 19053, 19071, 19077,
            19085, 19099, 19117, 19121, 19123, 19125, 19129, 19137, 19145,
            19153, 19155, 19157, 19159, 19165, 19173, 19175, 19181, 19185,
            20005, 20007, 20013, 20015, 20017, 20027, 20029, 20041, 20043,
            20053, 20061, 20077, 20079, 20085, 20095, 20105, 20113, 20115,
            20117, 20127, 20131, 20143, 20149, 20151, 20155, 20157, 20159,
            20161, 20169, 20173, 20177, 20185, 20197, 20201, 29003, 29005,
            29075, 29081, 29087, 29147,29227, 31025, 31067, 31095, 31097,
            31127,31131, 31133, 31147, 40003, 40009, 40011, 40015, 40017,
            40031, 40033, 40039, 40043, 40045, 40051, 40055, 40057, 40059,
            40065, 40073, 40075, 40093, 40129, 40141, 40149, 40151, 40153,
            48009, 48023, 48155, 48197, 48275, 48485, 48487)
  mapcols[match(reg2,co.fips)] <- pal[regionclass[2,n]]

  # lt green
  reg3 <- c(17001, 17011, 17037, 17057, 17067, 17071, 17073, 17095, 17099,
            17103, 17109, 17123, 17131, 17143, 17155, 17161, 17175,17187,
            17195, 17203, 19007, 19031, 19045, 19051, 19057, 19087,19095,
            19101, 19103, 19107, 19111, 19115, 19135, 19139, 19163, 19177,
            19179, 19183, 20001, 20003, 20019, 20031, 20035, 20045, 20049,
            20059, 20073, 20087, 20091, 20103, 20111, 20121, 20125, 20133,
            20139, 20191, 20205, 20207, 20209, 29001, 29021,29025, 29033,
            29041, 29045, 29047, 29049, 29061, 29063, 29079, 29095, 29103,
            29111, 29115, 29117, 29121, 29127, 29129, 29165, 29171, 29177,
            29197, 29199, 29205, 29211, 40019, 40027, 40037, 40047, 40049,
            40053, 40071, 40081, 40083, 40087, 40103, 40105, 40107, 40109,
            40111, 40113, 40117, 40119, 40125, 40133, 40137, 40143, 40147)
  mapcols[match(reg3,co.fips)] <- pal[regionclass[3,n]]

  reg4 <- c(5007, 5009, 5015, 5033, 5047, 5071, 5087, 5089, 5101, 5131, 5143,
            20001, 20003, 20011, 20021, 20037, 20099, 20107, 20133, 29007,
            29009, 29011, 29013, 29015, 29019, 29027, 29029, 29037, 29039,
            29043, 29051, 29053, 29055, 29057, 29059, 29065, 29067, 29071,
            29073, 29077, 29083, 29085, 29089, 29091, 29097, 29101, 29105,
            29107, 29109, 29119, 29125, 29131, 29135, 29137, 29139, 29141,
            29145, 29151, 29153, 29159, 29161, 29163, 29167, 29169, 29173,
            29175, 29185, 29195, 29203, 29209, 29213, 29215, 29217, 29225,
            29229, 40001, 40005, 40013, 40021, 40029, 40035, 40041, 40061,
            40063, 40067, 40069, 40079, 40085, 40091, 40095, 40097, 40099,
            40101, 40115, 40121, 40123, 40131, 40135, 40145, 48077, 48097,
            48147, 48181, 48337)
  mapcols[match(reg4,co.fips)] <- pal[regionclass[4,n]]

  # pink
  reg5 <- c(5005, 5011, 5013, 5019, 5023, 5025, 5029, 5039, 5045, 5049, 5051,
            5057, 5061, 5059, 5063, 5065, 5067, 5075, 5081, 5083, 5085, 5097,
            5099, 5103, 5105, 5109, 5113, 5115, 5119, 5121, 5125, 5127, 5129,
            5133, 5135, 5137, 5141, 5145, 5149, 17009, 17013, 17017, 17031,
            17039, 17043, 17053, 17061, 17063, 17075, 17083, 17089, 17091,
            17093, 17105, 17107, 17113, 17117, 17119, 17125, 17129, 17133,
            17135, 17137, 17149, 17163, 17167, 17169, 17171, 17179, 17197,
            18049, 18073, 18085, 18089, 18091, 18099, 18111, 18127, 18131,
            18141, 18149, 18181, 26021, 29035, 29093, 29099, 29113, 29123,
            29149, 29179, 29181, 29183, 29187, 29189, 29510, 29219, 29221,
            29223, 40023, 40077, 40089, 40127, 48037, 48277, 48387)
  mapcols[match(reg5,co.fips)] <- pal[regionclass[5,n]]

  # red
  reg6 <- c(5001, 5003, 5017, 5021, 5031, 5035, 5037, 5041, 5043, 5053, 5055,
            5069, 5077, 5079, 5093, 5095, 5107, 5111, 5117, 5123, 5147, 17005,
            17019, 17021, 17025, 17027, 17029, 17035, 17041, 17045, 17049,
            17051, 17055, 17077, 17081, 17115, 17121, 17139, 17145, 17147,
            17157, 17173, 17183, 17189, 18001, 18003, 18007, 18009, 18015,
            18017, 18023, 18033, 18035, 18045, 18053, 18067, 18069, 18075,
            18095, 18103, 18107, 18113, 18135, 18157, 18159, 18165, 18169,
            18171, 18177, 18179, 18183, 28011, 28151, 29017, 29023, 29031,
            29069, 29143, 29155, 29157, 29186, 29207, 39003, 39005, 39007,
            39011, 39013, 39017, 39019, 39021, 39023, 39027, 39029, 39031,
            39033, 39035, 39037, 39039, 39041, 39047, 39049, 39051, 39055,
            39057, 39059, 39063, 39065, 39067, 39069, 39075, 39077, 39081,
            39083, 39085, 39089, 39091, 39093, 39095, 39097, 39099, 39101,
            39103, 39107, 39109, 39113, 39117, 39125, 39129, 39133, 39135,
            39137, 39139, 39143, 39147, 39149, 39151, 39153, 39155, 39157,
            39159, 39161, 39165, 39169, 39171, 39173, 39175, 42003, 42005,
            42007, 42019, 42031, 42039, 42073, 42085, 42121, 42125, 42129,
            54009, 54029, 54069)
  mapcols[match(reg6,co.fips)] <- pal[regionclass[6,n]]

  # peach
  reg7 <- c(17003, 17023, 17033, 17047, 17059, 17065, 17069, 17079, 17087,
            17101, 17127, 17151, 17153, 17159, 17165, 17181, 17185, 17191,
            17193, 17199, 18005, 18011, 18013, 18021, 18027, 18029, 18031,
            18037, 18041, 18047, 18051, 18055, 18057, 18059, 18063, 18065,
            18071, 18077, 18079, 18081, 18083, 18093, 18097, 18101, 18105,
            18109, 18115, 18117, 18119, 18121, 18125, 18129, 18133, 18137,
            18139, 18143, 18145, 18153, 18155, 18161, 18163, 18167, 18173,
            18175, 21007, 21015, 21037, 21039, 21041, 21055, 21077, 21083,
            21101, 21105, 21117, 21139, 21145, 21223, 21225, 24023, 29133,
            29201, 39001, 39009, 39015, 39025, 39045, 39053, 39061, 39071,
            39073, 39079, 39105, 39111, 39115, 39119, 39121, 39127, 39131,
            39141, 39145, 39163, 39167, 42051, 42059, 42111, 54001, 54013,
            54017, 54021, 54023, 54031, 54033, 54035, 54041, 54049, 54051,
            54057, 54061, 54073, 54077, 54083, 54085, 54087, 54091, 54093,
            54095, 54097, 54103, 54105, 54107 )
  mapcols[match(reg7,co.fips)] <- pal[regionclass[7,n]]

  # orange
  reg8 <- c(18019, 18025, 18043, 18061, 18123, 18147, 21005, 21011, 21017,
            21019, 21021, 21023, 21025, 21027, 21029, 21031, 21033, 21035,
            21043, 21047, 21049, 21059, 21063, 21065, 21067, 21069, 21071,
            21073, 21075, 21079, 21081, 21085, 21089, 21091, 21093, 21097,
            21103, 21107, 21111, 21113, 21115, 21123, 21127, 21129, 21135,
            21141, 21143, 21149, 21151, 21153, 21155, 21157, 21159, 21161,
            21163, 21165, 21167, 21173, 21175, 21177, 21179, 21181, 21183,
            21185, 21187, 21191, 21195, 21197, 21201, 21205, 21209, 21211,
            21215, 21219, 21221, 21229, 21233, 21237, 21239, 22035, 22065,
            22107, 22123, 28015, 28021, 28027, 28029, 28033, 28043, 28049,
            28053, 28055, 28063, 28071, 28083, 28093, 28107, 28119, 28125,
            28133, 28135, 28137, 28143, 28149, 28161, 28163, 39087, 47005,
            47017, 47033, 47045, 47047, 47053, 47069, 47075, 47079, 47083,
            47095, 47097, 47113, 47125, 47131, 47157, 47161, 47167, 47183,
            51005, 51015, 51017, 51091, 51163, 51165, 54005, 54007, 54011,
            54015, 54019, 54025, 54039, 54043, 54053, 54045, 54059, 54067,
            54071, 54075, 54079, 54081, 54089, 54099, 54101, 54109)
  mapcols[match(reg8,co.fips)] <- pal[regionclass[8,n]]

  # plum
  reg9 <- c(1033, 1059, 1075, 1077, 1093, 21001, 21003, 21009, 21013, 21045,
            21051, 21053, 21057, 21061, 21087, 21095, 21099, 21109, 21119,
            21121, 21125, 21131, 21133, 21137, 21147, 21169, 21171, 21189,
            21193, 21199, 21203, 21207, 21213, 21217, 21227, 21231, 21235,
            22005, 22029, 22033, 22037, 22047, 22057, 22063, 22071, 22075,
            22077, 22087, 22089, 22091, 22093, 22095, 22103, 22105, 22117,
            22121, 22125, 28001, 28003, 28005, 28009, 28013, 28017, 28025,
            28031, 28035, 28037, 28045, 28047, 28057, 28065, 28067, 28073,
            28077, 28081, 28085, 28091, 28095, 28109, 28113, 28115, 28117,
            28131, 28139, 28141, 28145, 28147, 28157, 37003, 37005, 37009,
            37011, 37027, 37057, 37059, 37067, 37081, 37097, 37115, 37121,
            37151, 37157, 37169, 37171, 37189, 37193, 37197, 37199, 47001,
            47013, 47019, 47021, 47023, 47025, 47027, 47029, 47035, 47037,
            47039, 47041, 47043, 47049, 47057, 47059, 47063, 47067, 47071,
            47073, 47077, 47081, 47085, 47087, 47089, 47091, 47093, 47099,
            47101, 47109, 47111, 47119, 47129, 47133, 47135, 47137, 47141,
            47147, 47149, 47151, 47159, 47163, 47165, 47169, 47171, 47173,
            47179, 47181, 47187, 47189, 51009, 51011, 51019, 51021, 51023,
            51027, 51031, 51035, 51045, 51051, 51063, 51067, 51071, 51077,
            51083, 51089, 51105, 51121, 51125, 51141, 51143, 51155, 51161,
            51167, 51169, 51173, 51185, 51191, 51195, 51197, 54047, 54055,
            54063)
  mapcols[match(reg9,co.fips)] <- pal[regionclass[9,n]]

  # purple
  reg10 <- c(1009, 1019, 1043, 1049, 1055, 1057, 1063, 1071, 1073, 1079, 1083,
             1089, 1095, 1103, 1107, 1115, 1119, 1125, 1127, 1133, 13011,
             13015, 13047, 13055, 13057, 13067, 13083, 13085, 13111, 13115,
             13117,13119, 13123, 13129, 13137, 13139, 13143, 13187, 13213,
             13223, 13227, 13233, 13241, 13257, 13281, 13291, 13295, 13311,
             13313, 28007, 28019, 28023, 28051, 28061, 28069, 28075, 28079,
             28087, 28089, 28097, 28099, 28101, 28103, 28105, 28121, 28123,
             28127, 28129, 28155, 28159, 37001, 37007, 37021, 37023, 37025,
             37033, 37035, 37037, 37039, 37043, 37045, 37047, 37051,37063,
             37071, 37075, 37085, 37087, 37089, 37093, 37099, 37105, 37109,
             37111, 37113, 37119, 37123, 37125, 37135, 37149, 37153, 37155,
             37159, 37161, 37165,37167, 37173, 37175, 37179, 45021,45023,
             45025, 45031, 45033, 45039, 45041,45045, 45051, 45055, 45057,
             45059, 45061, 45067, 45069, 45073, 45077, 45083, 45085, 45087,
             45091, 47003, 47007, 47009, 47011, 47015, 47031, 47051, 47055,
             47061, 47065, 47103, 47105, 47107, 47115, 47117, 47121, 47123,
             47127, 47139, 47143, 47145, 47153, 47155, 47175, 47177, 47185)
  mapcols[match(reg10,co.fips)] <- pal[regionclass[10,n]]

  # yellow
  reg11 <- c(1001, 1003, 1007, 1011, 1013, 1015, 1017, 1021, 1023, 1025, 1027,
             1029, 1035, 1037, 1041, 1047, 1051, 1053, 1063, 1065, 1081, 1085,
             1087, 1091, 1097, 1099, 1101, 1105, 1109, 1111, 1113, 1117, 1119,
             1121, 1123, 1129, 1131, 12033, 12113, 13009, 13013, 13021, 13031,
             13033, 13035, 13043, 13045, 13053, 13059, 13063, 13073, 13077,
             13079, 13089, 13097, 13103, 13105, 13107, 13113, 13121, 13125,
             13133, 13135, 13141, 13145, 13147, 13149, 13151, 13153, 13157,
             13159, 13163, 13165, 13167, 13169, 13171, 13175, 13181, 13189,
             13193, 13195, 13197, 13199, 13207, 13211, 13215, 13217, 13219,
             13221, 13225, 13231, 13235, 13237, 13245, 13247, 13251, 13255,
             13263, 13265, 13269, 13283, 13285, 13289, 13293, 13297, 13301,
             13303, 13317, 13319, 28039, 28041, 28059, 28111, 28153, 45001,
             45003, 45005, 45007, 45009, 45011, 45013, 45015, 45017, 45019,
             45027, 45029, 45035, 45037, 45043, 45047, 45049, 45053, 45063,
             45065, 45071, 45075, 45079, 45081, 45089)
  mapcols[match(reg11,co.fips)] <- pal[regionclass[11,n]]

  # brown
  reg12 <- c(1005, 1031, 1039, 1045, 1061, 1067, 1069, 12001, 12003, 12005,
             12007, 12013, 12019, 12023, 12029, 12031, 12035, 12037, 12039,
             12041, 12045, 12047, 12059, 12063, 12065, 12067, 12073, 12077,
             12079, 12089, 12091, 12107, 12109, 12121, 12123, 12125, 12129,
             12131, 12133, 13001, 13003, 13005, 13007, 13017, 13019, 13023,
             13025, 13027, 13029, 13037, 13039, 13049, 13051, 13061, 13065,
             13069, 13071, 13075, 13081, 13087, 13091, 13093, 13095, 13099,
             13101, 13109, 13127, 13131, 13155, 13161, 13173, 13177, 13179,
             13183, 13185, 13191, 13201, 13205, 13209, 13229, 13239, 13243,
             13249, 13253, 13259, 13261, 13267, 13271, 13273, 13275, 13277,
             13279, 13287, 13299, 13305, 13307, 13309, 13315, 13321 )
  mapcols[match(reg12,co.fips)] <- pal[regionclass[12,n]]


if(1){

  # First vector is random outliers, second vector is the random region

  out1 <- c(c(1129L, 12005L, 13123L, 17091L, 17145L, 19115L, 28057L, 28135L, 
              29083L, 40011L, 54085L),
            c(5073, 22013L, 22021L, 22081L, 22097L, 48005L, 48183L, 48185L, 48207L, 
48217L, 48319L, 48333L, 48467L))
  mapcols[match(out1,co.fips)] <- pal[regionclass[1,n]]
  
  out2 <- c(c(5149, 1001L, 12059L, 17073L, 21107, 28123L, 29019L, 31047L, 39009L, 
                39149L, 47013L),
              c(22017L, 22127L, 48035L, 48051L, 48095L, 48133L, 48145L, 48225L, 
                48343L, 48351L, 48363L, 48499L))
  mapcols[match(out2,co.fips)] <- pal[regionclass[2,n]]

  out3 <- c(c(1131L, 5065L, 13099L, 19001L, 20037L, 28099L, 31159L, 39117L, 
               47075L, 47181L, 54103L),
            c(22067L, 22085L, 22119, 48049L, 48099L, 48161L, 48379, 48401L, 48407L, 48417L, 
48449L, 48457L, 48497L))
  mapcols[match(out3,co.fips)] <- pal[regionclass[3,n]]

  out4 <- c(c(1017L, 1049L, 13071L, 18073L, 20165L, 29005L, 29197L, 39151L, 
              47079L, 47165L, 54077L),
            c(22019L, 22059L, 48119L, 48193L, 48257L, 48293L, 48403L, 48503L
))
  mapcols[match(out4,co.fips)] <- pal[regionclass[4,n]]

  out5 <- c(c(5143L, 12079L, 13169L, 18071L, 19137L, 21027L, 21199L, 29069L, 
              31037L, 40071L, 47123L),
            c(22079L, 22111L, 48001L, 48083L, 48203L, 48241L, 48251L, 
48441L, 48471L))
  mapcols[match(out5,co.fips)] <- pal[regionclass[5,n]]

  out6 <- c(c(5109L, 12029L, 13033L, 17067L, 17193L, 20169L, 29029L, 31129L, 
              37099L, 51169L, 54019L),
            c(22039L, 22041L, 48067L, 48073L, 48085L, 48093L, 48395L, 48405L, 
48453L))
  mapcols[match(out6,co.fips)] <- pal[regionclass[6,n]]

  out7 <- c(c(5015L, 12003L, 17129L, 20061L, 21175L, 29211L, 31081L, 37161L, 
              45037L, 51173L),
            c(22025L, 22049L, 48027L, 48053L, 48231L, 48253L, 48313, 48349L, 48367L, 
48419L, 48459L))
  mapcols[match(out7,co.fips)] <- pal[regionclass[7,n]]

  out8 <- c(c(1043L, 5041L, 13069L, 17061L, 20047L, 29025L, 29039L, 37171L, 
              40043L, 45029L),
            c(22003L, 22061L, 48059L, 48113L, 48213L, 48309L, 48315L, 48327L, 
48365L, 48373L, 48447L))
  mapcols[match(out8,co.fips)] <- pal[regionclass[8,n]]

  out9 <- c(c(1087L, 5051L, 13025L, 18109L, 18179L, 20079L, 29119L, 31099L, 
              40125L, 45091L, 54099L),
            c(22015L, 22069L, 22083L, 48159L, 48221L, 48237L, 48281L, 48331L, 
48399L, 48423L, 48455L))
  mapcols[match(out9,co.fips)] <- pal[regionclass[9,n]]

  out10 <- c(c(5023L, 13001L, 13317L, 18055L, 20163L, 21211L, 22117L, 39023L, 
               40021L, 40075L, 40119L),
             c(5091L, 22011L, 22027L, 22029L, 22073L, 22115L, 48121L, 48289L, 
48299L, 48347L))
  mapcols[match(out10,co.fips)] <- pal[regionclass[10,n]]

  out11 <- c(c(5133, 12039, 17041, 18031, 19177, 20131, 20183, 21017, 22091, 40029, 47115),
             c(5027, 22043, 48041, 48143, 48223, 48267, 48411, 48439))
  mapcols[match(out11,co.fips)] <- pal[regionclass[11,n]]
  
  out12 <- c(c(1089L, 5045L, 13293L, 19039L, 20049L, 29229L, 31077L, 39131L, 
               39159L, 51067L, 54005L),
             c(5139, 22009, 22031, 48063, 48139, 48307, 48339, 48397, 
             48425, 48429, 48491))
  mapcols[match(out12,co.fips)] <- pal[regionclass[12,n]]


  
## ix=identify(map("county", fill=TRUE, col=mapcols,
##                 xlim=c(-100,-79), ylim=c(29.5,42), mar=c(0,0,0,0)
##                 ),
##             n=1000, cex=.2)

## dput(maps::county.fips$fips[match(ix, maps::county.fips$polyname)])
}

  # plot map
  
  maps::map("county", fill=TRUE, col=mapcols,
      xlim=c(-100,-79), ylim=c(29.5,42), mar=c(0,0,0,0)
      )
}

## pal.map(n=12)

## for(i in 2:12){
##   pal.map(n=i)
##   title(i)
## }
