ios-yelp
========

Yelp app for iOS class (Assignment #2)

**Completed User Stories**

- Search results page
   - Custom cells should have the proper Auto Layout constraints
   - Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   - The filters table should be organized into sections as in the mock.
   - Radius filter should expand as in the real Yelp app
   - Categories should show a subset of the full list with a "See All" row to expand.
   - Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.

**Incomplete User Stories**

- Search results page
   - Optional: Table rows should be dynamic height according to the content height
   - Optional: infinite scroll for restaurant results
   - Optional: Implement map view of restaurant results
- Filter page.
   - Optional: implement a custom switch for on/off states
   - Optional: Implement the restaurant detail page.

**UI Demo**

![demo gif](https://raw.githubusercontent.com/osabina/ios-yelp/master/rt_demo.gif))

**Notes**

This took me ~15 hours, although I found myself making a lot of little things work that are not directly user stories (The search bar alone had lots of interesting side issues: removing "clear" button except on edit, making the "cancel" button appear and work properly, ending editing on view tap).  Very useful assignment.

"Cancel" button just returns to search page, but filter choices remain (although they are not searched on).  In an ideal world changes made during that View would be tossed on cancel.  Ran out of time trying to figure that out.

**Credits**

Uses the following CocoaPods:

- AFNetworking
- BDBOAuth1Manager
- MBProgressHUD

Additionally, demo gif captured with [LiceCap](http://www.cockos.com/licecap/)
