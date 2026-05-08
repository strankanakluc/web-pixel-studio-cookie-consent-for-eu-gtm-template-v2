=== Web Pixel Studio Cookie Consent for EU ===
Contributors: duddi, wpssk, webpixelstudio
Tags: cookie consent, GDPR, cookie banner, ePrivacy, google consent mode
Requires at least: 5.9
Tested up to: 6.9
Requires PHP: 7.4
Stable tag: 1.0.7
License: GPL-2.0-or-later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

Modern GDPR/ePrivacy cookie consent plugin with Google Consent Mode v2/v3, Matomo support, script blocking and consent logging.

== Description ==

🚀 **Web Pixel Studio Cookie Consent for EU** helps WordPress websites comply with GDPR and ePrivacy requirements using a modern, fast and fully customizable consent solution.

Built on the powerful Orest Bida CookieConsent library, the plugin extends it with advanced WordPress features including:

✔ Google Consent Mode v2 & v3  
✔ Matomo integration (strict or anonymous mode)  
✔ Script blocking before consent  
✔ Consent logging with export  
✔ Cookie declarations  
✔ Floating consent icon  
✔ Translation presets  
✔ Full visual customization  
✔ Import / Export settings  
✔ Re-consent support  
✔ No Google dependency required  

Perfect for:
- Businesses
- WooCommerce stores
- Agencies
- Public sector websites
- Schools & universities
- Healthcare organizations
- Privacy-focused projects

---

= ✨ Main Features =

= 🍪 Modern Cookie Banner & Preferences Modal =

Create a beautiful and accessible consent experience:

- Box, Bar or Cloud layouts
- 7 banner positions
- Fully animated UI
- Full-screen preferences modal
- Accept All / Reject All / Manage Preferences
- Category-based consent:
  - Necessary
  - Analytics
  - Preferences
  - Targeting
- Mobile-friendly & accessible

---

= 📊 Google Consent Mode v2 & v3 =

Supports Google's latest consent requirements for EU traffic.

Features include:
- Automatic default denied state
- Consent updates via `gtag('consent', 'update', ...)`
- Google Ads & GA4 compatibility
- Consent Mode v2 support
- Consent Mode v3 support
- Optional Google Tag Manager loading
- Enhanced developer ID signals

---

= 📈 Matomo Integration (Privacy Friendly) =

Use Matomo instead of Google Analytics.

Features:
- Self-hosted friendly
- Strict no-tracking mode
- Optional anonymous cookieless tracking
- Automatic consent switching
- Dynamic script loading after consent
- Matomo Analytics presets
- Matomo Tag Manager presets

Ideal for websites that must keep visitor data fully under their own infrastructure.

---

= 🛡 Script Blocking =

Prevent third-party scripts from loading before consent.

Supports:
- Plain text matching
- Regex matching
- Automatic script type conversion
- Category-based unlocking
- Google & Matomo presets

---

= 📝 Consent Logging =

Store proof of consent in WordPress with unique Consent ID, timestamp, IP, user agent, URL, and consent choices. Includes admin log viewer, pagination, CSV export, and GDPR audit support.

---

= 📋 Cookie Declarations =

Display transparent cookie information using `[ccwps_cookie_list]`. Each cookie entry includes name, domain, duration, path, description, and category.

---

= ⚡ Ready-Made Presets =

Quickly configure popular services:

- Google Analytics
- Google Ads
- Facebook Pixel
- Matomo Analytics
- Matomo Tag Manager

Presets can automatically add:
- Cookies
- Script blocking rules

---

= 🌍 Translation & Localization =

Includes built-in presets for:

- 🇬🇧 English
- 🇸🇰 Slovak
- 🇨🇿 Czech
- 🇩🇪 German
- 🇫🇷 French
- 🇪🇸 Spanish
- 🇵🇱 Polish
- 🇭🇺 Hungarian
- 🇮🇹 Italian

All texts are fully editable and frontend language switching is included.

---

= 🎨 Full Visual Customization =

Customize nearly everything:

- Primary color
- Background color
- Text colors
- Border radius
- Font family
- Banner layouts
- Banner positions
- Floating icon type
- Floating icon position
- Custom logo support

No coding required.

---

= 🔄 Import / Export Settings =

Move configuration between websites instantly.

Export includes:
- Appearance
- Cookies
- Blocking rules
- Translations
- Branding
- Settings

---

= 🤖 Bot Detection =

