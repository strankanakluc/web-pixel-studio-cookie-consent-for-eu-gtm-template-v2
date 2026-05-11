# Web Pixel Studio Cookie Consent for EU

A comprehensive **Google Tag Manager (GTM) Consent Mode 2.0 template** for managing user consent in compliance with GDPR, EDPB guidelines, and other EU regulations.

## Features

✅ **Google Consent Mode 2.0** - Full support for the latest consent framework
✅ **EU GDPR Compliant** - Designed with GDPR and EDPB requirements in mind
✅ **Multi-Region Support** - Configure consent defaults per region using ISO 3166-2 codes
✅ **7 Consent Types** - Support for all Google consent types:
   - `ad_storage` - Advertising cookies
   - `ad_user_data` - User data for online advertising
   - `ad_personalization` - Personalized advertising
   - `analytics_storage` - Analytics and performance cookies
   - `functionality_storage` - Website functionality cookies
   - `personalization_storage` - Personalization cookies
   - `security_storage` - Security and authentication cookies

✅ **Optional Features**:
   - Ads data redaction when `ad_storage` is denied
   - URL passthrough for gclid/dclid parameters
   - Developer ID support for CMP vendors
   - Cookie-based consent reading
   - Real-time consent change callbacks
   - Debug mode for troubleshooting

## Installation

### Step 1: Add the Template to Google Tag Manager

1. Open your **Google Tag Manager** container
2. Go to **Templates** → **Tag Templates**
3. Click **New** and select **Create From Gallery**
4. Search for "Web Pixel Studio Cookie Consent for EU"
5. Click **Add to Workspace**
6. Click **Save**

### Step 2: Create a New Tag

1. Go to **Tags** and click **New**
2. Select **Web Pixel Studio Cookie Consent for EU** as the tag type
3. Configure the tag settings (see Configuration section below)

### Step 3: Set Up the Trigger

1. Click on **Trigger** and create/select a trigger:
   - **Recommended**: "Consent Initialization - All Pages"
   - This ensures consent is initialized before other tags fire

### Step 4: Test and Publish

1. Test the tag in **Preview Mode**
2. Publish your container to production

## Configuration

### Default Consent Settings

Define default consent states that apply before the user makes a choice:

| Setting | Description | Example |
|---------|-------------|---------|
| **Region** | ISO 3166-2 code (e.g., ES, DE, FR) or leave blank for global | ES, DE, or blank |
| **Granted Consent Types** | Comma-separated list of types to grant by default | ad_storage, analytics_storage |
| **Denied Consent Types** | Comma-separated list of types to deny by default | ad_user_data, ad_personalization |

**Example Regional Configuration**:
```
Region: ES (Spain)
Granted: analytics_storage, functionality_storage, security_storage
Denied: ad_storage, ad_user_data, ad_personalization, personalization_storage

Region: (blank - for all other regions)
Granted: analytics_storage, functionality_storage, security_storage
Denied: ad_user_data
```

### Cookie Configuration

- **Cookie Name**: The name of the cookie where your CMP stores consent preferences (default: `wp_consent`)
- The template will automatically read and parse this cookie on page load
- Cookie format should be JSON with consent type names as keys and 'granted'/'denied' as values

**Example Cookie Format**:
```json
{
  "ad_storage": "denied",
  "ad_user_data": "denied",
  "ad_personalization": "denied",
  "analytics_storage": "granted",
  "functionality_storage": "granted",
  "personalization_storage": "denied",
  "security_storage": "granted"
}
```

### Optional Settings

- **Redact Ads Data**: Enable to redact ad click identifiers when `ad_storage` is denied
- **Pass through URL parameters**: Enable to preserve gclid/dclid in URLs when `ad_storage` is denied
- **Developer ID**: Enter your Google-issued developer ID if you're a CMP vendor
- **Consent Change Callback Function**: Function name to call when consent changes (default: `handleConsentUpdate`)

### Advanced Options

- **Debug Mode**: Enable console logging for troubleshooting (check browser console with `console.log()`)
- **Accept Terms of Service**: Required checkbox for Community Template Gallery compliance

## How It Works

### Initialization Flow

1. **Set Default Consent** - On page load, the template calls `setDefaultConsentState()` with:
   - Region-specific defaults if configured
   - Global defaults for users outside configured regions
   - `wait_for_update` timeout (default: 500ms) to allow user consent collection

2. **Read Cookie** - The template attempts to read user consent from the configured cookie
   - If found and valid JSON, updates consent immediately via `updateConsentState()`
   - If not found or invalid, uses default settings

3. **Register Callback** - Sets up a callback function to handle real-time consent changes
   - When user interacts with your consent banner, the CMP calls this function
   - The template updates consent state accordingly

### Region-Specific Behavior

The template supports region-specific defaults using ISO 3166-2 codes:
- Most specific region takes precedence
- Example: If you set defaults for `ES` (Spain) and `ES-MD` (Madrid), users from Madrid get the `ES-MD` settings
- Leave region blank to set global defaults for all other regions

