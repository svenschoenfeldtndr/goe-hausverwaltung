# ImmoPilot – Docker & Render

Private Immobilienverwaltung mit Login/Rollen, Mietbuchhaltung, Mahnwesen, Dokumenten und PDF-Ausgabe sowie vereinfachter Nebenkostenabrechnung. Node.js/Express + SQLite.

## Auf GitHub hochladen

1. ZIP entpacken, im Ordner `immopilot-render` ein neues Git-Repository anlegen.
2. Im Terminal:

```bash
git init
git add .
git commit -m "ImmoPilot Docker und Render Deployment"
git branch -M main
git remote add origin https://github.com/DEIN-USERNAME/DEIN-REPO.git
git push -u origin main
```

Repository auf GitHub **privat** anlegen; keine echten Mieterdaten, Datenbankdateien oder Passwörter committen.

## Auf Render deployen (Blueprint)

1. Render Dashboard → **New → Blueprint** und GitHub-Repository verbinden.
2. Render liest `render.yaml` und erstellt einen Docker-Webservice mit **persistentem Datenträger** in Frankfurt.
3. Beim Einrichten `ADMIN_PASSWORD` als geheime Umgebungsvariable mit mindestens 12 Zeichen eintragen. `ADMIN_USER` ist `admin`.
4. Deployment abwarten, dann die angezeigte HTTPS-URL öffnen. Erstanmeldung: `admin` + festgelegtes Passwort.

**Kosten:** `plan: starter` und der persistente Datenträger sind kostenpflichtig; aktuelle Render-Preise prüfen. SQLite und hochgeladene Dokumente benötigen diesen Datenträger. **Ohne persistenten Datenträger gehen Daten bei Neustart/Neudeployment verloren.** Der Docker-Build allein speichert keine Daten dauerhaft.

## Lokal mit Docker

```bash
docker build -t immopilot .
docker volume create immopilot-data
docker run --rm -p 3000:10000 -e ADMIN_PASSWORD='HIER_EIN_STARKES_PASSWORT' -e COOKIE_SECURE=0 -v immopilot-data:/var/data immopilot
```

Danach `http://localhost:3000` öffnen. Docker Compose ist alternativ vorhanden.

## Daten und Sicherheit

- `DATA_DIR=/var/data` enthält SQLite (`hausverwaltung.db`, ggf. WAL-Dateien) und `uploads/`.
- **Regelmäßig externe, verschlüsselte Backups erstellen und Wiederherstellung testen.** Ein persistenter Render-Datenträger ersetzt kein Backup.
- Initiales `ADMIN_PASSWORD` wird nur zur Anlage des ersten Administrators verwendet. Spätere Änderungen der Umgebungsvariable ändern das Passwort des vorhandenen Kontos **nicht**.
- `COOKIE_SECURE=1` ist für HTTPS auf Render gesetzt; lokal über HTTP auf `0` setzen.
- Gesundheitscheck: `/healthz` (ohne Authentifizierung, nur DB-Verfügbarkeit).
- Die Anwendung ist ein **Prototyp, nicht für echte personenbezogene Mieterdaten im öffentlichen Internet freigegeben**. Vor produktiver Nutzung sind u.a. CSRF-Schutz, robustes Login-Rate-Limiting, Security-Review, sichere Backups, Protokollierung, Datenschutzkonzept und gegebenenfalls weitere Maßnahmen erforderlich. Render macht die Anwendung öffentlich erreichbar.
- Nebenkostenabrechnung ist ein Muster, keine rechtssichere Abrechnung; Mahnungen sind PDF-Entwürfe.

## Prüfen

```bash
npm install
npm run check
```

Der Docker-Build ist hier nicht live auf einer Docker-Engine getestet worden.

## Version 2.2 – Dashboard und Darstellung

- Kennzahlen-Kacheln auf dem Dashboard sind vollständig anklickbar und führen direkt zu Immobilien, Mietern, Mietbuchhaltung oder Schadensmeldungen.
- Schnellzugriff auf Mietverträge, Mahnwesen, Dokumente und Nebenkosten.
- Überarbeitetes responsives Layout mit besserer visueller Hierarchie, Hover- und Tastatur-Fokuszuständen.
- Die Rollenberechtigungen bleiben unverändert; schreibgeschützte Benutzer erhalten keinen Hinzufügen-Button in den Stammdatenansichten.

Nach dem Upload zu GitHub baut Render bei aktiviertem Auto-Deploy das Docker-Image erneut. Bestehende Daten auf dem persistenten Render-Datenträger bleiben erhalten.
