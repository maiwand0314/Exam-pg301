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

# I alt er dette bra siden det ikke overskriver tidligere versjoner og samtidig så øker det fleksibilitet og sporbarhet for commitene.

- **Docker-repository navn:**  
  `maiwand0314/java-sqs-client`

- **SQS Queue URL:**  
  [Image Processing Queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image-processing-queue-devops21)

  
---

## Teknisk notat

- **Python-versjon:**  
  Koden er utviklet for Python 3.8. Hvis du bruker en annen versjon av Python, så må koden tilpasses i `template.yaml`.

---




