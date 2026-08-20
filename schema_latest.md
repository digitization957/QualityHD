# QualityHD — Complete DB Schema (as built)

## DB: `qualityhd` (owned by app, user `qualityhd_app` least-privilege)

### Table: `hd_items`
1 row = 1 HD item. Never split across plants — each affected plant just fills its own status/details/date columns on the same row.

```sql
CREATE TABLE hd_items (
    id                      INT AUTO_INCREMENT PRIMARY KEY,

    -- Core fields
    hd_theme                VARCHAR(255) NOT NULL,
    improvement_type        VARCHAR(20)  NOT NULL,   -- Reactive / Proactive
    hd_source_plant         VARCHAR(50)  NOT NULL,   -- plant that logged it
    aggregate_type          VARCHAR(50)  NOT NULL,
    description             VARCHAR(250) NOT NULL,
    model_family            VARCHAR(20)  NOT NULL,
    issue_source            VARCHAR(50)  NOT NULL,
    cases_count             INT          NOT NULL,
    analysis_details        VARCHAR(250) NOT NULL,
    action_details          VARCHAR(250) NOT NULL,
    improvement_category    VARCHAR(50)  NOT NULL,
    hd_applicable_plants    VARCHAR(255) NOT NULL,   -- comma list, e.g. "NGP,ZHB"
    responsible_persons     VARCHAR(500) NOT NULL,   -- comma list of emails
    attachments             VARCHAR(2000),           -- comma list of stored filenames

    -- Per-plant ORC tracking (x6 plants, same pattern repeated)
    ngp_orc_status          VARCHAR(20)  DEFAULT 'Open',
    ngp_hd_details          VARCHAR(250),
    ngp_target_date         DATE,

    zhb_orc_status          VARCHAR(20)  DEFAULT 'Open',
    zhb_hd_details          VARCHAR(250),
    zhb_target_date         DATE,

    rdp_orc_status          VARCHAR(20)  DEFAULT 'Open',
    rdp_hd_details          VARCHAR(250),
    rdp_target_date         DATE,

    jpr_orc_status          VARCHAR(20)  DEFAULT 'Open',
    jpr_hd_details          VARCHAR(250),
    jpr_target_date         DATE,

    rjk_orc_status          VARCHAR(20)  DEFAULT 'Not Applicable',
    rjk_hd_details          VARCHAR(250),
    rjk_target_date         DATE,

    knd_orc_status          VARCHAR(20)  DEFAULT 'Not Applicable',
    knd_hd_details          VARCHAR(250),
    knd_target_date         DATE,

    -- Meta
    created_by_role         VARCHAR(20)  NOT NULL,
    created_at              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

Whitelisted values (enforced server-side in `HdOptions.cs`, not DB constraints):
- improvement_type: Reactive, Proactive
- aggregate_type: Tractor, Transmission, Engine, VTU Assembly, CV Assembly, Machine Shop, Front Axle, PTCD, Paint Shop
- model_family: H1, H2, YT+, Novo, OJA, JIVO, H3, H1R
- issue_source: Domestic CVL, CLR, Traveler Card, IO CVL, IO Field Issue, Proactive Improvement, Gate Audit
- improvement_category: Poka-Yoke, Process Improvement, Supplier Process Improvement, Facility Improvement, Part Standardisation, Design Improvement
- *_orc_status: Open, R1, R2, Closed, Initiator, Not Applicable
- plant names: fetched live from `plant_master.tbl_Plant` (not hardcoded)

---

## DB: `plant_master` (local dev copy of external/prod DB, read-only app user)

### Table: `tbl_Plant`
```sql
CREATE TABLE tbl_Plant (
    Plant_ID    INT PRIMARY KEY,
    Plant_Name  VARCHAR(50) NOT NULL
);
```
Seeded with 6 plants: NGP, ZHB, RDP, JPR, RJK, KND.

---

## DB: `access` (external prod DB — not created locally, connection string is a placeholder)

### Table: `login_tokenpass`
```sql
CREATE TABLE login_tokenpass (
    Token     VARCHAR(255) PRIMARY KEY,
    Plant_ID  INT NOT NULL
);
```
Used only by `PlantHelper.ResolvePlantByToken()` — not wired into live login yet (Login.aspx currently uses hardcoded demo dropdowns instead).

---

That's the whole schema. Nothing else touches the DB.
