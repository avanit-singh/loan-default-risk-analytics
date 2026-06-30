-- ============================================================
-- Loan Default Risk Analytics — Star Schema (PostgreSQL)
-- Save as sql/schema/schema.sql
--
-- Dimensions are limited to genuinely low-cardinality, reused
-- attributes (date, grade, purpose, geography, a junk dimension
-- for employment flags). Everything else — income, FICO, DTI,
-- payment/outcome fields — lives on the fact table at loan grain,
-- since it doesn't repeat across rows in this dataset.
-- ============================================================

CREATE TABLE dim_date (
    date_key        INT PRIMARY KEY,        -- YYYYMM, e.g. 201501
    full_date       DATE NOT NULL,
    year            SMALLINT NOT NULL,
    quarter         SMALLINT NOT NULL,
    month           SMALLINT NOT NULL,
    month_name      VARCHAR(10) NOT NULL
);

CREATE TABLE dim_grade (
    grade_key       SERIAL PRIMARY KEY,
    grade           CHAR(1) NOT NULL,
    sub_grade       VARCHAR(2) NOT NULL,
    UNIQUE (grade, sub_grade)
);

CREATE TABLE dim_purpose (
    purpose_key     SERIAL PRIMARY KEY,
    purpose         VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_geography (
    geography_key   SERIAL PRIMARY KEY,
    state           CHAR(2) UNIQUE NOT NULL
);

-- Junk dimension: groups small categorical flags instead of
-- giving emp_length / home_ownership / verification_status
-- their own tiny tables.
CREATE TABLE dim_employment (
    employment_key       SERIAL PRIMARY KEY,
    emp_length           VARCHAR(20) NOT NULL,
    home_ownership        VARCHAR(20) NOT NULL,
    verification_status   VARCHAR(30) NOT NULL,
    UNIQUE (emp_length, home_ownership, verification_status)
);

-- One row per loan
CREATE TABLE fact_loans (
    loan_id              BIGINT PRIMARY KEY,
    date_key             INT REFERENCES dim_date(date_key),
    grade_key            INT REFERENCES dim_grade(grade_key),
    purpose_key          INT REFERENCES dim_purpose(purpose_key),
    geography_key        INT REFERENCES dim_geography(geography_key),
    employment_key        INT REFERENCES dim_employment(employment_key),

    -- loan terms
    loan_amnt             NUMERIC(10,2),
    funded_amnt           NUMERIC(10,2),
    term_months            SMALLINT,
    int_rate               NUMERIC(5,2),
    installment             NUMERIC(10,2),

    -- borrower profile at origination
    annual_inc             NUMERIC(12,2),
    dti                     NUMERIC(6,2),
    fico_range_low          SMALLINT,
    fico_range_high          SMALLINT,
    open_acc                 SMALLINT,
    total_acc                 SMALLINT,
    revol_bal                 NUMERIC(12,2),
    revol_util                 NUMERIC(6,2),
    delinq_2yrs                 SMALLINT,
    inq_last_6mths               SMALLINT,
    pub_rec                       SMALLINT,

    -- outcome / performance — post-origination, fine for BI,
    -- must be EXCLUDED from ML features (data leakage)
    loan_status              VARCHAR(30),
    is_default                BOOLEAN,        -- true/false/NULL (still active)
    total_pymnt                 NUMERIC(12,2),
    total_rec_prncp              NUMERIC(12,2),
    total_rec_int                  NUMERIC(12,2),
    recoveries                       NUMERIC(12,2),
    out_prncp                          NUMERIC(12,2)
);

CREATE INDEX idx_fact_loans_date ON fact_loans(date_key);
CREATE INDEX idx_fact_loans_grade ON fact_loans(grade_key);
CREATE INDEX idx_fact_loans_status ON fact_loans(loan_status);
CREATE INDEX idx_fact_loans_default ON fact_loans(is_default);
