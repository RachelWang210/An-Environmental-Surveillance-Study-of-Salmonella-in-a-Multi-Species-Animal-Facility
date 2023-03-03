####graphs

samwide <- reshape(sam, idvar = "Humidity", "Temp","Season","Facility","Region","Species","Condition", "Environment",
                   "Sample_Method", timevar = "Salmonella_Positive", direction = "wide")
