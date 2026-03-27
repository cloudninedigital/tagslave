 >Sep 2024 Update: according to Google's best-practices: consent/default signal resembles cookie-policy consent/update on every page load resembling persisted user-consent.
{.is-warning} 

> Google's recommended approach:
> 1. Scenario 1: The end-user has not been exposed to a consent popup on the previous page: 
> - Step 1. Set up a default consent state with the default options. 
> - Step 2. Update the end-user's consent status after they have confirmed their consent choices. 
> -- If the page triggers a reload after the user submits their choice, the update command must be executed **before the reload** to ensure the correct status carries over.
> -- If there is no reload, execute the update command **immediately after the user interaction** with the consent choice.
> 2. Scenario 2: The end-user has been exposed to a consent popup previously: Continue to use region-specific default tag settings on every page of the site. Additionally, use the update command on all subsequent pages, using the persisted values from the consent banner. This might require using a wait_for_update setting if the consent banner updates asynchronously. The consent update command should occur before any hits are sent.


> ![external_google_analytics_attribution_top_of_mind.png](/external_google_analytics_attribution_top_of_mind.png)

# Google Consent Mode
## How to check if Consent Mode (CoMo) is enabled?
1. Download Google Tag Assistant from Chrome Web Store
Visit https://chromewebstore.google.com/?utm_source=ext_app_menu and look for 'tag assistant companion'. 
Install the extension
2. Enable extension (temporarily) for 'Incognito' windows. 
To start a clean sheet investigation it is useful to do this in Chrome's Incognito window.
3. Open a new incognito window
Go to the menu bar and click on New Incognito Window (Ctrl+Shift+N)
4. Click on the Google Tag Assistant extension
When opening the Google Tag Assistant it will open the https://tagassistant.google.com/ page. Here you can add domains to check if CoMo is enabled. 
5. Add domain
Click on Add Domain to 'debug' a website. For instance 'https://www.newyorkpizza.nl/'. Start debugging. This will open the website.
---

The Tag Assistant checks for available Google Tags on the page. The GTM-container can only be debugged when you copy the Preview link of the GTM-container.

<p>

## Pre-consent Check - when cookiebanner is presented to user
1. When the site opens this is basically the pre-consent check because Incognito starts with a clean sheet where no cookies were stored before.

  > A `Consent Default` event should always be present. No `Consent Update` event is expected yet.
{.is-info}

The `default` consent signal should resemble the cookie policy of the client. This means that if the client wants GA4 always on (and thus storing analyitcs cookies), the default setting for `analytics_storge` parameter equals `granted`. However, most clients don't accept cookies before consent is given and so most clients will have a `default` setting of `denied` for analtics and ads as well. 

In the example below no *Consent Default* event was found:
  
![nyp-step1-noconsent.png](/nyp-step1-noconsent.png)

Since no Consent is configured but events were sent to GA4 this means these events won't have the 'gcs'-parameter. You can double check this by clicking on the events itself. 

![nyp-step1-noconsent_hitsent.png](/nyp-step1-noconsent_hitsent.png)
<p/>

### Example Consent Default analytics 'granted'

Here it can be seen that for Voetbaldirect.nl the `default` behaviour is `granted` for `analytics_storage`.

![vd-default_consent.png](/vd-default_consent.png)

<p>

## Consenting - when user interacts with cookiebanner
1. After the pre-consent check you can interact with the Cookie Banner and 'Accept all'.
2. After accepting the cookies on the website return to that Tag Assistant window. You will probably see a lot more events on the left-hand side, which can also be seen below.
3. Watch for the *Consent Update* event on the left-hand side to see if an 'Update' event was dispatched. In this example number 15 is the moment where Cookiebot sent the *Consent Update* event.
4. Click on the *Consent Update* event and Consent tab to see what the values are for the different CoMo-parameters.
  
> A `Consent Update` event is expected after user 'submitted' their consent preferences. 
{.is-info}

![vd-consent-update.png](/vd-consent-update.png)

> Check for existence of the `gcs`-parameter and `gcd`-parameter if it was part of the hit and has the correct values. It could be that hits are sent before the *Consent Update* event and still have the correct values. The latter is what counts.
{.is-warning}

---

### Handling consent changes during the session
If the user changes their consent choices during the same session, this needs to be reflected correctly:

- **If the Consent tool forces a page reload after the change:**  
  - The `Consent Update` must be executed **before the reload** so that the new consent state persists into the next page load.  
  - On reload, verify that the `gcs` and `gcd` parameters are updated in the hits with the correct values.  

