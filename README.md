Lucidchart länk : https://lucid.app/lucidchart/7b77c7d5-026a-4bcf-8c19-17697aa03dac/edit?invitationId=inv_c7961f9e-04f4-433e-8863-c0b5dc1e2c49&page=0_0#

Normalisering:
1NF: Kravet för 1NF uppnås eftersom det finns tydligt identifierbara primärnycklar, varje kolumn innehåller atomära värden, och det inte förekommer några upprepade grupper/arrayer i enskilda fält.

2NF: Samtliga tabeller använder enkla surrogatnycklar (INT IDENTITY) som primärnyckel. I tabellen Uppdrag beror attributen Startdatum, Slutdatum och Rollbeskrivning uteslutande på det specifika uppdraget (UppdragId).

3NF: Tabellen Uppdrag är kopplad till de andra två tabellerna (Kund och Konsult) enbart genom primärnycklar/främmande nycklar. Inga uppgifter dupliceras i uppdragsposten, vilket innebär att det inte finns några transitiva beroenden.

DevSecOps-reflektion:
1. Genom att parameterisera data från webbapplikationen skyddar vi oss mot SQL-injektioner. Det kan även vara värt att skydda sig mot brute-force-attacker genom en funktion som låser ut användaren i 15 minuter vid upprepade felaktiga inloggningsförsök. Genom att låsa kontot i 15 minuter vid 3 feltryck blir det astronomiskt mycket svårare att ta sig in via brute-force.

Här kommer lite matte till dig och frugan :)
Om någon kör ett skript som gissar lösenord/koder kan angriparen enkelt komma upp i hundratals försök per minut:
500 försök/minut * 60 minuter = 30 000 försök
Med en 15-min utlåsning efter 3 försök blir det mazimalt 4 intervall per timme:
3 gissninger per kvart * 4 = 12 gissningar i timmen
12 gissningar/timme * 24 timmar = 288 gissningar per dygn.
30000/288 = ca 104.17
Med 15 min utlåsningen tar det alltså cirka 104 dygn att göra samma 30 000 gissningar som annars tog en timme

Genom indexerade kolumner (som Claes har pratat om) skapar SQL Server ett balanserat sökträd (B-träd). Därmed slipper databasmotorn läsa in varje enskild rad (table scan) för att hitta det den söker efter. Detta kan exempelvis göras genom att lägga till ett icke-klustrat index på kolumnen OrgNr i tabellen Kunder.

Reflektioner:
Vi satt i grupp (vår Grupp 5) och hade riktigt roligt med uppgiften när vi hittade på alla roliga namn, yrken och uppdrag till våra fiktiva personer. En riktigt rolig uppgift!

När det gäller säkerhetsdelen lade jag även till kalkylen för brute-force. Trots att det inte uttryckligen efterfrågades kändes det relevant att belysa hur servern kan belastas i onödan. Beräkningen utgår från en angripare från en och samma källa, men finessen med 15 minuters lockout efter 3 försök är att angriparen antingen behöver 104 dagar på sig – eller måste distribuera attacken över 104 separata IP-adresser för att uppnå samma takt.
