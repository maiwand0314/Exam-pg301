# Exam Project - PG301

## Oppgave 1

### A. Generer bilde
En API-endpoint for å generere bilder.

- **Endpoint:**  
  [Generate Image](https://1a7l90a5n9.execute-api.eu-west-1.amazonaws.com/Prod/generate-image)

---

### B.

GitHub Actions brukes for å bygge og publisere Docker-bilder automatisk.

- **Workflow Run:**  
  [Build and Publish Job](https://github.com/maiwand0314/Exam-pg301/actions/runs/12015586624/job/33493965915)

---

## Oppgave 2

GitHub Actions workflows kjøres automatisk for forskjellige branches:

- **Main Branch Workflow:**  
  [Workflow Run - Main](https://github.com/maiwand0314/Exam-pg301/actions/runs/11957238737/job/33334129088)

- **tfBranch Workflow:**  
  [Workflow Run - tfBranch](https://github.com/maiwand0314/Exam-pg301/actions/runs/11957189134/job/33333731841)

### SQS Queue for bildekø

En AWS SQS Queue brukes til å prosessere bildegenereringsjobber.

- **SQS Queue URL:**  
  [Image Processing Queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image-processing-queue-devops21)

---

## Oppgave 3

### Docker Image Tagging


## Jeg har valgt en to-delt tagge strategi

1. **Unike commit-baserte tagger:**  
   Jeg bruker tag `github.sha` for å lage en unik med en kort commit hash, som sikrer at hver commit har et unikt bilde. Dette gjør at alle     commitsene får sitt eget sporbart og unik bilde, noe som spesielt er bra for testing, debugging og rollback til en spesifikk bestemt funksjon

2. **Latest-tag for nyeste bilde:**  
   Det nyeste bildet som pushes fra GitHub får taggen `latest`. Dette gjør at det blir enkelt å komme til den nyeste versjonen som eventuelt    er stabil. Resultatet blir da enklere prosess for deploying og testing, siden da trenger man ikke å finne en spesifikk commit-hash, fordi     man bruker nyeste versjon.

#### Alt i  alt er dette bra siden det ikke overskriver tidligere versjoner og samtidig så øker det fleksibilitet og sporbarhet for commitene.

## Bilde fra cloudwatch: container-image

![image](https://github.com/user-attachments/assets/65035a4e-58ff-43e7-a8b3-88c542b267e3)
![image](https://github.com/user-attachments/assets/152f9997-bbb1-4d31-a2a8-586966d73d05)


- **Docker-repository navn:**  
  `maiwand0314/java-sqs-client`

- **SQS Queue URL:**  
  [Image Processing Queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image-processing-queue-devops21)

  
---

## Teknisk notat

- **Python-versjon:**  
  Koden er utviklet for Python 3.8. Hvis du bruker en annen versjon av Python, så må koden tilpasses i `template.yaml`.

---

#Oppgave 5 
--
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

## Kort Oppsummert

Serverless arkitektur gir automatisert skalering og ikke minst fleksibilitet, men det krever mange pipelines og flere utfordrende tester. Imens Mikrotjeneste arkitektur er enklere å teste og administrere, men er mindre fleksible ved oppdateringer som er små.



