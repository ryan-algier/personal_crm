"""
app.py

Main Flask application for the Networking CRM.
Run with: uv run flask --app app run

Routes:
    /                       Home — summary counts
    /contacts               List all contacts
    /contacts/add           Add a new contact
    /contacts/quick-add     Quick-add a contact via modal (POST, returns JSON)
    /contacts/<id>/edit     Edit a contact
    /contacts/<id>/delete   Delete a contact
    /companies              List all companies
    /companies/add          Add a new company
    /companies/quick-add    Quick-add a company via modal (POST, returns JSON)
    /companies/<id>/edit    Edit a company
    /companies/<id>/delete  Delete a company
    /interactions           List all interactions
    /interactions/add       Add a new interaction
    /interactions/<id>/edit     Edit an interaction
    /interactions/<id>/delete   Delete an interaction
"""

from flask import Flask, render_template, request, redirect, url_for, flash
from db import get_db, close_db
from datetime import date
import os

app = Flask(__name__)
## to generate a key, use: python -c "import secrets; print(secrets.token_hex(32))"
app.secret_key = os.getenv("SECRET_KEY")  # required for flash messages

@app.template_filter('format_phone')
def format_phone(phone):
    """Format a 10-digit phone number as (###)-###-####."""
    if not phone:
        return '—'
    digits = ''.join(filter(str.isdigit, str(phone)))
    if len(digits) == 10:
        return f"({digits[:3]})-{digits[3:6]}-{digits[6:]}"
    return phone  # return as-is if not 10 digits

# ── Dropdown options ──────────────────────────────────────────────────────────

HOW_WE_MET_OPTIONS = [
    "LinkedIn",
    "Career Fair",
    "Referral",
    "Cold Outreach",
    "Conference",
    "Networking Event",
    "University",
    "Work",
    "Other",
]

INTERACTION_TYPE_OPTIONS = [
    "Email",
    "LinkedIn Message",
    "Phone Call",
    "Coffee Chat",
    "Video Call",
    "In Person Meeting",
    "Thank You",
    "Other",
]

# ── Home ──────────────────────────────────────────────────────────────────────

@app.route("/")
def home():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT COUNT(*) AS count FROM contacts")
    contact_count = cursor.fetchone()["count"]
    cursor.execute("SELECT COUNT(*) AS count FROM companies")
    company_count = cursor.fetchone()["count"]
    cursor.execute("SELECT COUNT(*) AS count FROM interactions")
    interaction_count = cursor.fetchone()["count"]
    cursor.execute("SELECT COUNT(*) AS count FROM referrals")
    referral_count = cursor.fetchone()["count"]
    cursor.execute("""
        SELECT DISTINCT
            c.id,
            CONCAT(c.first_name, ' ', c.last_name) AS contact_name
        FROM interactions i
        JOIN contacts c ON i.contact_id = c.id
        WHERE i.thank_you_required = 1
        AND LOWER(i.type) != 'thank you'
        AND NOT EXISTS (
            SELECT 1 FROM interactions ty
            WHERE ty.contact_id = i.contact_id
            AND LOWER(ty.type) = 'thank you'
            AND ty.date > i.date
        )
        ORDER BY contact_name
    """)
    thank_you_needed = cursor.fetchall()
    close_db(conn, cursor)
    return render_template(
        "home.html",
        contact_count=contact_count,
        company_count=company_count,
        interaction_count=interaction_count,
        referral_count=referral_count,
        thank_you_needed=thank_you_needed,
    )

# ── Contacts ──────────────────────────────────────────────────────────────────

