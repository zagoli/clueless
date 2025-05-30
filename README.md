# Clueless

Backend for [clueless.zagoli.com](https://clueless.zagoli.com) - A Clue board game companion app that helps track game state and provides insights during gameplay.

## Features

- Track cards in and outside players' hands
- Automatically discover cards in players' hands through deduction
- Get suggestions about which cards to ask about next
- RESTful API for frontend integration

## Installation

### Prerequisites

- Erlang >= 27.1.2
- Elixir >= 1.18.1

### Setup

1. Clone the repository
2. Install dependencies:

    ```bash
    mix deps.get
    ```

3. Optionally run the tests:

    ```bash
    mix test
    ```

4. Start the server:

    ```bash
    mix phx.server
    ```

## Project Structure

The project is an Elixir umbrella application with two apps:

- `apps/clueless` - Core game logic and state management
- `apps/clueless_web` - Phoenix web application providing the REST API
