___INFO___
{
  "type": "TAG",
  "id": "cvt_temp_public_id_0987654321",
  "version": 1,
  "securityGroups": [],
  "displayName": "Web Pixel Studio Cookie Consent for EU",
  "categories": ["PERSONALIZATION", "UTILITY"],
  "brand": {
    "id": "web_pixel_studio",
    "displayName": "Web Pixel Studio",
    "thumbnail": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0iIzAwNzJFNiIgZD0iTTEyIDJDNi40OCAyIDIgNi40OCAyIDEyczQuNDggMjAgMTAgMjAgMjAtNC40OCAyMC0xMFM4LjQ4IDIgMTIgMnoiLz48L3N2Zz4="
  },
  "description": "Web Pixel Studio Cookie Consent for EU is a comprehensive Consent Mode 2.0 template designed to manage user consent in compliance with GDPR, EDPB guidelines, and other EU regulations. This template enables seamless integration with Google Tag Manager to collect, store, and manage user consent preferences for analytics, advertising, and personalization.",
  "containerContexts": ["WEB"],
  "docUrl": "https://webpixelstudio.com/cookie-consent-documentation",
  "termsUrl": "https://webpixelstudio.com/terms",
  "homepageUrl": "https://webpixelstudio.com",
  "privacyUrl": "https://webpixelstudio.com/privacy",
  "serviceUrl": "https://webpixelstudio.com/support",
  "author": "Web Pixel Studio",
  "authorsEmail": ["support@webpixelstudio.com"],
  "__wpc": false
}

