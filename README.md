CS 545 - HW2--Basic-Storage

Overview of the various storage options available on iOS, including their pros and cons:

1. User Defaults
Description: A simple way to store small amounts of data, typically user preferences, in a key-value format.

Pros:
- Easy to implement and access, ideal for storing user settings and preferences.
- Data is automatically synchronized across devices using iCloud if enabled.

Cons:
- Not suitable for storing large or complex data structures.
- Limited to small data (typically under a few kilobytes).

2. File System (Documents Directory)
Description: It allows storing of files directly in the app’s sandboxed file system.

Pros:
- Suitable for storing large files, such as documents or media.
- Files can be organized into subdirectories, providing flexibility in data management.

Cons:
- Data is only accessible by the app, limiting sharing with other apps unless shared through methods like UIActivityViewController.
- The app needs to manage file storage and deletion, which can add complexity.

3. SQLite
Description: A lightweight, serverless database that can be used to store structured data.

Pros:
- Offers full SQL capabilities for querying and managing data.
- Efficient for handling large amounts of data.

Cons:
- Requires manual management of database connections and queries.
- More boilerplate code compared to higher-level abstractions like Core Data.

4. iCloud Storage
Description: Allows for cloud storage of user data, making it accessible across devices.

Pros:
- Enables data synchronization across multiple devices automatically.
- Useful for backing up user data and providing access from anywhere.

Cons:
- Requires an internet connection to access data.
- Involves additional complexity, including managing user authentication and permissions.