## Integration with Your Consent Management Platform (CMP)

### Step 1: Store Consent in Cookie

Your CMP should store consent as JSON in a cookie:

```javascript
// Example CMP implementation
window.setConsent = function(consentData) {
  const jsonString = JSON.stringify(consentData);
  document.cookie = `wp_consent=${jsonString};path=/;max-age=31536000`;
};
```

### Step 2: Call Consent Update Callback

When user consent changes, your CMP should call the callback function:

```javascript
// Your CMP's consent change handler
window.handleConsentUpdate = function(consentData) {
  // This function is called by the GTM template
  // consentData contains the updated consent object
  console.log('Consent updated:', consentData);
};
```

### Step 3: Example CMP Integration

```javascript
// Full example of CMP integration with GTM template
window.consentArray = [];

window.consentCallback = function(callback) {
  window.consentArray.push(callback);
};

window.updateConsent = function(consentData) {
  // Update cookie
  document.cookie = `wp_consent=${JSON.stringify(consentData)};path=/;max-age=31536000`;
  
  // Notify GTM template
  window.consentArray.forEach(callback => {
    callback(consentData);
  });
};
```

## Compliance & Best Practices

### GDPR & EDPB Compliance

- ✅ Explicit consent for non-essential cookies before any data collection
- ✅ Region-specific defaults to comply with local regulations
- ✅ Clear consent choices with granular control per cookie category
- ✅ Ability to withdraw or modify consent at any time

### Best Practices

1. **Fire Early**: Trigger the consent tag on "Consent Initialization - All Pages" before other tags
2. **Wait for User Choice**: Use `wait_for_update` (500ms) to allow time for user consent collection
3. **Test Thoroughly**: Use Debug Mode to verify consent is being set correctly
4. **Document Purposes**: Clearly document what each consent type means to users
5. **Monitor Changes**: Use the callback function to track consent changes
6. **Update Regularly**: Keep your template up to date with the latest GDPR guidance

## Troubleshooting

### Enable Debug Mode

1. Set **Debug Mode** to enabled in template configuration
2. Open browser Developer Tools (F12) and go to **Console** tab
3. The template will log detailed information about:
   - Template initialization
   - Default consent states being set
   - Cookie parsing
   - Callback registration
   - Consent updates

### Common Issues

**Issue**: Consent not being read from cookie
- Check that cookie name matches your CMP's cookie name
- Verify cookie format is valid JSON
- Check browser console for parsing errors (Debug Mode)

**Issue**: Callback function not being called
- Verify the callback function name is correct and exists on `window` object
- Check browser console for registration errors (Debug Mode)

**Issue**: Tags not respecting consent state
- Ensure tag has Consent Initialization trigger
- Verify Google tags are consent-aware (use latest versions)
- Check that GTM container has Consent Mode enabled

## Examples

### Spain (RGPD) Configuration

```
Region: ES
Granted: analytics_storage, functionality_storage, security_storage
Denied: ad_storage, ad_user_data, ad_personalization, personalization_storage
Wait for Update: 500ms
```

### France (CNIL) Configuration

```
Region: FR
Granted: functionality_storage, security_storage
Denied: ad_storage, ad_user_data, ad_personalization, analytics_storage, personalization_storage
Wait for Update: 500ms
```

### Global Fallback

```
Region: (blank)
Granted: functionality_storage, security_storage
Denied: ad_storage, ad_user_data, ad_personalization, analytics_storage, personalization_storage
```

## Support & Documentation

- **Homepage**: https://webpixelstudio.com
- **Documentation**: https://webpixelstudio.com/cookie-consent-documentation
- **Support Email**: support@webpixelstudio.com

## License

Apache License 2.0, check the LICENSE file.
- **Issue Tracker**: https://github.com/strankanakluc/web-pixel-studio-cookie-consent-for-eu-gtm-template-v2/issues

## License

This template is distributed under the **Apache License 2.0**.
See the [LICENSE](LICENSE) file for details.

## Version History

### v2.0 (2026-05-11)
- Initial release to Google Tag Manager Community Template Gallery
- Full Google Consent Mode 2.0 support
- EU GDPR and EDPB compliance
- Multi-region ISO 3166-2 code support
- All 7 consent types supported
- Optional ads data redaction
- Optional URL passthrough
- Developer ID support
- Cookie-based consent reading
- Real-time consent change callbacks
- Comprehensive debug mode

## Contributing

Found a bug or have a feature request? Please open an issue on our [GitHub repository](https://github.com/strankanakluc/web-pixel-studio-cookie-consent-for-eu-gtm-template-v2).

## Disclaimer

This template is provided as-is. While we strive for GDPR compliance, we recommend having it reviewed by your legal team before deploying to production. Cookie management and consent requirements vary by jurisdiction and use case.

---

**Web Pixel Studio** © 2026. All rights reserved.