___FIELDS___
[
  {
    "type": "GROUP",
    "name": "defaultConsentSettings",
    "displayName": "Default Consent Settings",
    "groupStyle": "ZIPPY_OPEN",
    "fields": [
      {
        "type": "PARAM_TABLE",
        "name": "defaultSettings",
        "displayName": "Default Consent States by Region",
        "help": "Define default consent states for different regions. Leave region blank to apply settings globally.",
        "paramTableColumns": [
          {
            "columnType": "TEXT",
            "name": "region",
            "displayName": "Region (ISO 3166-2, e.g., ES, DE, FR, or leave blank for all)",
            "isUnique": true
          },
          {
            "columnType": "TEXT",
            "name": "grantedTypes",
            "displayName": "Granted Consent Types (comma-separated: ad_storage, analytics_storage, etc.)"
          },
          {
            "columnType": "TEXT",
            "name": "deniedTypes",
            "displayName": "Denied Consent Types (comma-separated)"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableWaitForUpdate",
        "displayName": "Enable wait_for_update",
        "help": "Wait for user consent choices before firing tags (500ms default)",
        "defaultValue": true
      },
      {
        "type": "TEXT",
        "name": "waitForUpdateMs",
        "displayName": "Wait for Update Timeout (milliseconds)",
        "help": "How long to wait for user consent choices (default: 500ms)",
        "defaultValue": "500"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "consentTypes",
    "displayName": "Consent Types Configuration",
    "groupStyle": "ZIPPY_CLOSED",
    "fields": [
      {
        "type": "CHECKBOX",
        "name": "ad_storage",
        "displayName": "ad_storage (Advertising cookies)"
      },
      {
        "type": "CHECKBOX",
        "name": "ad_user_data",
        "displayName": "ad_user_data (User data for ads)"
      },
      {
        "type": "CHECKBOX",
        "name": "ad_personalization",
        "displayName": "ad_personalization (Personalized ads)"
      },
      {
        "type": "CHECKBOX",
        "name": "analytics_storage",
        "displayName": "analytics_storage (Analytics cookies)"
      },
      {
        "type": "CHECKBOX",
        "name": "functionality_storage",
        "displayName": "functionality_storage (Functionality cookies)"
      },
      {
        "type": "CHECKBOX",
        "name": "personalization_storage",
        "displayName": "personalization_storage (Personalization cookies)"
      },
      {
        "type": "CHECKBOX",
        "name": "security_storage",
        "displayName": "security_storage (Security cookies)"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "cookieConfiguration",
    "displayName": "Cookie Configuration",
    "groupStyle": "ZIPPY_CLOSED",
    "fields": [
      {
        "type": "TEXT",
        "name": "cookieName",
        "displayName": "Cookie Name (to read consent)",
        "help": "Name of the cookie that stores user consent preferences",
        "defaultValue": "wp_consent"
      },
      {
        "type": "TEXT",
        "name": "cookieDomain",
        "displayName": "Cookie Domain",
        "help": "Domain where consent is stored (optional)",
        "defaultValue": ""
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "optionalSettings",
    "displayName": "Optional Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "fields": [
      {
        "type": "CHECKBOX",
        "name": "adsDataRedaction",
        "displayName": "Redact Ads Data",
        "help": "Redact ad click information when ad_storage is denied",
        "defaultValue": false
      },
      {
        "type": "CHECKBOX",
        "name": "urlPassthrough",
        "displayName": "Pass through URL parameters",
        "help": "Enable URL passthrough for gclid/dclid parameters",
        "defaultValue": false
      },
      {
        "type": "TEXT",
        "name": "developerId",
        "displayName": "Developer ID (optional)",
        "help": "If you are a CMP vendor with a Google-issued developer ID, enter it here",
        "defaultValue": ""
      },
      {
        "type": "TEXT",
        "name": "consentChangeCallbackName",
        "displayName": "Consent Change Callback Function Name",
        "help": "Name of window function to call when consent is loaded",
        "defaultValue": "handleConsentUpdate"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "advancedOptions",
    "displayName": "Advanced Options",
    "groupStyle": "ZIPPY_CLOSED",
    "fields": [
      {
        "type": "CHECKBOX",
        "name": "debugMode",
        "displayName": "Debug Mode",
        "help": "Enable console logging for debugging",
        "defaultValue": false
      },
      {
        "type": "CHECKBOX",
        "name": "acceptTermsOfService",
        "displayName": "I agree to the Google Tag Manager Community Template Gallery Terms of Service",
        "required": true
      }
    ]
  }
]

___TEMPLATE_CODE___
const log = require('logToConsole');
const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const getCookieValues = require('getCookieValues');
const callInWindow = require('callInWindow');
const gtagSet = require('gtagSet');
const JSON = require('JSON');

// Parse comma-separated input string to array
const splitInput = (input) => {
  if (!input) return [];
  return input.split(',')
      .map(entry => entry.trim())
      .filter(entry => entry.length !== 0);
};

// Parse default settings row data
const parseCommandData = (settings) => {
  const regions = settings['region'] ? splitInput(settings['region']) : [];
  const granted = splitInput(settings['grantedTypes']);
  const denied = splitInput(settings['deniedTypes']);
  
  const commandData = {};
  
  if (regions.length > 0) {
    commandData.region = regions;
  }
  
  granted.forEach(entry => {
    commandData[entry] = 'granted';
  });
  
  denied.forEach(entry => {
    commandData[entry] = 'denied';
  });
  
  return commandData;
};

// Handle consent updates
const onUserConsent = (consent) => {
  if (data.debugMode) {
    log('Consent updated:', consent);
  }
  
  const consentModeStates = {
    ad_storage: consent['ad_storage'] || 'denied',
    ad_user_data: consent['ad_user_data'] || 'denied',
    ad_personalization: consent['ad_personalization'] || 'denied',
    analytics_storage: consent['analytics_storage'] || 'denied',
    functionality_storage: consent['functionality_storage'] || 'granted',
    personalization_storage: consent['personalization_storage'] || 'denied',
    security_storage: consent['security_storage'] || 'granted'
  };
  
  updateConsentState(consentModeStates);
};

// Main execution
const main = (data) => {
  if (data.debugMode) {
    log('Web Pixel Studio Cookie Consent for EU - Initializing');
    log('data =', data);
  }
  
  // Set optional gtag settings
  if (data.adsDataRedaction) {
    gtagSet('ads_data_redaction', true);
  }
  
  if (data.urlPassthrough) {
    gtagSet('url_passthrough', true);
  }
  
  if (data.developerId && data.developerId.length > 0) {
    gtagSet('developer_id.' + data.developerId, true);
  }
  
  // Set default consent states
  if (data.defaultSettings && data.defaultSettings.length > 0) {
    data.defaultSettings.forEach(settings => {
      const defaultData = parseCommandData(settings);
      defaultData.wait_for_update = parseInt(data.waitForUpdateMs) || 500;
      setDefaultConsentState(defaultData);
    });
  } else {
    // Fallback default settings if none configured
    setDefaultConsentState({
      'wait_for_update': parseInt(data.waitForUpdateMs) || 500,
      'ad_storage': 'denied',
      'ad_user_data': 'denied',
      'ad_personalization': 'denied',
      'analytics_storage': 'denied',
      'functionality_storage': 'granted',
      'personalization_storage': 'denied',
      'security_storage': 'granted'
    });
  }
  
  // Try to read consent from cookie
  const cookieName = data.cookieName || 'wp_consent';
  const cookieValues = getCookieValues(cookieName);
  
  if (cookieValues && cookieValues.length > 0) {
    try {
      const consentData = JSON.parse(cookieValues[0]);
      if (consentData) {
        onUserConsent(consentData);
        if (data.debugMode) {
          log('Consent loaded from cookie:', consentData);
        }
      }
    } catch (e) {
      if (data.debugMode) {
        log('Error parsing consent cookie:', e);
      }
    }
  }
  
  // Set up callback for consent changes
  if (data.consentChangeCallbackName && data.consentChangeCallbackName.length > 0) {
    try {
      callInWindow(data.consentChangeCallbackName, onUserConsent);
      if (data.debugMode) {
        log('Consent callback registered:', data.consentChangeCallbackName);
      }
    } catch (e) {
      if (data.debugMode) {
        log('Error registering consent callback:', e);
      }
    }
  }
  
  // Signal successful execution
  data.gtmOnSuccess();
};

main(data);

___TESTS___
[]

___NOTES___
Web Pixel Studio Cookie Consent for EU v2.0

CHANGELOG:
- 2.0: Initial release of Community Template Gallery version
  * Full support for Google Consent Mode 2.0
  * EU GDPR and EDPB compliance
  * Multi-region support with ISO 3166-2 codes
  * Support for all 7 consent types
  * Optional ads data redaction
  * Optional URL passthrough
  * Developer ID support
  * Cookie-based consent reading
  * Callback support for real-time consent updates
  * Comprehensive debug mode

REQUIREMENTS:
- Google Tag Manager (GTM)
- Website with consent cookie or consent management system
- Trigger: "Consent Initialization - All Pages" recommended

INSTALLATION:
1. Import this template into your GTM container
2. Create a new tag using this template
3. Configure default consent settings per region
4. Set the cookie name where your CMP stores consent
5. Set the callback function name to handle consent changes
6. Trigger the tag on "Consent Initialization - All Pages"

SUPPORT:
For documentation and support, visit: https://webpixelstudio.com/cookie-consent-documentation
