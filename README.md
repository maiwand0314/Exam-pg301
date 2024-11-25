# Exam Project - PG301

## Oppgave 1

### A. Generer bilde
En funksjonalitet for å generere bilder via en API-endpoint.

- **Endpoint:**  
  [Generate Image](https://1a7l90a5n9.execute-api.eu-west-1.amazonaws.com/Prod/generate-image)

---

### B. Workflow for bygge- og publiseringsprosess

GitHub Actions brukes for å bygge og publisere Docker-bilder.

- **Workflow Run:**  
  [Build and Publish Job](https://github.com/maiwand0314/Exam-pg301/actions/runs/12015586624/job/33493965915)

---

## Oppgave 2

### B. Workflow-resultater

GitHub Actions workflows kjøres for ulike branches:

- **Main Branch Workflow:**  
  [Workflow Run - Main](https://github.com/maiwand0314/Exam-pg301/actions/runs/11957238737/job/33334129088)

- **tfBranch Workflow:**  
  [Workflow Run - tfBranch](https://github.com/maiwand0314/Exam-pg301/actions/runs/11957189134/job/33333731841)

### SQS Queue for bildekøen

- **SQS Queue:**  
  [Image Processing Queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image-processing-queue-devops21)

---

## Oppgave 3

### Docker Image Tagging

Docker-bildene tagges for å sikre unik identifisering og enkel oppdatering:

1. **Unike commit-baserte tagger:**  
   Bruker `github.sha` for å generere en kort commit hash, noe som sikrer at hver commit har et unikt tagget bilde.

2. **Siste tag som representerer nyeste bilde:**  
   Bildet som pushes fra GitHub får også taggen `latest` for enkel referanse til den nyeste versjonen.

---

## Repository

Dette prosjektet ligger på GitHub og inkluderer både kode og workflows:  
[Exam Project Repository](https://github.com/maiwand0314/Exam-pg301)
