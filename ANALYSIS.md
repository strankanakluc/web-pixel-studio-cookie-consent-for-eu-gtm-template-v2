# Web Pixel Studio Cookie Consent for EU - Komplexná Analýza

Analýza dátumu: 8. máj 2026  
Plugin verzia: 1.0.8

---

## 1. SUCCESS/ERROR HLÁŠKY A NOTIFIKÁCIE

### 1.1 Admin JavaScript I18n Hlášky

**Súbor:** [includes/class-admin.php](includes/class-admin.php#L82-L110)

```php
// Linky 82-110
wp_localize_script( 'ccwps-admin', 'ccwpsAdmin', [
    'nonce'       => wp_create_nonce( 'ccwps_admin' ),
    'ajaxUrl'     => admin_url( 'admin-ajax.php' ),
    'i18n'        => [
        'saved'         => $this->tx( 'Nastavenia uložené.' ),
        'error'         => $this->tx( 'Vyskytla sa chyba.' ),
        'confirmClear'  => $this->tx( 'Naozaj chcete vymazať všetky záznamy súhlasov?...' ),
        'confirmDelete' => $this->tx( 'Naozaj chcete odstrániť túto položku?' ),
        'confirmReset'  => $this->tx( 'Resetovať všetky nastavenia na predvolené hodnoty?' ),
        'confirmLangChange' => $this->tx( 'Zmeniť jazyk administrácie a aplikovať preklady na frontend?' ),
        'logCleared'    => $this->tx( 'Záznamy boli vymazané.' ),
        'langApplied'   => $this->tx( 'Jazyk bol aplikovaný. Uložte nastavenia.' ),
        'resetDone'     => $this->tx( 'Nastavenia boli resetované.' ),
        'saving'        => $this->tx( 'Ukladám…' ),
        ...
    ],
]);
```

**Funkcia `$this->tx()`:** Pretypovací helper na preklad reťazcov s fallback na SK texty.

### 1.2 HTML Import/Export Hlášky

**Súbor:** [includes/class-admin.php](includes/class-admin.php#L150-L160)

```php
// Linky 150-160
$import_notice = '';
if ( '' !== $this->get_query_string( 'ccwps_imported' ) ) {
    $import_notice = '1' === $this->get_query_string( 'ccwps_imported' )
        ? '<div class="ccwps-notice success">' . esc_html__( 'Nastavenia boli importované.', 'web-pixel-studio-cookie-consent-eu' ) . '</div>'
        : '<div class="ccwps-notice error">'   . esc_html__( 'Import zlyhal. Skontrolujte súbor.', 'web-pixel-studio-cookie-consent-eu' ) . '</div>';
}
```

**Logika:** HTML hlášky sa zobrazujú na základe query parametra `ccwps_imported`:
- `?ccwps_imported=1` → "Nastavenia boli importované."
- `?ccwps_imported=0` → "Import zlyhal. Skontrolujte súbor."

### 1.3 AJAX Response (Backend - bez správ v JSON)

**Súbor:** [includes/class-ajax.php](includes/class-ajax.php#L70-L118)

Všetky AJAX akcie volajú `wp_send_json_success()` alebo `wp_send_json_error()` **bez správy v dátach**:

```php
// Linky 70-71: clear_log
public function clear_log(): void {
    check_ajax_referer( 'ccwps_admin', 'nonce' );
    if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
    $this->log->clear_all();
    wp_send_json_success();  // Bez správy
}

// Linky 77-118: save_settings
public function save_settings(): void {
    // ... validácia ...
    $this->settings->set( $key, $value );
    wp_send_json_success();  // Bez správy - správa sa zobrazuje z JS
}
```

**Dôležité:** Hlášky sa pri AJAX akciách zobrazujú z JavaScriptu (ccwpsAdmin.i18n), nie z PHP backenda!

### 1.4 Request Cookie Preset Email Messages

**Súbor:** [includes/class-ajax.php](includes/class-ajax.php#L200-L280)

Validačné hlášky v `request_cookie_preset()`:

```php
// Validácia emailu
if ( ! is_email( $email ) ) {
    wp_send_json_error( __( 'Zadajte platný e-mail.', 'web-pixel-studio-cookie-consent-eu' ) );
}

// Validácia dĺžky predmetu
if ( $subject_length < 3 || $subject_length > 150 ) {
    wp_send_json_error( __( 'Predmet musí mať 3 až 150 znakov.', 'web-pixel-studio-cookie-consent-eu' ) );
}

// Cooldown limit
if ( $cooldown > 0 ) {
    wp_send_json_error( __( 'Počkajte prosím 30 sekúnd a skúste to znova.', 'web-pixel-studio-cookie-consent-eu' ) );
}
```

### 1.5 Preklady Hlášok

**Hlášky v admin textech:** [includes/admin-texts/cs.php](includes/admin-texts/cs.php)

Príklady mapovaní SK → CS:

```php
'Nastavenia uložené.' => 'Uložené',  // SK → CS preklad
'Vyskytla sa chyba.' => 'Chyba',
'Záznamy boli vymazané.' => 'Záznamy vymazané.',
```

Preklady sú dostupné v jazykových súboroch v `admin-texts/` pre všetky podporované jazyky.

---

## 2. SHORTCODES - KOMPLETNÁ REFERENCIA

### 2.1 Registrácia Shortcodov

**Súbor:** [includes/class-frontend.php](includes/class-frontend.php#L20-L26)

```php
public function __construct( CCWPS_Settings $settings ) {
    $this->settings = $settings;
    // ...
    // Shortcodes.
    add_shortcode( 'ccwps_consent_id',      [ $this, 'shortcode_consent_id' ] );
    add_shortcode( 'ccwps_cookie_list',     [ $this, 'shortcode_cookie_list' ] );
    add_shortcode( 'ccwps_manage_consent',  [ $this, 'shortcode_manage_consent' ] );
}
```

### 2.2 Shortcode: `[ccwps_consent_id]`

**Handler:** [includes/class-frontend.php](includes/class-frontend.php#L299-L333)

**Popis:** Zobrazuje jedinečný ID súhlasu návštevníka.

**Parametre:**
```
[ccwps_consent_id label="ID vášho súhlasu" wrapper="p" class="ccwps-consent-id-wrap"]
```

| Parameter | Predvolená | Popis |
|-----------|----------|-------|
| `label` | `$settings->get('lang_consent_id_label', 'ID vášho súhlasu')` | Text pred ID |
| `wrapper` | `p` | HTML wrapper (p, div, span) |
| `class` | `ccwps-consent-id-wrap` | CSS trieda |

**Ako funguje:**
1. Načíta `ccwps_consent` cookie
2. Dekóduje JSON → pole s `id` kľúčom
3. Zobrazí ID alebo "Súhlas nebol udelený."

**Kód:**
```php
$consent = $this->get_consent_from_cookie();
$consent_id = is_array( $consent ) && ! empty( $consent['id'] ) 
    ? sanitize_text_field( (string) $consent['id'] ) 
    : '';
```

### 2.3 Shortcode: `[ccwps_cookie_list]`

**Handler:** [includes/class-frontend.php](includes/class-frontend.php#L335-L410)

**Popis:** Zobrazuje tabuľku deklarovaných cookies zoskupených podľa kategórie.

**Parametre:**
```
[ccwps_cookie_list category="" class="ccwps-cookie-list-table"]
```

| Parameter | Predvolená | Popis |
|-----------|----------|-------|
| `category` | `` (všetky) | Filtruj podľa kategórie: `necessary`, `analytics`, `targeting`, `preferences` |
| `class` | `ccwps-cookie-list-table` | CSS trieda tabuľky |

**Ako funguje:**
1. Načíta cookies z DB cez `CCWPS_Cookie_Manager->get_all()` alebo `get_by_category()`
2. Zoskupí podľa kategórie
3. Načíta názvy kategórií z settings: `lang_necessary_title`, `lang_analytics_title`, atď.
4. Vyrenderuje HTML tabuľku

**Stĺpce tabuľky:** (texty z DB)
```php
'lang_cookie_name' → 'Názov'
'lang_cookie_domain' → 'Doména'
'lang_cookie_expiration' → 'Platnosť'
'lang_cookie_description' → 'Popis'
```

### 2.4 Shortcode: `[ccwps_manage_consent]`

**Handler:** [includes/class-frontend.php](includes/class-frontend.php#L412-L428)

**Popis:** Vloží tlačidlo, ktoré otvorí modál správy súglasu.

**Parametre:**
```
[ccwps_manage_consent label="Spravovať nastavenia" class="ccwps-manage-consent-btn" id="my-btn"]
```

| Parameter | Predvolená | Popis |
|-----------|----------|-------|
| `label` | `$settings->get('lang_manage_preferences', 'Customize')` | Text na tlačidle |
| `class` | `ccwps-manage-consent-btn` | CSS trieda tlačidla |
| `id` | `` | HTML ID atribút (voliteľné) |

**Output:**
```html
<button type="button" data-ccwps-manage-consent="1" ...>Spravovať nastavenia</button>
```

---

## 3. JAZYK - KAK SA URČUJE A APLIKUJE

### 3.1 Admin Jazyk

**Default:** `sk` (slovenčina)

**Uloženie:** Option `ccwps_admin_lang` (DB)

**Zmena:** AJAX akcia `ccwps_save_admin_lang` [includes/class-ajax.php](includes/class-ajax.php#L220)

```php
public function save_admin_lang(): void {
    $lang = sanitize_key( $this->get_posted_text( 'lang', 'sk' ) );
    $preset = CCWPS_Language_Presets::get( $lang );
    
    // Uloží admin jazyk
    $this->settings->set( 'admin_lang', $lang );
    
    // Aplikuje frontend preklady z presetu
    foreach ( $preset['strings'] as $key => $value ) {
        $this->settings->set( $key, ... );
    }
}
```

### 3.2 Frontend Jazyk - Určovanie

**Súbor:** [includes/class-settings.php](includes/class-settings.php#L169-L210)

```php
public function get_frontend_config(): array {
    // ...
    $admin_lang = (string) $opt( $s, 'admin_lang', 'en' );
    $frontend_language_presets = $this->get_frontend_language_presets( $s );
    $current_i18n = $this->get_current_frontend_i18n( $s );
    
    return [
        'currentFrontendLang'  => $admin_lang,
        'frontendLanguageFallback' => 'en',
        'frontendLanguagePresets'  => $frontend_language_presets,
        'detectVisitorLanguage'=> (bool) $opt( $s, 'frontend_detect_visitor_language', 0 ),
        'i18n' => $current_i18n,
    ];
}
```

**Logika Frontend Jazyka:**

1. **Bez detekcie (default):** Používa sa `admin_lang` a texty z DB (`lang_banner_title`, atď.)
2. **S detekcou (`frontend_detect_visitor_language = true`):**
   - Frontend JS sa pokúsi načítať jazyk z `Accept-Language` headera
   - Ak je dostupný v presets → použije sa ten
   - Ak nie → fallback na `en` (anglicky)

### 3.3 Frontend I18n Objekty

**Súbor:** [includes/class-settings.php](includes/class-settings.php#L214-L250)

```php
private function get_current_frontend_i18n( array $settings ): array {
    return [
        'bannerTitle'       => (string) ( $settings['lang_banner_title'] ?? '' ),
        'bannerDescription' => (string) ( $settings['lang_banner_description'] ?? '' ),
        'acceptAll'         => (string) ( $settings['lang_accept_all'] ?? '' ),
        'rejectAll'         => (string) ( $settings['lang_reject_all'] ?? '' ),
        'managePreferences' => (string) ( $settings['lang_manage_preferences'] ?? '' ),
        'savePreferences'   => (string) ( $settings['lang_save_preferences'] ?? '' ),
        'close'             => (string) ( $settings['lang_close'] ?? '' ),
        'necessaryTitle'    => (string) ( $settings['lang_necessary_title'] ?? '' ),
        'necessaryDesc'     => (string) ( $settings['lang_necessary_desc'] ?? '' ),
        'analyticsTitle'    => (string) ( $settings['lang_analytics_title'] ?? '' ),
        'analyticsDesc'     => (string) ( $settings['lang_analytics_desc'] ?? '' ),
        'targetingTitle'    => (string) ( $settings['lang_targeting_title'] ?? '' ),
        'targetingDesc'     => (string) ( $settings['lang_targeting_desc'] ?? '' ),
        'preferencesTitle'  => (string) ( $settings['lang_preferences_title'] ?? '' ),
        'preferencesDesc'   => (string) ( $settings['lang_preferences_desc'] ?? '' ),
        'cookieName'        => $this->resolve_frontend_label_setting( ... ),
        'cookieDomain'      => $this->resolve_frontend_label_setting( ... ),
        'cookieExpiration'  => $this->resolve_frontend_label_setting( ... ),
        'cookieDescription' => $this->resolve_frontend_label_setting( ... ),
    ];
}
```

**Všetky tieto texty sa podávajú na frontend v `ccwpsConfig.i18n` objektu.**

### 3.4 Language Presets

**Súbor:** [includes/class-language-presets.php](includes/class-language-presets.php)

Dostupné jazyky:
- `sk` - Slovenčina
- `en` - English
- `cs` - Čeština
- `de` - Deutsch
- `fr` - Français
- `es` - Español
- `pl` - Polski
- `hu` - Magyar
- `it` - Italiano

**Štruktúra presetu:**

```php
'en' => [
    'label'     => 'English',
    'flag'      => '🇬🇧',
    'flag_file' => 'GB',
    'admin_strings' => [ /* Admin UI texty */ ],
    'strings' => [ /* Frontend texty */ ],
    'admin_texts' => [ /* Mapovanie SK → EN */ ],
]
```

### 3.5 Cookie - Ako Se Jazyk Aplikuje

**Frontendová detekcia jazyka (ak je povolená):**

1. JavaScript si načíta `Accept-Language` header návštevníka
2. Porovná s `frontendLanguagePresets` (vrátené z `get_frontend_config()`)
3. Ak je jazyk dostupný → načíta texty z tohto presetu
4. Ak nie → použije `lang_en` alebo fallback `frontendLanguageFallback`

**Bez detekcie (aktuálne nastavenie):**

Všetky texty na frontende pochádzajú z:
```
ccwpsConfig.i18n  ← vráti get_current_frontend_i18n()
                   ← načítané z DB (ccwps_lang_* options)
                   ← aplikované pri zmene admin_lang
```

---

## 4. COOKIE MANAGER - KAK PRACUJE S TEXTAMI

### 4.1 Struktura Cookie v DB

**Tabuľka:** `wp_ccwps_cookies`

```sql
SELECT * FROM wp_ccwps_cookies;
```

| Stĺpec | Typ | Obsah |
|--------|-----|-------|
| `id` | INT | ID cookiea |
| `name` | VARCHAR | Názov (napr. `_ga`) |
| `domain` | VARCHAR | Doména |
| `expiration` | VARCHAR | Platnosť (napr. `2 roky`) |
| `path` | VARCHAR | Cesta (default `/`) |
| `description` | TEXT | **Lokalizovaný text** |
| `category` | VARCHAR | `necessary`, `analytics`, `targeting`, `preferences` |
| `is_regex` | TINYINT | Či je regex vzor (0/1) |

### 4.2 Get Grouped - Frontend Config

**Súbor:** [includes/class-cookie-manager.php](includes/class-cookie-manager.php#L95-L115)

```php
public function get_grouped(): array {
    $all = $this->get_all();
    $grouped = [];
    foreach ( $all as $cookie ) {
        $cat = $cookie['category'];
        if ( ! isset( $grouped[ $cat ] ) ) {
            $grouped[ $cat ] = [];
        }
        $grouped[ $cat ][] = [
            'name'       => $cookie['name'],
            'domain'     => $cookie['domain'],
            'expiration' => $cookie['expiration'],
            'path'       => $cookie['path'],
            'desc'       => $cookie['description'],  // ← Priamo z DB
            'isRegex'    => (bool) $cookie['is_regex'],
        ];
    }
    return $grouped;
}
```

**Dôležité:** Cookie popisy pochádzajú **priamo z DB** (stĺpec `description`), bez ďalšej lokalizácie!

### 4.3 Ako Sa Zobrazujú v Shortcode

**V `shortcode_cookie_list()`** [includes/class-frontend.php](includes/class-frontend.php#L335-L410):

```php
// Načítaj všetky cookies
$all = $manager->get_all();

// Zoskup podľa kategórie
foreach ( $all as $ck ) {
    $cookies_by_cat[ $ck['category'] ][] = $ck;
}

// Načítaj názvy kategórií z DB
$cat_labels = [
    'necessary'   => $s->get( 'lang_necessary_title',   'Nevyhnutné' ),
    'analytics'   => $s->get( 'lang_analytics_title',   'Analytické' ),
    'targeting'   => $s->get( 'lang_targeting_title',   'Marketingové' ),
    'preferences' => $s->get( 'lang_preferences_title', 'Preferenčné' ),
];

// Vyrenderuj tabuľku
foreach ( $cookies_by_cat as $cat => $cookies ) {
    // Názov kategórie
    echo $cat_labels[ $cat ];
    
    // Tabuľka
    foreach ( $cookies as $ck ) {
        echo $ck['name'];        // Bez lokalizácie
        echo $ck['domain'];      // Bez lokalizácie
        echo $ck['expiration'];  // Bez lokalizácie
        echo $ck['description']; // Bez lokalizácie (čakajú sa už v správnom jazyku v DB)
    }
}
```

**Hlava tabuľky (lokalizovaná z DB):**
```php
<th><?php echo esc_html( $s->get( 'lang_cookie_name', 'Názov' ) ); ?></th>
<th><?php echo esc_html( $s->get( 'lang_cookie_domain', 'Doména' ) ); ?></th>
<th><?php echo esc_html( $s->get( 'lang_cookie_expiration', 'Platnosť' ) ); ?></th>
<th><?php echo esc_html( $s->get( 'lang_cookie_description', 'Popis' ) ); ?></th>
```

---

## 5. NASTAVENIA - KDE SÚ ULOŽENÉ

### 5.1 Database Options

Všetky nastavenia sú uložené ako WordPress options s prefixom `ccwps_`:

```sql
SELECT option_name, option_value 
FROM wp_options 
WHERE option_name LIKE 'ccwps_%' 
ORDER BY option_name;
```

**Príklady:**
```
ccwps_admin_lang                    = 'sk'
ccwps_lang_banner_title            = 'Nastavenia cookies'
ccwps_lang_banner_description      = 'Táto stránka používa cookies...'
ccwps_lang_accept_all              = 'Prijať všetky'
ccwps_lang_reject_all              = 'Odmietnuť všetky'
ccwps_lang_manage_preferences      = 'Spravovať nastavenia'
ccwps_lang_necessary_title         = 'Nevyhnutné'
ccwps_lang_necessary_desc          = 'Nevyhnutné cookies sú...'
...
ccwps_primary_color                = '#1a73e8'
ccwps_text_color                   = '#333333'
```

### 5.2 Registrované Kľúče

**Súbor:** [includes/class-settings.php](includes/class-settings.php#L50-L80)

```php
private function get_known_keys(): array {
    $keys = [
        'admin_lang',
        'autorun', 'force_consent', 'auto_clear_cookies', 'page_scripts',
        'hide_from_bots', 'reconsent', 'record_consents', 
        'frontend_detect_visitor_language', 'hide_empty_categories',
        'delay', 'cookie_expiration', 'cookie_path', 'cookie_domain',
        'consent_mode_version', 'gtm_id',
        'matomo_url', 'matomo_site_id', 'matomo_anonymous_without_consent',
        'banner_layout', 'banner_position', 'banner_show_icon',
        'icon_position', 'icon_type', 'icon_custom_url', 'font_family',
        // Farby
        'primary_color', 'banner_title_color', 'text_color', 'bg_color', ...
        // Texty
        'lang_banner_title', 'lang_banner_description',
        'lang_accept_all', 'lang_reject_all', 'lang_manage_preferences',
        'lang_necessary_title', 'lang_necessary_desc',
        'lang_analytics_title', 'lang_analytics_desc',
        'lang_targeting_title', 'lang_targeting_desc',
        'lang_preferences_title', 'lang_preferences_desc',
        'lang_cookie_name', 'lang_cookie_domain', 'lang_cookie_expiration', ...
    ];
}
```

### 5.3 Get/Set Helpers

**Súbor:** [includes/class-settings.php](includes/class-settings.php#L20-L45)

```php
public function get( string $key, $default = null ) {
    if ( ! array_key_exists( $key, $this->cache ) ) {
        $this->cache[ $key ] = get_option( 'ccwps_' . $key, $default );
    }
    return $this->cache[ $key ];
}

public function set( string $key, $value ): bool {
    $this->cache[ $key ] = $value;
    $this->all_cache = null;
    $this->register_option_key( $key );
    return update_option( 'ccwps_' . $key, $value );
}
```

---

## ZHRNUTIE - DÔLEŽITÉ BODY

| Aspekt | Lokalizácia | Uloženie | Zdroj |
|--------|------------|---------|-------|
| **Admin jazyk** | SK, EN, CS, DE, FR, ES, PL, HU, IT | `ccwps_admin_lang` (DB) | Language Presets |
| **Frontend texty** | Z DB (lang_*) | `ccwps_lang_*` options (DB) | DB + Language Presets |
| **Cookie popisy** | Text v DB (stĺpec `description`) | `wp_ccwps_cookies.description` (DB) | Priamo zadané v admin |
| **Kategória názvy** | Z DB (lang_necessary_title, atď.) | `ccwps_lang_*_title` (DB) | DB + Language Presets |
| **Success hlášky** | V admin JS + HTML notice | `class-admin.php` `i18n` | JS `ccwpsAdmin.i18n` |
| **Shortcode texty** | Z DB cez `$settings->get()` | `ccwps_lang_*` (DB) | Settings helper |

---

## PRÍKLADY POUŽITIA

### Ako Zmeniť Jazyk Backendu
```php
$settings = new CCWPS_Settings();
$settings->set( 'admin_lang', 'en' );
$settings->set( 'lang_banner_title', 'Cookie Settings' );
```

### Ako Načítať Frontend Config
```php
$settings = new CCWPS_Settings();
$config = $settings->get_frontend_config();
// Vracia pole s: i18n, colors, cookies, blockingRules, atď.
```

### Ako Pridať Cookie s Popisom
```php
$manager = new CCWPS_Cookie_Manager();
$manager->insert( [
    'name' => '_ga',
    'domain' => '.example.com',
    'expiration' => '2 roky',
    'path' => '/',
    'description' => 'Google Analytics sledovanie',
    'category' => 'analytics',
    'is_regex' => 0,
] );
```
