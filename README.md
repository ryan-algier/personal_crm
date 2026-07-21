# Personal CRM

A personal Customer Relationship Management (CRM) tool to track professional networking contacts, companies, interactions, and referrals.

---

## Why I Built This

Keeping track of who you know, when you've talked to them, what you talked about, where they work, who introduced them to you all in your head is a daunting task. As I started networking more, I needed a way to keep everything organized. 

I started with notebooks. Easy. Cheap. Holds all of your thoughts and you can read the info back. Pretty much all I needed when I had single conversation every few months and didn't want to follow up at all. Also, not water resistant when you spill something on your desk...

So I switched to excel. A familiar tool with the ability to edit easier, add rows and copy information quickly when following up with a person. A bit tougher to type in than writing in a book during a meeting, but I could write in the notebook and then just copy the info over as needed. Perfect... Until I want to add in some more information. Like the company someone works at, and then a little info about that company. And who referred me to them, I want to make sure if something takes off, I can give credit to the referrer of course. And I want to group all of our interactions so I can read back through what advice they gave and books to read and whether they would be willing to refer me if we hit it off. And suddnely my single excel sheet had 20 columns with tons of repeated information.

And so I split things into multiple sheets. More difficult, but hey I'm a data scientist, I can make a first normal form database structure in excel with foreign keys and add new data remembering all the ids. As you may have guessed, this went terribly. I made it work, but quickly saw the scope growing beyond the capability of excel. And so I wrote up my ideas about putting the info into a SQL database and worked with Claude AI to see where this could go. 

With my data science background, the rise of AI capabilities and an idea in my head, I could build something customized to exactly what I wanted. That lead to the rare opportunity to kill three birds with one stone:
    * Creating a clean, working tool, customized to what I care about to keep me organized
    * An opportunity to use AI to augment my data science abilities and see what the hype is all about in a realistic project situation
    * Something to show in a portfolio that highlights my abilities in data science, project planning, learning new skills and real world thinking

---

## What It Does

- **Track contacts and companies** - store things you know about a person: how you met them, where they work, their location, contact details
- **Log interactions** - record emails, calls, etc with date, summary and potential outcomes
- **Track referrals** - record who introduced you to whom and visualize your referral network
- **Flag missing thank yous** - follow up thank you's are important to me, so I added info for  interactions that need a follow-up thank you and haven't received one yet
- **Analyze your network** - a Power BI dashboard shows interaction trends, geographic spread, industry breakdown, referral patterns, and more
- **Protect your data** - real data stays local; a Python anonymization pipeline generates safe sample data for public sharing if you are like me and started with a crazy excel spreadsheet of information

---

## Tech Stack

| Tool | Role |
|---|---|
| MySQL | Primary relational database |
| Python | Data pipeline: anonymization, bulk import, backup, run app|
| Flask + Bootstrap 5 | Local web UI for day-to-day data entry (full CRUD) |
| Excel | Bulk data entry template and import vehicle |
| Power BI Desktop | Analytics dashboard |
| uv | Python environment and dependency management |
| GitHub | Version control and portfolio showcase |

---

## Project Structure

```
networking-crm/
│
├── README.md                 ← you are here
├── .gitignore                ← things not to put on github
├── pyproject.toml            ← uv project config
├── uv.lock                   ← uv lockfile
│
├── sql/
│   ├── 001_create_tables.sql          ← initial schema
│   └── 002_add_thank_you_required.sql ← modified schema
│
├── python/
│   ├── app.py                ← Flask application
│   ├── db.py                 ← MySQL connection helper
│   ├── anonymize_data.py     ← generates anonymized sample data
│   ├── import_to_mysql.py    ← bulk loads Excel into MySQL
│   ├── backup_db.py          ← automated database backup
│   └── templates/            ← Flask HTML templates (Bootstrap)
│       ├── base.html
│       ├── home.html
│       ├── contacts/
│       ├── companies/
│       └── interactions/
│
├── real_data/
│   └── crm_template.xlsx     ← data entry template
│
├── anonymized_data/
│   └── crm_anonymized_data.xlsx     ← my sample data after anonymization
│
├── powerbi/
│   └── crm_dashboard.pbix    ← Power BI dashboard (anonymized data)
│


##  REVIEW THIS!@!!
└── docs/
    ├── schema_diagram.png
    └── changelog.md          ← full decision log and project context
```

