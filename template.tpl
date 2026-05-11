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
    "thumbnail": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA2NCA2NCI+CiAgPGRlZnM+CiAgICA8bGluZWFyR3JhZGllbnQgaWQ9ImciIHgxPSIwIiB5MT0iMCIgeDI9IjEiIHkyPSIxIj4KICAgICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzAwNTdEOSIvPgogICAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMEEzRkYiLz4KICAgIDwvbGluZWFyR3JhZGllbnQ+CiAgPC9kZWZzPgogIDxyZWN0IHg9IjQiIHk9IjQiIHdpZHRoPSI1NiIgaGVpZ2h0PSI1NiIgcng9IjE0IiBmaWxsPSJ1cmwoI2cpIi8+CiAgPGNpcmNsZSBjeD0iMzIiIGN5PSIyNCIgcj0iOSIgZmlsbD0iI2ZmZmZmZiIvPgogIDxwYXRoIGQ9Ik0yMiA0MmMwLTUuNSA0LjUtMTAgMTAtMTBzMTAgNC41IDEwIDEwIiBmaWxsPSJub25lIiBzdHJva2U9IiNmZmZmZmYiIHN0cm9rZS13aWR0aD0iNSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIi8+CiAgPGNpcmNsZSBjeD0iNDQiIGN5PSI0NCIgcj0iNiIgZmlsbD0iIzBCMkE1QyIvPgogIDxwYXRoIGQ9Ik00NCA0MXY2TTQxIDQ0aDYiIHN0cm9rZT0iI2ZmZmZmZiIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPC9zdmc+"
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

___TEMPLATE_PARAMETERS___
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

___SANDBOXED_JS_FOR_WEB_TEMPLATE___
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

___WEB_PERMISSIONS___
[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "handleConsentUpdate"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "write_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "ads_data_redaction"
              },
              {
                "type": 1,
                "string": "url_passthrough"
              },
              {
                "type": 1,
                "string": "developer_id.*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "wp_consent"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "functionality_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "security_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]

___TESTS___
scenarios: []

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