@app.route("/contacts")
def contacts():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
            c.id, c.first_name, c.last_name, c.email, c.phone, c.location,
            c.how_we_met, c.met_on, c.company_id, c.updated_at,
            co.name AS company_name,
            CONCAT(ref.first_name, ' ', ref.last_name) AS referred_by
        FROM contacts c
        LEFT JOIN companies co ON c.company_id = co.id
        LEFT JOIN referrals r ON r.referred_id = c.id
        LEFT JOIN contacts ref ON r.referrer_id = ref.id
        ORDER BY c.last_name, c.first_name
    """)
    contacts = cursor.fetchall()
    close_db(conn, cursor)
    return render_template("contacts/index.html", contacts=contacts)


@app.route("/contacts/add", methods=["GET", "POST"])
def add_contact():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    # Fetch companies and contacts for dropdowns
    cursor.execute("SELECT id, name FROM companies ORDER BY name")
    companies = cursor.fetchall()
    cursor.execute("SELECT id, first_name, last_name FROM contacts ORDER BY last_name, first_name")
    all_contacts = cursor.fetchall()

    if request.method == "POST":
        first_name = request.form.get("first_name", "").strip()
        last_name = request.form.get("last_name", "").strip()
        email = request.form.get("email", "").strip() or None
        phone = request.form.get("phone", "").strip() or None
        linkedin_url = request.form.get("linkedin_url", "").strip() or None
        location = request.form.get("location", "").strip() or None
        how_we_met = request.form.get("how_we_met") or None
        met_on = request.form.get("met_on") or None
        company_id = request.form.get("company_id") or None
        referrer_id = request.form.get("referrer_id") or None

        # Validation
        errors = []
        if not first_name:
            errors.append("First name is required.")
        if not last_name:
            errors.append("Last name is required.")

        if errors:
            for error in errors:
                flash(error, "danger")
        else:
            try:
                # Insert contact
                cursor.execute("""
                    INSERT INTO contacts 
                    (company_id, first_name, last_name, email, phone, linkedin_url, location, how_we_met, met_on)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (company_id, first_name, last_name, email, phone, linkedin_url, location, how_we_met, met_on))
                new_contact_id = cursor.lastrowid

                # Insert referral if provided
                if referrer_id:
                    cursor.execute("""
                        INSERT INTO referrals (referrer_id, referred_id)
                        VALUES (%s, %s)
                    """, (referrer_id, new_contact_id))

                conn.commit()
                flash(f"{first_name} {last_name} added successfully.", "success")
                close_db(conn, cursor)
                return redirect(url_for("contacts"))
            except Exception as e:
                conn.rollback()
                flash(f"Error adding contact: {e}", "danger")

    close_db(conn, cursor)
    return render_template(
        "contacts/add.html",
        companies=companies,
        all_contacts=all_contacts,
        how_we_met_options=HOW_WE_MET_OPTIONS,
    )


