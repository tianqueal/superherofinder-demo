# Superhero Finder Demo

A simple application for iOS, iPadOS and macOS built with SwiftUI that allows users to search for their favourite superheroes and view their detailed statistics. This project demonstrates modern Swift development practices, including SwiftUI for the UI, a repository pattern for data abstraction, and handling of network requests.

## Features

*   **Search**: Find superheroes by name using the Superhero API.
*   **Detailed View**: See comprehensive details for each superhero, including their biography, appearance, and connections.
*   **Power Stats**: Visualise power statistics (e.g., intelligence, strength, speed) with a dynamic chart.
*   **Asynchronous UI**: Asynchronous image loading with placeholder and error states for a smooth user experience.
*   **Clean Architecture**: A clear separation of concerns using a repository pattern to abstract the data source (API, local JSON, or mock data).
*   **Configuration Management**: Securely manages API keys and endpoints using `.xcconfig` files.

## Screenshots

Here are some examples of the application's user interface.

| Search View | Search Results | Detail View |
| :---: | :---: | :---: |
| *The initial view where users can start a search.* | *A list of superheroes matching the search query.* | *A detailed view showing the superhero's image and power stats.* |
| <img width="547" height="1043" alt="Screenshot 2025-10-18 at 20 12 03" src="https://github.com/user-attachments/assets/b8d34f56-81e6-4681-bc67-849b1809285a" /> | <img width="547" height="1043" alt="Screenshot 2025-10-18 at 20 08 13" src="https://github.com/user-attachments/assets/e291158e-4d8b-4bbf-a75f-03d5a8180531" /> | <img width="547" height="1043" alt="Screenshot 2025-10-18 at 20 08 29" src="https://github.com/user-attachments/assets/effffcf8-f1d9-4df1-8a70-6046b2d24c8d" /> |

## Architecture

The project follows a clean, MVVM-inspired architecture:

*   **Views**: Located in `superherofinder-demo/Views/`, these are the SwiftUI components that make up the user interface.
    *   [`SuperheroFinderView.swift`](superherofinder-demo/Views/SuperheroFinderView.swift): The main screen for searching.
    *   [`SuperheroDetailView.swift`](superherofinder-demo/Views/SuperheroDetailView.swift): Displays the details of a selected superhero.
    *   [`SuperheroStatsView.swift`](superherofinder-demo/Views/SuperheroStatsView.swift): A chart view for power statistics.
*   **Models**: Defined in [`superherofinder-demo/Models/SuperheroModel.swift`](superherofinder-demo/Models/SuperheroModel.swift), these structs represent the data fetched from the API.
*   **Repositories**: Found in [`superherofinder-demo/Repositories/SuperheroRepository.swift`](superherofinder-demo/Repositories/SuperheroRepository.swift), this layer is responsible for fetching data. It uses a protocol-oriented approach to allow for different data sources (network, local file, or mock data for previews and testing).
*   **Helpers**: The [`superherofinder-demo/Helpers/Config.swift`](superherofinder-demo/Helpers/Config.swift) file provides a clean way to access configuration values from the build environment.

## Setup and Configuration

This project uses `.xcconfig` files to manage API credentials, which are excluded from version control via the [`.gitignore`](.gitignore) file. To build and run the project, you must create these files.

1.  **Obtain an API Key**: You will need an access token from the [Superhero API](https://superheroapi.com/).

2.  **Create Configuration Files**: In the `superherofinder-demo/Configurations/` directory, create two files: `Debug.xcconfig` and `Release.xcconfig`.

3.  **Add API Credentials**: Add the following content to both files, replacing `YOUR_API_KEY` with your actual access token.

    ````
    // filepath: superherofinder-demo/Configurations/Debug.xcconfig
    API_BASE_URL = https:/$()/superheroapi.com/api
    API_KEY = YOUR_API_KEY
    ````

    ````
    // filepath: superherofinder-demo/Configurations/Release.xcconfig
    API_BASE_URL = https:/$()/superheroapi.com/api
    API_KEY = YOUR_API_KEY
    ````

## How to Build

1.  Clone the repository.
2.  Complete the steps in the **Setup and Configuration** section.
3.  Open `superherofinder-demo.xcodeproj` in Xcode.
4.  Select a target simulator or device and press the "Run" button.
