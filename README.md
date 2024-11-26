# Exam Project - PG301

## Oppgave 1

### A. Generer bilde
En API-endpoint for å generere bilder.

- **Endpoint:**  
  [Generate Image](https://1a7l90a5n9.execute-api.eu-west-1.amazonaws.com/Prod/generate-image)
  
  https://1a7l90a5n9.execute-api.eu-west-1.amazonaws.com/Prod/generate-image

---

### B.

GitHub Actions brukes for å bygge og publisere Docker-bilder automatisk.

- **Workflow Run:**  
  [Build and Publish Job](https://github.com/maiwand0314/Exam-pg301/actions/runs/12015586624/job/33493965915)
  
  https://github.com/maiwand0314/Exam-pg301/actions/runs/12015586624/job/33493965915

---

## Oppgave 2

GitHub Actions workflows kjøres automatisk for forskjellige branches:

- **Main Branch Workflow:**  
  [Workflow Run - Main](https://github.com/maiwand0314/Exam-pg301/actions/runs/11957238737/job/33334129088)
  
  https://github.com/maiwand0314/Exam-pg301/actions/runs/11957238737/job/33334129088

- **tfBranch Workflow:**  
  [Workflow Run - tfBranch](https://github.com/maiwand0314/Exam-pg301/actions/runs/11957189134/job/33333731841)
  
  https://github.com/maiwand0314/Exam-pg301/actions/runs/11957189134/job/33333731841

### SQS Queue for bildekø

En AWS SQS Queue brukes til å prosessere bildegenereringsjobber.

- **SQS Queue URL:**  
  [Image Processing Queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image-processing-queue-devops21)
  
  https://sqs.eu-west-1.amazonaws.com/244530008913/image-processing-queue-devops21

---

## Oppgave 3

### Docker Image Tagging


## Jeg har valgt en to-delt tagge strategi

1. **Unike commit-baserte tagger:**  
   Jeg bruker tag `github.sha` for å lage et unikt bilde med en kort commit hash, som sikrer at hver commit har et unikt bilde. Dette gjør at alle commitsene får sitt eget sporbart og unik bilde, noe som spesielt er bra for testing, debugging og rollback til en spesifikk bestemt funksjon

2. **Latest-tag for nyeste bilde:**  
   Det nyeste bildet som pushes fra GitHub får taggen `latest`. Dette gjør at det blir enkelt å komme til den nyeste versjonen som eventuelt    er stabil. Resultatet blir da enklere prosess for deploying og testing, siden da trenger man ikke å finne en spesifikk commit-hash, fordi     man bruker nyeste versjon.

#### Alt i  alt er dette bra siden det ikke overskriver tidligere versjoner og samtidig så øker det fleksibilitet og sporbarhet for commitene.


- **Docker-repository navn:**  
  `maiwand0314/java-sqs-client`

- **SQS Queue URL:**  
  [Image Processing Queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image-processing-queue-devops21)
  
  https://sqs.eu-west-1.amazonaws.com/244530008913/image-processing-queue-devops21

---

## notat

- **Python-versjon:**  
  Koden er utviklet for Python 3.8. Hvis du bruker en annen versjon av Python, så må koden tilpasses i `template.yaml`.

---

# Oppgave 4

## Bilde fra cloudwatch for alarm:

![image](https://github.com/user-attachments/assets/65035a4e-58ff-43e7-a8b3-88c542b267e3)
![image](https://github.com/user-attachments/assets/152f9997-bbb1-4d31-a2a8-586966d73d05)


---

# Oppgave 5 

## 1. Automatisering og kontinuerlig levering (CI/CD): Hvordan påvirker serverless-arkitektur sammenlignet med mikrotjenestearkitektur CI/CD-pipelines, automatisering, og utrullingsstrategier?

## Serverless Arkitektur

### Fordeler

- **Granulære CI/CD pipelines:**  
  En serverless arkitektur funker på en måte hvor arkitekturen brytes ned til små funksjoner, disse isolerte funksjonene håndterer spesifikt en oppgave. Resultatet av det blir da at det fører til høyere antall komponenter som har sine egne uavhengige livssykluser. 

- **Utrullingsstrategier:**  
  Hos AWS lambda så blir det tilbydd avanserte strategier, disse gjør at risikoen ved utrulling blir redusert. Eksempler på strategier er Gradual Rollouts og Canary Releases.

- **Verktøy for automatisering:**  
  AWS SAM og Serverless Framework hjelper med å builde, teste og distribuere funksjoner raskt og effektivt. 

- **Automatisk ressursstyring:**  
  Ved forespørsel så utvides Lambda funksjoner automatisk. Dette fører til at CI/CD-prosessene blir forenklet fordi det fjerner behovet for manuell ressursadministrasjon.

### Svakheter

- Noen svakheter ved dette er at det forekommer kompleksitet i pipelinene, de små funksjonene som blir laget krever sine egne CI/CD pipelines, å behandle de krever optimaliserte verktøy, i tillegg kreves det ekstra arbeid og tid.

- For det andre kreves det veldig mange integrasjonstester for å sikre kommunikasjonen mellom komponentene siden eventdrevne arkitekturer bruker message-Queues som SQS.

---

## Mikrotjenestearkitektur

### Fordeler

- **Enklere CI/CD:**  
  Mikrotjenester er større og sammenhengende tjenester som fordeles som enhet. Dette betyr færre pipelines, og prosessen til dette kan standardiserer med verktøy som Docker og Kubernetes.

- **Utrullingsstrategier:**  
  Blue/Green Deployment og Rolling updates er noen metoder som gir sikkerhet og stabilitet under oppdateringer.

- **Sentralisert Testing:**  
  Det er mer oversiktlig å teste større tjenester i forhold til å teste små komponenter.

### Ulemper

- Noen ulemper er at oppdatering av en del av tjenesten krever distribusjonen av hele tjenesten.

- For det andre så krever det ekstra tilpasning siden mikrotjenester enten containerbasert eller manuell ressursadministrasjon.

---

#### Kort Oppsummert

Serverless arkitektur gir automatisert skalering og ikke minst fleksibilitet, men det krever mange pipelines og flere utfordrende tester. Imens Miktrotjeneste arkitektur er enklere å teste og administrere, men er mindre fleksible ved oppdateringer som er små.

---

## 2. Observability (overvåkning): Hvordan endres overvåkning, logging og feilsøking når man går fra mikrotjenester til en serverless arkitektur? Hvilke utfordringer er spesifikke for observability i en FaaS-arkitektur?

Når man har en overgang fra mikrotjenester til serverless arkitektur så blir overvåkning, logging og feilsøking mer komplisert, fordi systemet blir brytet ned til mange små og korte funksjoner. Det er enklere å overvåke og logge, fordi det er større tjenester som kjører kontinuerlig og gir oversiktlig bilde. I forhold til dette så må man håndtere splittede logger fra mange ulike funksjoner og spore arbeidsflytene mellom ulike tjenester som AWS Lambda og SQS. AWS CloudWatch og X-ray er et par verktøy som hjelper med feilsøking, men det krever mer komplekse teknikker for å sammenligne data og forstå systemets tilstand helhetlig.

I FaaS-arkitektur som AWS Lambda så kommer det opp spesifikke utfordringer koblet til observability, dette skjer fordi som sagt tidligere så er systemet er delt opp i små og korte funksjoner. Loggingen er spredt mellom funksjoner, noe som gjør det mer komplisert å samle og analysere data. Arbeidsflyter kobles også via tjenester som SQS og dette krever da X-ray for sporing av systemet. FaaS-systemer er dessuten event-drevne, noe som kan gjøre det vanskelig å oppdage problemer med ytelse. Spesialtilpassede verktøy kreves i dette tilfellet for å samle alle logger og også å spore data gjennom systemet.

---

## 3. Skalerbarhet og kostnadskontroll: Diskuter fordeler og ulemper med tanke på skalerbarhet, ressursutnyttelse, og kostnadsoptimalisering i en serverless kontra mikrotjenestebasert arkitektur.

## Serverless Arkitektur

## Fordeler

### Skalerbarhet
- Ved trafikkøkning så skalerer AWS Lambda automatisk, basert på antall forespørsler. Det forenkler håndtering av brå økninger i trafikken uten å trenge manuell betjening.

### Ressursutnyttelse
- Ved serverless arkitektur er det veldig effektiv ressursbruk, fordi funksjonene som blir laget kjøres kun når de trengs, i tillegg blir ressursene bare brukt under gjennomføring.

### Kostnadsoptimalisering
- Du må bare kunne betale for de virkelige kjøretidene og de antall forespørslene, noe som gjør kostnaden gunstig for systemer med uventet trafikk.

## Ulemper

- Ved veldig mange kjøringer eller lange funksjoner kan kostnadene bli høye.
- Begrensninger i ressursbruk og kjøretid hver funksjon kan føre til at det kreves å dele opp arbeidsflyter.

---

## Mikrotjenestearkitektur

## Fordeler

### Skalerbarhet
- Skalering av mikrotjenester krever mer innsats siden det skjer manuelt eller via verktøy som for eksempel Kubernetes. Men, det fører til økt kontroll over skaleringen.

### Ressursutnyttelse
- Siden det er mer kontroll over skalering, så er det også mulig å begrense eller sette sammen ressursbruken selv basert på det tjenesten trenger.

### Kostnadsoptimalisering
- Mikrotjenester er forutsigbart fordi ressursbruken kan budsjetteres og planlegges, noe som gir kontrollerte kostnader.

## Ulemper

- Det kan være dårlig for systemer som har varierende trafikk og ikke fast, fordi det fører til overforbruk av de faste ressursene satt til hver tjeneste.
- Det krever også stort mengde arbeid for å forbedre ressursbruken og kapasiteten.
  
---

## 4. Eierskap og ansvar: Hvordan påvirkes DevOps-teamets eierskap og ansvar for applikasjonens ytelse, pålitelighet og kostnader ved overgang til en serverless tilnærming sammenlignet med en mikrotjeneste-tilnærming?

## Serverless Arkitektur

### **Eierskap**
- **Fordel:** Små teams kan eie og opprettholde egne funksjoner.
- **Ulempe:** Ansvar økes for design og overvåkning av små funksjoner.

### **Ansvar**
- **Fordel:** Teamets ansvar reduseres for selve infrastruktur, fordi de slipper å administrere det siden det håndteres av AWS.
- **Ulempe:** Teamet har mindre kontroll over infrastruktur, som skalering og drift, noe som kan føre til noen utfordringer ved skaleringsproblemer eller begrensninger for ytelse som ikke kan blitt tatt kontroll på direkte.

### **Kostnader**
- **Fordel:** Du betaler bare for hvert bruk, dette kan mulig gi lave kostnader ved kontroller trafikk.
- **Ulempe:** Lite produktive funksjoner har en sjanse for å føre til høyere kostnader enn det er forventet.

### **Pålitelighet**
- AWS har en innebygd tjeneste som gir høy pålitelighet og automatisk overtakelse ved feil, dette fører til pålitelighet uten at et team trenger å passe på det manuelt.

---

## Mikrotjenestearkitektur

### **Eierskap**
- **Fordel:** Enklere å administrere og feilsøke tjenester, fordi ansvarsområdene er definert godt.
- **Ulempe:** Det har oftest store komponenter, dette kan føre til at oppdateringer er mer tidskrevende og feil i en liten del kan påvirke hele tjenesten.

### **Ansvar**
- **Fordel:** Teamet har fullt ansvar over infrastruktur, altså drift, skalering og konfigurering.
- **Ulempe:** Dette øker arbeid og krever god kunnskap for å sikre bra og optimal ytelse.

### **Kostnader**
- **Fordel:** Tydelige kostnader ved faste fordelinger av ressurser.
- **Ulempe:** Ressursene må være tilgjengelige, dette fører til faste kostnader selv under lavt trafikk noe som er veldig unødvendig.

### **Pålitelighet**
- **Fordel:** Mikrotjenester er bygd opp slik at feil i en tjeneste påvirker stort sett ikke de andre tjenestene.
- **Ulempe:** Oppsettet av logging og overvåkning kan være komplisert siden det må bli satt opp manuelt og kan kreve et par ressurser (som kan føre til økt kostnader).

### **Kort oppsumert**: serverless arkitektur gjør at Devops-teamet ikke trenger å arbeide med infrastruktur, i tillegg gir det høy pålitelighet med de innebygde tjenestene det har, men det har noen utfordringer som foreksempel at det kan komme uforventede kostnader og trengs godt samarbeid. Miktrojenestearkitektur derimot, gjør at Devops-teamet har større kontroll over infrastruktur som da fører til gode klare anvarsområder. Men, mikrotjenestearkitektur krever mer arbeid for å forbedre infrastruktur, i tillegg kan det bli dyrt hvis det er dårlig ressursoppsett og utnyttelse.