@app.route("/contacts/<int:contact_id>/edit", methods=["GET", "POST"])
def edit_contact(contact_id):
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM contacts WHERE id = %s", (contact_id,))
    contact = cursor.fetchone()
    if not contact:
        flash("Contact not found.", "danger")
        return redirect(url_for("contacts"))

    cursor.execute("SELECT id, name FROM companies ORDER BY name")
    companies = cursor.fetchall()

    # Exclude self from referrer dropdown
    cursor.execute("SELECT id, first_name, last_name FROM contacts WHERE id != %s ORDER BY last_name, first_name", (contact_id,))
    all_contacts = cursor.fetchall()

    # Get existing referrer if any
    cursor.execute("SELECT referrer_id FROM referrals WHERE referred_id = %s LIMIT 1", (contact_id,))
    referral = cursor.fetchone()
    current_referrer_id = referral["referrer_id"] if referral else None

    if request.method == "POST":
        first_name = request.form.get("first_name", "").strip()
        last_name = request.form.get("last_name", "").strip()
        email = request.form.get("email", "").strip() or None
        phone = request.form.get("phone", "").strip() or None
        linkedin_url = request.form.get("linkedin_url", "").strip() or None
        location = request.form.get("location", "").strip() or None
        how_we_met = request.form.get("how_we_met") or None
        met_on = request.form.get("met_on") or None
        company_id = request.form.get("company_id") or None
        referrer_id = request.form.get("referrer_id") or None

        errors = []
        if not first_name:
            errors.append("First name is required.")
        if not last_name:
            errors.append("Last name is required.")

        if errors:
            for error in errors:
                flash(error, "danger")
        else:
            try:
                cursor.execute("""
                    UPDATE contacts SET
                        company_id = %s, first_name = %s, last_name = %s,
                        email = %s, phone = %s, linkedin_url = %s,
                        location = %s, how_we_met = %s, met_on = %s
                    WHERE id = %s
                """, (company_id, first_name, last_name, email, phone,
                      linkedin_url, location, how_we_met, met_on, contact_id))

                # Update referral — delete existing and re-insert if provided
                cursor.execute("DELETE FROM referrals WHERE referred_id = %s", (contact_id,))
                if referrer_id:
                    cursor.execute("""
                        INSERT INTO referrals (referrer_id, referred_id)
                        VALUES (%s, %s)
                    """, (referrer_id, contact_id))

                conn.commit()
                flash(f"{first_name} {last_name} updated successfully.", "success")
                close_db(conn, cursor)
                return redirect(url_for("contacts"))
            except Exception as e:
                conn.rollback()
                flash(f"Error updating contact: {e}", "danger")

    close_db(conn, cursor)
    return render_template(
        "contacts/edit.html",
        contact=contact,
        companies=companies,
        all_contacts=all_contacts,
        how_we_met_options=HOW_WE_MET_OPTIONS,
        current_referrer_id=current_referrer_id,
    )


@app.route("/contacts/<int:contact_id>/delete", methods=["POST"])
def delete_contact(contact_id):
    conn = get_db()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM contacts WHERE id = %s", (contact_id,))
        conn.commit()
        flash("Contact deleted.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error deleting contact: {e}", "danger")
    finally:
        close_db(conn, cursor)
    return redirect(url_for("contacts"))


@app.route("/contacts/quick-add", methods=["POST"])
def quick_add_contact():
    """
    Minimal contact creation endpoint used by the modal on the add interaction page.
    Returns JSON so JavaScript can add the new contact to the dropdown without a page reload.
    """
    from flask import jsonify

    first_name = request.form.get("first_name", "").strip()
    last_name = request.form.get("last_name", "").strip()
    company_id = request.form.get("company_id") or None
    how_we_met = request.form.get("how_we_met") or None
    met_on = request.form.get("met_on") or None

    if not first_name or not last_name:
        return jsonify({"success": False, "error": "First and last name are required."}), 400

    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            INSERT INTO contacts (first_name, last_name, company_id, how_we_met, met_on)
            VALUES (%s, %s, %s, %s, %s)
        """, (first_name, last_name, company_id, how_we_met, met_on))
        conn.commit()
        new_id = cursor.lastrowid
        return jsonify({
            "success": True,
            "id": new_id,
            "name": f"{first_name} {last_name}",
        })
    except Exception as e:
        conn.rollback()
        return jsonify({"success": False, "error": str(e)}), 500
    finally:
        close_db(conn, cursor)


# ── Companies ─────────────────────────────────────────────────────────────────

@app.route("/companies")
def companies():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT co.id, co.name, co.industry, co.website, co.notes,
               COUNT(c.id) AS contact_count
        FROM companies co
        LEFT JOIN contacts c ON c.company_id = co.id
        GROUP BY co.id
        ORDER BY co.name
    """)
    companies = cursor.fetchall()
    close_db(conn, cursor)
    return render_template("companies/index.html", companies=companies)