- **If the Consent tool does *not* force a page reload:**  
  - Dispatch a new `Consent Update` event immediately after the user changes their choice.  
  - Ensure any subsequent GTM events (e.g., GA4, Google Ads hits) are sent **only after** this updated consent state is in place.  
  - Validate that the new `gcs` and `gcd` parameters are reflected in the hits after the update.  
  
</p>
<p>

## Consented (post-consent) check - when navigating to the next page (page load - no SPA update)
1. When the Consent check is done reload the page or navigate to another page to see what happens after user has consented. So basically run the same checks as above.

 > - A `Consent Default` event should always be present. After every `Consent Default` event (post consent interaction), there should also be a `Consent Update` event containing the persisted consented levels of the user.  
  > - For standard web pages, this **always** applies (meaning; on every Page Load again).
  > - For Single Page Applications (SPAs), a `Consent Update` is required after both a **hard reload** *and* after each 'virtual' load of the page. This to ensure that the consent state is maintained as users interact with the application.
  {.is-info}
  
 
![eft_postconsent.png](/eft_postconsent.png)
  
## Timing within Consent Mode  
Again, the order of operations is important and always check for the `gcs` parameters in the hits that were sent.  

The **timing of events** is critical for two reasons:  
1. **Consent Mode Events (Default vs. Update):**  
   - The `Consent Default` must be set first, to define the baseline behavior of tags before consent is known.  
   - The `Consent Update` must follow when the user’s choice is available. If this happens too late, tags may already have fired under the wrong consent state, leading to missing or incorrect `gcs` parameter values in the hits.  

2. **Tag Manager Events (e.g. GTM triggers for GA4 or Google Ads):**  
   - Tags in GTM rely on the current consent state to determine if they are allowed to fire.  
   - If the consent state (`Default` or `Update`) is not applied **before** GTM attempts to send data, the outgoing request may either:  
     - be blocked entirely,  
     - be delayed, or  
     - go out with the wrong `gcs` parameters.  
   - This can result in data loss (no hit sent at all) or compliance issues (a hit sent without the correct consent signals).  

3. **Traffic Attribution Risks:**  
   - Even if a hit is sent, if the consent state is not applied correctly, the hit may be missing attribution information such as the **source/medium**.  
   - This leads to misattribution in GA4 or other analytics tools, making traffic and conversion analysis unreliable.  

> In short  
>- **Default first, Update immediately after consent interaction.**  
>- Make sure the `gcs` parameters are present and correct before dependent GTM tags execute and send data to GA4, Google Ads, or other systems.  
>- Validate that attribution data (source/medium) is also carried through correctly, otherwise campaign and traffic reporting will be inaccurate.
  {.is-info}

## QA for Google Consent Mode Setup Before Go-Live

To ensure the Consent Mode is correctly implemented, follow these steps:

1. **Pre-consent Check:**
   - Verify that the `Consent Default` event is triggered on the first page load or when the cookie banner appears.
   - Ensure the default consent state (e.g., `analytics_storage`, `ads_storage`) is set as expected (usually `denied` before user interaction).

2. **Consent Update:**
   - Interact with the consent banner (e.g., accept all cookies) and confirm that the `Consent Update` event is triggered.
   - Check that the `gcs` and `gcd` parameters in the event reflect the user's consent choice (e.g., `granted` or `denied` for analytics and ads).

3. **Post-consent Validation:**
   - Navigate through the site or simulate page loads to ensure the `Consent Update` event is triggered on each page load or virtual load in SPAs.
   - Double-check that no analytics or ads events are fired before the `Consent Update` event.

4. **GTM and Tag Testing:**
   - Use Google Tag Assistant to validate that GTM is firing tags according to the updated consent state.
   - Confirm that no tags are sent before the consent update is applied.

5. **Attribution and Hits:**
   - Ensure that traffic and attribution data (e.g., `source/medium`) is correctly passed with the `gcs` and `gcd` parameters in every hit.

6. **4-Eyes Principle Check:**
   - The QA process should be done by a **different consultant** than the one who implemented the setup, to ensure an independent review.
   - Preferably, this consultant should be someone within the same client team who has knowledge of the client's setup to ensure familiarity with specific configurations and expectations.

By following these steps and ensuring the 4-eyes principle, you can ensure that the Consent Mode setup is functioning correctly and in compliance with user consent preferences.

</p>