---

## Database Schema

Four tables with relational links:

- A **company** can have many contacts (or none yet)
- A **contact** can belong to one company
- A **contact** can have many interactions
- **Referrals** link two contacts - one who referred, one who was referred

See `sql/001_create_tables.sql` and `sql/002_add_thank_you_required.sql` for the full schema.

---

## Data Privacy

This project was built with real personal networking data. Everything in this repository uses anonymized data generated by `python/anonymize.py`:

- Names, emails, phone numbers, and LinkedIn URLs are replaced with Faker-generated values
- Company names and websites are replaced with fictional equivalents
- Location fields use real city names (randomly selected) so map visuals work correctly
- Other fields replaced as needed

Real data lives only in a local MySQL instance and is never committed to GitHub. This separation was a deliberate design decision from the start.

`anonymized_data/crm_anonymized_data.xlsx` includes my data after anonymization. It can be used to see the full functionality of the repo without having to create your own excel data first if you'd like.

---

## Power BI Dashboard

The dashboard (`powerbi/crm_dashboard.pbix`) is pre-loaded with anonymized sample data and can be opened in Power BI Desktop without any setup (no MySQL connection required to view it).

**Interactions**
KPI cards (total contacts, total interactions, days since last interaction), per-person interaction table sorted by last contact date, interactions per person bar chart, interactions over time line chart. Includes color coded status for how long its been since interacting (green = 0-90 days, yellow = 90-180 days, red = 180 days+, grey = N/A)
**Thank Yous**
Table to show interactions that required a thank you, whether one was sent and how long it took to send with color coded statuses. Also a KPI for average days to turn around a thank you (Don't worry, I am much faster with real interactions)

**Location/Industry**
Map with bubbles by city for how many companies are listed in that city. Bottom bar graph shows counts of companies by industry and allows filtering on the map to see the distribution of a particular industry by city.

**Meetings and Interactions**
Barcharts and tables to show how I have met everyone and how I was interacting with them.

**Key Companies**
A barchart and table to see all the companies that belong to each industry.

**Top Contacts**
KPIs and tables to quickly look through who is giving me the most referrals to others and who those referrals are.

> If you connect it to your own MySQL instance and click Refresh, it will try to connect to `localhost`. See the setup instructions below.

---

TO DO
## Screenshots

> Screenshots use anonymized sample data - no real personal information is shown.

### Power BI Dashboard

![alt text](image.png)

*Screenshots coming soon - add `docs/screenshots/dashboard_page1.png`, `dashboard_page2.png`, `dashboard_page3.png`*

### Flask Web App

*Screenshots coming soon - add `docs/screenshots/flask_home.png`, `flask_contacts.png`, `flask_add_contact.png`, `flask_interactions.png`*

---

## Flask Web App

A local web interface for managing your data without touching MySQL Workbench or Excel

**Run it:**
```bash
cd python
uv run flask --app app run
```

Then open `http://localhost:5000` in your browser.

**Features:**
- Add, edit, and delete contacts, companies, and interactions
- Referral captured on the contact form
- Thank you status shown on the interactions list with color coding
- Flash messages for success/error feedback
- Delete confirmation dialogs to prevent accidents
- Server-side validation on all required fields

---

TO DO

## Setup Instructions

Follow these steps to run the project locally with your own data.

Note: I added extra steps to anonymize my data and provide examples for others to look at, but all the steps assume you are loading real data and will not be posting to github like I did. If you are planning to post information, please do not post real information for other people without their consent. I also recommend you do not create information in excel first like I did. Learn from my mistakes.

### Prerequisites

If you do not already have these, install the following before starting:

- [MySQL Community Server](https://dev.mysql.com/downloads/mysql/) - the database engine
- [MySQL Workbench](https://dev.mysql.com/downloads/workbench/) - GUI for managing the database
- [MySQL Connector/NET](https://dev.mysql.com/downloads/connector/net/) - required for Power BI to connect to MySQL
- [Power BI Desktop](https://powerbi.microsoft.com/desktop/) - free, Windows only
- [Python 3.11+](https://www.python.org/downloads/) - free, Windows only
- [uv](https://docs.astral.sh/uv/getting-started/installation/) - Python package manager
- [Git](https://git-scm.com/) - Use git source control

I also recommend installing:
- [Visual Studio Code](https://code.visualstudio.com/) - source code editor
with the following extensions:
- [Jupyter] - to run jupyter notebooks in VSCode
- [Python] - to run Python 
- [Ruff] - linter to clean up code
- [Rainbow CSV] - makes csv viewing easier


Also add MySQL Server's `bin` folder to your Windows PATH to help create database backups:
```
C:\Program Files\MySQL\MySQL Server 8.0\bin
```
(Search "Edit the system environment variables" → Environment Variables → System variables → Path → New)

---

### Step 1 - Clone the repo

```bash
git clone https://github.com/yourusername/personal-crm.git
cd personal-crm
```

---

### Step 2 - Install Python dependencies

```bash
uv sync
```

This reads `pyproject.toml` and installs all dependencies into a local `.venv` automatically.

---

### Step 3 - Create your `.env` file

Create a file called `.env` at the project root (it is already in `.gitignore` and will never be committed):

```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password_here
DB_NAME_REAL=personal_crm
DB_NAME_SAMPLE=personal_crm_sample
DB_MODE=real
```

- `DB_PASSWORD` - the password you set when installing MySQL. Can be reset in Workbench under Server → Users and Privileges
- `DB_NAME` - match this to your exact database name if you change it
- `DB_MODE` - set to `real` to use your real data, `sample` to use anonymized data

---

### Step 4 - Create the databases in MySQL Workbench

Open MySQL Workbench and connect to your local instance. Then open and run `sql/migrations/001_create_tables.sql` twice. Once with `personal_crm` and once with `personal_crm_sample` to create both databases and all four tables. Since the databases are indentical for both, you only need to change the name. 

Then run `sql/migrations/002_add_thank_you_required.sql` to add the thank you tracking column. Repeat for both the sample and non-sample files.

You can run a file in Workbench by opening it (File → Open SQL Script) and clicking the lightning bolt icon or pressing `Ctrl+Shift+Enter`.

---

### - Step 5 - Creating your own data

**Option A - Flask web app (recommended)**

Start the app:
```bash
cd python
uv run flask --app app run
```

Open `http://localhost:5000` and use the forms to add companies, contacts, and interactions directly. This writes to MySQL immediately with no import step needed. 

**Option B - Creating your own data in Excel (not recommended)**

Create a new copy of `excel/crm_template.xlsx` and call it: `crm_real_data.xlsx` in the same folder. Load it up with all the data you want. If you don't get all of the id's lined up properly, it won't import to the database correctly so check your structure. (If you have a lot of data to add, you will quickly see why I recommend skipping these steps and just using the Flask UI). The ids in excel ar temporary and will be replaced by the import script

When ready to import *(If you want to use anonymized data, complete step 6 before running import_to_mysql.py):
```bash
cd python
uv run import_to_mysql.py
```
> The import script truncates and reloads all data on every run. Any data entered via the Flask app since the last import will be overwritten. Pick one method as your primary data entry approach.

**Option C - Using data I made up**

If you just want to see what I made and not make your own data, I have provided data for you to do so. Look for `anonymized_data/crm_anonymized_data.xlsx`. Copy that file and add it to the excel folder as such: `excel/crm_real_data.xlsx` 

Import with:
```bash
cd python
uv run import_to_mysql.py
```

---

### OPTIONAL - Step 6 - Anonymizing your data

While necessary for me to be able to show off any data, the following are completely optional. You can run them if you want to see the process and what I did. First, I had an excel file created following the guidelines of the template. (Step 5 Option B).

Run `python/anonymize_data.py`. It will look for `excel/crm_real_data.xlsx` and create a new data file for you: `anonymized_data/crm_anonymized_data.xlsx` that removes all personal information. This is the file I have posted if you want to pretend that's your own data and upload it to the database (Step 5 Option C).

**To run flask UI with anonymized data**
Change the `DB_MODE = real` to `DB_MODE = sample` in `.env`
Start the app:
```bash
cd python
uv run flask --app app run
```

---

### Step 7 - Connect Power BI to your database

1. Open `powerbi/crm_dashboard.pbix` in Power BI Desktop
2. Go to **Home → Transform Data → Manage Parameters**
3. Change `DatabaseName` to `personal_crm` (or `personal_crm_sample` for sample data)
4. Click **Home → Refresh**
5. When prompted for credentials, select **Database** (not Windows) and enter your MySQL username and password (Should be in your .env file if you can't remember)

> Note: Both the Source step and Navigation step in Power Query use the `DatabaseName` parameter. If you reconnect from scratch, make sure both are updated.

> Before pushing to GitHub, always set `DatabaseName` back to `personal_crm_sample` and refresh, then save.

---

### Step 8 - Creating backups OPTIONAL: Set up automated backups

The backup script saves a timestamped `.sql` dump of your database to the `backups/` folder. All backups are kept indefinitely.

**To manually create a backup:**
```bash
cd python
uv run backup_db.py
```

**Automate with Windows Task Scheduler:**
1. Open Task Scheduler → Create Basic Task
2. Name: `Networking CRM Backup`
3. Trigger: Daily at your preferred time
4. Action: Start a program
5. Program: path to your `uv.exe`, e.g. `C:\Users\yourname\.local\bin\uv.exe`
6. Arguments: `run backup_db.py`
7. Start in: full path to your `python/` folder, e.g. `C:\Users\yourname\dev\networking-crm\python`
8. Click Finish

**To restore from a backup:**
Do the following when you need to restore your database after making edits. Replace the date/time string in the file name to whatever version you would like
```bash
mysql -u root -p personal_crm < backups/personal_crm_2024_01_15_09_00.sql
```

---

### Step 9 - Run Script as a shortcut OPTIONAL:
I wanted to have a desktop shortcut icon to automatically run the app without having to open vs code so I added run_crm.bat. To make it a icon shortcut: right-click, show more options, 
send to - Desktop (create shortcut)

---

## Day-to-Day Usage

Once everything is set up, your daily workflow is:

**Adding a new contact:**
1. Start Flask: `cd python && uv run flask --app app run`
2. Open `http://localhost:5000`
3. Click Add Contact - fill in name, company, how you met, referred by (if applicable)

**Logging an interaction:**
1. In Flask go to Interactions → Log Interaction
2. Select the contact, set the type and date, add a summary
3. Check "Thank You Required" if you need to follow up

**Checking who needs a thank you:**
- Interactions list shows a color-coded Thank You Status column
- Red = required but not yet sent
- Green = sent
- Grey = not required or this row is itself a thank you

**Viewing your dashboard:**
1. Open `powerbi/crm_dashboard.pbix`
2. Set `DatabaseName` to `personal_crm` in Manage Parameters
3. Click Refresh

---

## Acknowledgements

Built iteratively over multiple sessions as both a personal tool and a learning project. The schema, anonymization pipeline, Flask app, and Power BI dashboard each evolved based on real usage. The `docs/changelog.md` file documents every decision made along the way, including why certain fields were added or removed, tradeoffs considered, and lessons learned. It also reflects my interactions with AI and how I used it to augment my ideas. There are many parts that may not 100% reflect what happened as I would frequently take what AI recommended and change aspects of it and not tell it everything.



## In the Future:

I expect this project to expand as I use it and need new things. There are already many things I would do differently if I started again or want to add like:
* integrated charts into the web interface
* web hosting and adding logins if this turned into an actual living web service
* if I wasn't making this partially as a portfolio project, I would remove all the excel and anonymization steps. It was a lot of work that isn't needed if this information is just meant to live locally on a personal computer
* more powerBi charts. I scratched the surface with database connection, charts and minor DAX. There is so much more I can do and would like to practice with
* along with more powerbi charts, I could clean up the flow of the dashboard and maybe naming schemes. I was using this project to learn how to make a dashboard so I was adding and modifying things all the time. I could likely do better once I get a better sense of what sheets I actually care about and use frequently
* more data and better ways to go through the summaries of the interactions. Still haven't nailed where large amounts of text should go in the database and correspondingly how to show them in the UI

## TO DO:
in between page for adding a new contact when their company doesn't yet exist. Wnat to be able to enter the info for a person and enter the company later or in that moment with another form or something
Same for interaction with a person who is not a contact yet

referals page?

screen shots will need to reflect all of these changes