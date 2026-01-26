longtext = input("Enter longtext: ")
shorttext = input("Enter shorttext: ")

long_dashed_text = "-- " + longtext + " --"
print(long_dashed_text)

diff = len(long_dashed_text) - len(shorttext)
side = diff // 2

shortend = ("-" * (side - 1)) + " " + shorttext + " " + ("-" * (side - 1)) 
print(shortend)