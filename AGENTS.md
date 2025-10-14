# Repository Guidelines

## Project Structure & Module Organization
The IdleFish app is packaged as a single HAP module under `entry/`. Production ArkTS code lives in `entry/src/main/ets`, with launcher abilities in `entryability`, backup flow in `entrybackupability`, and UI pages in `pages`. App-wide resources are stored in `entry/src/main/resources`, while test doubles stay in `entry/src/mock`. Hypium suites reside in `entry/src/ohosTest/ets/test`. Global configuration for the app scope is defined in `AppScope/app.json5`, and the root `hvigorfile.ts` wires Hvigor build tasks.

## Build, Test, and Development Commands
Run commands from the repository root.
- `hvigor --module entry --task build --mode debug` builds a debug HAP and writes outputs to `entry/build`.
- `hvigor --module entry --task clean` removes generated artifacts for a fresh build.
- `hvigor --module entry --task test` executes Hypium tests contained in `entry/src/ohosTest`.
DevEco Studio’s task runner maps to the same Hvigor tasks; verify the correct module is selected before triggering builds.

## Coding Style & Naming Conventions
ETS files use two-space indentation and keep multiline ArkUI chains tidy with trailing commas. Components and abilities follow PascalCase (`Index`, `EntryAbility`), state fields and functions use camelCase (`message`, `onClick`), and resource identifiers remain snake_case to match `$r('app.*')` lookups. Run the code linter configured in `code-linter.json5` via DevEco Studio’s “Code Linter” tool before requesting review to catch performance and security rule violations.

## Testing Guidelines
Author tests with Hypium (`describe`, `beforeEach`, `it`) and Hamock for stubs. Place files under `entry/src/ohosTest/ets/test` using the `FeatureName.test.ets` pattern. Cover both success and failure paths for new ArkUI state changes, and keep UI logic thin enough to isolate in unit tests. Validate locally with `hvigor --module entry --task test` and rerun after any resource or configuration change.

## Commit & Pull Request Guidelines
Follow Conventional Commits (e.g., `feat:`, `fix:`, `refactor:`) to keep the history searchable, as no legacy git log ships with this project. Reference issue IDs in the body, summarize user-visible behavior, and record test commands executed. Pull requests should outline touched modules (`entry/src/main/ets/pages/...`), attach ArkUI screenshots when visuals change, and call out updates to configuration files such as `build-profile.json5` or `local.properties`.

## Configuration Notes
Store developer-specific data (device IDs, keystores) in `local.properties`, never in source control. When adjusting build variants or signing info, update both root `build-profile.json5` and `entry/build-profile.json5` to keep product metadata consistent.
