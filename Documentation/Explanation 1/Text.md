SwiftUI Storyboards is een hulpmiddel om wegwijs te geraken in broncode van component based user interfaces. Het geeft een overzicht van alle compenenten die gebruikt zijn in een bepaalde applicatie.

Om te beginnen heb je het overzichtscherm waarin je alle componenten kan terugvinden. Omdat in het geval van grotere applicaties er een heel groot aantal verschillende componenten kunnen zijn, worden ze in het overzichtscherm niet allemaal apart weergegeven maar zijn ze gegroepeerd in supercomponenten (zoals deze in de applicatie voorkomen). De blauwe pijlen geven koppelingen aan tussen verwante schermen.

Elk component is opgebouwd uit een aantal subcomponenten. Deze vind je terug in de detailweergave. We bekijken het detail van HomeView. Alle subcomponenten die gebruikt worden in de HomeView vind je hier terug.

Het detail bestaat uit twee grote delen:

- Een voorbeeldscherm van het component
- De subcomponenten die hierin vervat zitten

De subcomponenten zijn onderverdeeld in twee segmenten:

- Diegene die zichtbaar zijn in het voorbeeldscherm
  - Zoals bijvoorbeeld de drie topic rijen, en de afbeelding
- Diegene die niet zichtbaar zijn in het voorbeeld maar er toch in gebruikt worden.
  - Zoals bijvoorbeeld: een link naar de settings pagina
  - Links naar niewspaginas

Sommige componenten kunnen een verschillend uiterlijk hebben op basis van "State". Deze view heeft bijvoorbeeld een ***loading*** state en een ***loaded*** state.

Elk subcomponent kan ook op zijn beurt nog subcomponenten hebben. Die hebben dan op hun beurt ook elk een een aparte detail weergave.