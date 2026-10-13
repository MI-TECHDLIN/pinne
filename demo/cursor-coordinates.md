# Cursor coordinates

Every step the cursor takes in the film, measured from the widget tree
at the moment it happened (`demo/film/tour.dart`). Film time is when it
happens in pinne-demo.mp4; scene time is from the scene's own start.
App rect is the target's x, y, width, height in the app's logical
pixels (a 412 x 892 screen). Zoom is the camera's magnification over
the full-height screen (never past 2.0). Cursor is the click or
landing point on the 1920 x 1080 canvas; the render fails if it is not
inside the target or the callout covers it.

## 01_hook

| Film (s) | Scene (s) | Action | Target | App rect (x, y, w, h) | Zoom | Cursor (x, y) | Callout |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 18.43 | 18.43 | click | key 'tour-next' | 273.2, 534, 105.8, 48 | 1.4x | 1090, 540 | A short first-run tour shows you around |

## 02_capture

| Film (s) | Scene (s) | Action | Target | App rect (x, y, w, h) | Zoom | Cursor (x, y) | Callout |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 20.50 | 1.23 | click | key 'source-share' | 366, 51, 22, 22 | 1.8x | 1216, 135.1 | Share from any app |
| 22.54 | 3.27 | click | key 'chooser-pinne' | 20, 770, 78, 82 | 1.7x | 760.3, 913.3 | Pick Pinne in the share sheet |
| 24.30 | 5.03 | point | key 'share-saved-heading' | 16, 620, 318.2, 28 | 1.15x | 964.4, 720.7 | Saved instantly, with a little celebration |
| 26.50 | 7.23 | point | text containing Kept on this phone | 16, 652, 380, 16 | 1.5x | 1169.6, 658.7 | Offline? It stays on this phone and syncs later |
| 28.54 | 9.27 | click | key 'share-why' | 29, 759, 354, 24 | 1.5x | 918.5, 860.2 | Say why you saved it |
| 32.10 | 12.83 | click | key 'share-done' | 16, 810, 380, 48 | 1.4x | 891.9, 981.7 | Done takes you back to your reading |
| 34.14 | 14.87 | click | key 'capture-entry' | 16, 585, 380, 65 | 1.4x | 1002.1, 614.7 | Or save a link right inside Pinne |
| 36.17 | 16.90 | click | widget matching predicate | 323, 669, 48, 48 | 1.5x | 1196.4, 718.6 | Paste the same link again |
| 38.20 | 18.93 | click | key 'paste-save' | 292.4, 729, 78.6, 48 | 1.5x | 1168.7, 827.6 | Saved before? Pinne says so |

## 03_organize

| Film (s) | Scene (s) | Action | Target | App rect (x, y, w, h) | Zoom | Cursor (x, y) | Callout |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 40.87 | 1.33 | point | text "On phone · syncing" | 264.2, 673, 114.8, 17 | 1.6x | 1128.8, 672.2 | Back online, it syncs exactly once |
| 43.94 | 4.40 | drag by -432 px | text "Synced" | 333.2, 673, 45.8, 17 | 1x | 1141.7, 825.1 | - |
| 45.17 | 5.63 | click | key 'accept-00000000-0000-4000-8000-0000000000f1' | 193.2, 540, 40, 40 | 1.5x | 1172.3, 540 | AI suggests a collection. You decide. |
| 47.21 | 7.67 | click | key 'accept-00000000-0000-4000-8000-0000000000f2' | 158, 590, 40, 40 | 1.6x | 1201.3, 540 | Keep the tags that fit |
| 49.24 | 9.70 | click | key 'accept-00000000-0000-4000-8000-0000000000f4' | 298, 710, 40, 40 | 1.6x | 1201.3, 766.2 | Add the short summary in one tap |
| 51.27 | 11.73 | click | key 'dismiss-00000000-0000-4000-8000-0000000000f3' | 232.4, 766, 40, 40 | 1.6x | 1199.2, 874.7 | “Maybe” marks a guess. Dismiss it. |

## 04_search

| Film (s) | Scene (s) | Action | Target | App rect (x, y, w, h) | Zoom | Cursor (x, y) | Callout |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 55.64 | 1.33 | point | text "Recent searches" | 33, 255, 268.3, 24 | 1.5x | 932.4, 484.9 | Recent searches stay on this phone |
| 57.68 | 3.37 | click | key 'search-field' | 16, 158, 380, 56 | 1.5x | 1025.1, 337.8 | Search the way you remember it |
| 60.58 | 6.27 | point | text containing Matched saved note | 32, 626, 348, 34 | 1.6x | 902.9, 597.6 | Every result says why it matched |

## 05_today

| Film (s) | Scene (s) | Action | Target | App rect (x, y, w, h) | Zoom | Cursor (x, y) | Callout |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 63.69 | 1.33 | point | text "Ideas for our app’s first-run screens" | 32, 434.5, 242.4, 19 | 1.5x | 955.4, 536.4 | Back a day later, with your note on why |
| 66.43 | 4.07 | click | key 'budget-20' | 198.5, 214, 79.8, 40 | 1.6x | 1099.1, 453.3 | Got 20 minutes? The queue grows to fit |
| 68.46 | 6.10 | click | key 'review-remind' | 165.5, 485.4, 156.6, 40 | 1.5x | 1014.6, 537.2 | Remind me later brings it back tomorrow |

## 06_planner

| Film (s) | Scene (s) | Action | Target | App rect (x, y, w, h) | Zoom | Cursor (x, y) | Callout |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 73.06 | 1.33 | click | is "ButtonStyleButton" that are ancestors of widget with text "Plan my week" | 16, 679, 380, 48 | 1.5x | 894.9, 736.7 | Plan my week finds free slots |
| 75.10 | 3.37 | point | text containing Checked your busy times | 36, 580, 360, 19 | 1.6x | 891.3, 540 | It tells you exactly what it checked |

## 07_progress

| Film (s) | Scene (s) | Action | Target | App rect (x, y, w, h) | Zoom | Cursor (x, y) | Callout |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 79.97 | 1.33 | point | key 'progress-stack-top' | 25.9, 262.2, 360.1, 225.5 | 1.2x | 850.8, 540 | Opening isn’t reviewing: only reviews count |
| 82.51 | 3.87 | click | key 'nav-today' | 62, 835.5, 57.6, 21 | 1.5x | 732.3, 996.5 | Back to Today’s save |
| 84.54 | 5.90 | click | key 'review-reviewed' | 32, 459.4, 125.5, 40 | 1.5x | 794, 537.3 | Mark it reviewed |
| 86.47 | 7.83 | click | key 'celebration-continue' | 49, 612, 314, 48 | 1.2x | 967.1, 708.1 | Milestones get a celebration, just once |
| 88.81 | 10.17 | click | key 'today-profile' | 16, 50, 48, 48 | 1.6x | 726.5, 143.4 | Tap your spirit for your profile |
| 91.87 | 13.23 | drag by -287 px | text "Your progress" | 33, 373, 94.5, 24 | 1x | 807.7, 466.1 | - |
| 92.91 | 14.27 | point | key 'profile-sign-in' | 33, 723, 91.2, 48 | 1.5x | 823.2, 816.7 | A guest now. Sign in whenever you like. |