@app.route("/companies/add", methods=["GET", "POST"])
def add_company():
    if request.method == "POST":
        name = request.form.get("name", "").strip()
        industry = request.form.get("industry", "").strip() or None
        website = request.form.get("website", "").strip() or None
        notes = request.form.get("notes", "").strip() or None

        if not name:
            flash("Company name is required.", "danger")
        else:
            conn = get_db()
            cursor = conn.cursor()
            try:
                cursor.execute("""
                    INSERT INTO companies (name, industry, website, notes)
                    VALUES (%s, %s, %s, %s)
                """, (name, industry, website, notes))
                conn.commit()
                flash(f"{name} added successfully.", "success")
                return redirect(url_for("companies"))
            except Exception as e:
                conn.rollback()
                flash(f"Error adding company: {e}", "danger")
            finally:
                close_db(conn, cursor)

    return render_template("companies/add.html")


@app.route("/companies/<int:company_id>/edit", methods=["GET", "POST"])
def edit_company(company_id):
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM companies WHERE id = %s", (company_id,))
    company = cursor.fetchone()
    if not company:
        flash("Company not found.", "danger")
        return redirect(url_for("companies"))

    if request.method == "POST":
        name = request.form.get("name", "").strip()
        industry = request.form.get("industry", "").strip() or None
        website = request.form.get("website", "").strip() or None
        notes = request.form.get("notes", "").strip() or None

        if not name:
            flash("Company name is required.", "danger")
        else:
            try:
                cursor.execute("""
                    UPDATE companies SET name = %s, industry = %s, website = %s, notes = %s
                    WHERE id = %s
                """, (name, industry, website, notes, company_id))
                conn.commit()
                flash(f"{name} updated successfully.", "success")
                close_db(conn, cursor)
                return redirect(url_for("companies"))
            except Exception as e:
                conn.rollback()
                flash(f"Error updating company: {e}", "danger")

    close_db(conn, cursor)
    return render_template("companies/edit.html", company=company)


@app.route("/companies/<int:company_id>/delete", methods=["POST"])
def delete_company(company_id):
    conn = get_db()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM companies WHERE id = %s", (company_id,))
        conn.commit()
        flash("Company deleted.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error deleting company: {e}", "danger")
    finally:
        close_db(conn, cursor)
    return redirect(url_for("companies"))


@app.route("/companies/quick-add", methods=["POST"])
def quick_add_company():
    """
    Minimal company creation endpoint used by the modal on contact add/edit pages.
    Returns JSON so JavaScript can add the new company to the dropdown without a page reload.
    """
    from flask import jsonify

    name     = request.form.get("name", "").strip()
    industry = request.form.get("industry", "").strip() or None
    website  = request.form.get("website", "").strip() or None

    if not name:
        return jsonify({"success": False, "error": "Company name is required."}), 400

    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            INSERT INTO companies (name, industry, website)
            VALUES (%s, %s, %s)
        """, (name, industry, website))
        conn.commit()
        new_id = cursor.lastrowid
        return jsonify({
            "success": True,
            "id": new_id,
            "name": name,
        })
    except Exception as e:
        conn.rollback()
        return jsonify({"success": False, "error": str(e)}), 500
    finally:
        close_db(conn, cursor)


# ── Interactions ──────────────────────────────────────────────────────────────

@app.route("/interactions")
def interactions():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT i.id, i.date, i.type, i.summary, i.outcome, i.thank_you_required,
               i.contact_id,
               CONCAT(c.first_name, ' ', c.last_name) AS contact_name,
               CASE
                   WHEN i.thank_you_required = 0 THEN 'not_required'
                   WHEN i.type = 'Thank You' THEN 'is_thank_you'
                   WHEN EXISTS (
                       SELECT 1 FROM interactions ty
                       WHERE ty.contact_id = i.contact_id
                       AND LOWER(ty.type) = 'thank you'
                       AND ty.date > i.date
                   ) THEN 'sent'
                   ELSE 'missing'
               END AS thank_you_status
        FROM interactions i
        JOIN contacts c ON i.contact_id = c.id
        ORDER BY i.date DESC
    """)
    interactions = cursor.fetchall()
    close_db(conn, cursor)
    return render_template("interactions/index.html", interactions=interactions)