Automatically hides the banner from:
- Search engine crawlers
- Bots
- Automated indexing systems

Helps avoid incorrect indexing and consent artifacts.

---

= ♻ Re-consent Support =

Automatically requests new consent when:
- Cookie declarations change
- Categories change
- Consent version changes

Helps maintain GDPR compliance over time.

---

= 🧩 Shortcodes =

`[ccwps_consent_id]`
Displays the visitor consent ID.

`[ccwps_cookie_list]`
Displays an automatic cookie table grouped by category.

Perfect for Privacy Policy and Cookie Policy pages.

---

= 🖥 Powerful Admin Panel =

Modern WordPress admin experience with:

- Sidebar navigation
- Always-visible preview buttons
- Expandable help sections
- Consent log viewer
- CSV export
- Step-by-step setup documentation
- GTM integration guide
- Preset popups for faster setup

---

= 🔒 GDPR & ePrivacy Compliance =

This plugin is designed to help websites comply with:

- GDPR
- ePrivacy Directive
- EU cookie laws

⚠ Compliance depends on your implementation and local jurisdiction. Always consult a legal professional when necessary.

== External services ==

= Google Tag Manager (optional) =

The plugin loads Google Tag Manager only if a GTM Container ID is provided.

When enabled, requests may be sent to Google domains such as:
- `www.googletagmanager.com`

Data may include:
- IP address
- User agent
- Referrer
- Request metadata

Service provider: Google Ireland Limited / Google LLC  
Terms of Service: https://policies.google.com/terms  
Privacy Policy: https://policies.google.com/privacy

---

= Matomo tracking script (optional) =

The plugin loads Matomo only when configured in plugin settings.

Tracking requests are sent to your configured Matomo server according to your setup and consent state.

Service provider:
- Self-hosted Matomo
- Matomo Cloud

Terms & privacy depend on your provider.

Matomo references:
- https://matomo.org/terms/
- https://matomo.org/privacy-policy/

== Installation ==

1. Upload the plugin to `/wp-content/plugins/` or install via the WordPress Plugins screen.
2. Activate the plugin.
3. Open **Cookie Consent** in the WordPress admin.
4. Configure:
   - Consent Mode
   - Cookies
   - Script blocking
   - Appearance
   - Translations
5. Add:
   - `[ccwps_cookie_list]`
   - `[ccwps_consent_id]`
   to your Cookie Policy page.
6. Test using an incognito window.

== Frequently Asked Questions ==

= Does this support Google Consent Mode v2? =

Yes. The plugin supports both Consent Mode v2 and v3.

---

= Can I block third-party scripts? =

Yes. Scripts can be blocked until consent is granted using URL or regex matching.

---

= Where is consent data stored? =

Inside your WordPress database in:
`wp_ccwps_consent_log`

---

= Can I translate the banner? =

Yes. All frontend texts are editable and 9 language presets are included.

---

= Is Google required? =

No. The plugin works perfectly with self-hosted Matomo and without any Google services.

---

= Is the consent cookie httpOnly? =

No. The cookie is intentionally readable by frontend scripts so user preferences can be restored without server requests.

== Screenshots ==

1. Modern cookie banner
2. Preferences modal
3. Floating consent icon popup
4. Admin – Settings
5. Admin – Appearance
6. Admin – Cookie declarations
7. Admin – Script blocking
8. Admin – Consent log


== Changelog ==

= 1.0.7 =
* Switched to local Poppins font (Regular, Medium, SemiBold) – removed all Google Fonts dependencies. No external font requests are made by the plugin.
* Added upgrade migration: existing installations with empty or inherited font setting are automatically updated to the Poppins stack.
* Changed font detection in Appearance tab to manual-only: fonts are detected only when the admin clicks "Detect used fonts", preventing automatic remote requests on page load.
* Added "Detect used fonts" button with nonce protection and per-click cache.
* Added translations for new font-detection UI across all 9 supported admin languages.
* Updated text domain slug to match WordPress.org plugin directory slug (web-pixel-studio-cookie-consent-eu).
* Added "External services" section to readme disclosing optional GTM and Matomo remote resource loading as required by WordPress.org guidelines.
* Renamed GTM template files and POT file to match the corrected plugin slug.

== Upgrade Notice ==

= 1.0.7 =
Removes Google Fonts dependency, improves compliance, updates text domain naming consistency, and adds required external services disclosure for WordPress.org.