@app.route("/interactions/add", methods=["GET", "POST"])
def add_interaction():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, first_name, last_name FROM contacts ORDER BY last_name, first_name")
    all_contacts = cursor.fetchall()
    cursor.execute("SELECT id, name FROM companies ORDER BY name")
    companies = cursor.fetchall()

    # Pre-fill values from query parameters (e.g. from home page thank you button)
    prefill_contact_id = request.args.get("contact_id", "")
    prefill_type = request.args.get("type", "")

    if request.method == "POST":
        contact_id = request.form.get("contact_id") or None
        interaction_date = request.form.get("date") or None
        type_ = request.form.get("type") or None
        summary = request.form.get("summary", "").strip() or None
        outcome = request.form.get("outcome", "").strip() or None
        thank_you_required = 1 if request.form.get("thank_you_required") else 0

        if not contact_id:
            flash("Contact is required.", "danger")
        else:
            try:
                cursor.execute("""
                    INSERT INTO interactions (contact_id, date, type, summary, outcome, thank_you_required)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, (contact_id, interaction_date, type_, summary, outcome, thank_you_required))
                conn.commit()
                flash("Interaction added successfully.", "success")
                close_db(conn, cursor)
                return redirect(url_for("interactions"))
            except Exception as e:
                conn.rollback()
                flash(f"Error adding interaction: {e}", "danger")

    close_db(conn, cursor)
    return render_template(
        "interactions/add.html",
        all_contacts=all_contacts,
        companies=companies,
        interaction_type_options=INTERACTION_TYPE_OPTIONS,
        how_we_met_options=HOW_WE_MET_OPTIONS,
        today=date.today().isoformat(),
        prefill_contact_id=prefill_contact_id,
        prefill_type=prefill_type,
    )


@app.route("/interactions/<int:interaction_id>/edit", methods=["GET", "POST"])
def edit_interaction(interaction_id):
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM interactions WHERE id = %s", (interaction_id,))
    interaction = cursor.fetchone()
    if not interaction:
        flash("Interaction not found.", "danger")
        return redirect(url_for("interactions"))

    cursor.execute("SELECT id, first_name, last_name FROM contacts ORDER BY last_name, first_name")
    all_contacts = cursor.fetchall()

    if request.method == "POST":
        contact_id = request.form.get("contact_id") or None
        date = request.form.get("date") or None
        type_ = request.form.get("type") or None
        summary = request.form.get("summary", "").strip() or None
        outcome = request.form.get("outcome", "").strip() or None
        thank_you_required = 1 if request.form.get("thank_you_required") else 0

        if not contact_id:
            flash("Contact is required.", "danger")
        else:
            try:
                cursor.execute("""
                    UPDATE interactions SET
                        contact_id = %s, date = %s, type = %s,
                        summary = %s, outcome = %s, thank_you_required = %s
                    WHERE id = %s
                """, (contact_id, date, type_, summary, outcome, thank_you_required, interaction_id))
                conn.commit()
                flash("Interaction updated successfully.", "success")
                close_db(conn, cursor)
                return redirect(url_for("interactions"))
            except Exception as e:
                conn.rollback()
                flash(f"Error updating interaction: {e}", "danger")

    close_db(conn, cursor)
    return render_template(
        "interactions/edit.html",
        interaction=interaction,
        all_contacts=all_contacts,
        interaction_type_options=INTERACTION_TYPE_OPTIONS,
    )


@app.route("/interactions/<int:interaction_id>/delete", methods=["POST"])
def delete_interaction(interaction_id):
    conn = get_db()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM interactions WHERE id = %s", (interaction_id,))
        conn.commit()
        flash("Interaction deleted.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error deleting interaction: {e}", "danger")
    finally:
        close_db(conn, cursor)
    return redirect(url_for("interactions"))


# ── Run ───────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    app.run(debug=True)
