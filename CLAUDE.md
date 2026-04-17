## Project

<<project description>>

- `scripts/` - Put general reusable scripts in here. Scripts related to skills should be colocated with the skill instead, generally.

## Guidelines

- Use `bun` for runtime and package management. Examples:
  - `bun install`
  - `bun add package`
  - `bun run script.ts`
  - `bunx package@latest ...`
  - [Bun Workspaces](https://bun.com/docs/pm/workspaces.md)
    - run in a workspace package: `bun run --filter @repo/package-name run ...`
- Package scripts to use:
  - `bun run fix` - fmt, lint, typecheck (almost always prefer this to any one sub-part)
  - `bun run check` - typecheck, fmt, lint
  - `bun run fmt` - formatting with oxfmt

- Use vitest for tests (not `bun:test`)
  - Prefer integration tests with snapshots over tight unit tests
- Use `cac` for clis
- Use `up-fetch` for fetch, creating reusable fetch clients
- Use `zod` for schema validation for external requests, environment variables, etc. Upfetch supports this natively as a `schema` param
- Never type cast or use `any`, always make your types _flow_ naturally. If you have typecheck issues, you're probably modeling your types incorrectly. You can use `zod` to validate external data.
  - You can use `ts-invariant` to type narrow when the existing types can't validate something for you, instead of casting.
- Write & think about good abstractions rather than adding new features willy-nilly. It's always worth it to spend a bit more time thinking about where something should go rather than adding it.
  - Refactors are never out of scope even if the user only asks you to add one pointed thing. Always be willing to refactor and restructure other code to make it work more simply, elegantly, and make it more readable in general.

- Use bun runtime apis for common things. Some examples of nice apis:
  - [`import { Glob } from "bun"`](https://bun.com/docs/runtime/glob.md)
  - [Bun Shell](https://bun.com/docs/runtime/shell.md)
    - Example: ``const welcome = await $\`echo "Hello World!"\`.text();``
  - [`import { SQL } from "bun";`](https://bun.com/docs/runtime/sql.md)
    - Supports sqlite, postgres, mysql
  - [`Bun.color`](https://bun.com/docs/runtime/color.md)
  - [`Bun.hash`](https://bun.com/docs/runtime/hashing.md)
    - Use xxhash3 as a good default
  - [various utils](https://bun.com/docs/runtime/utils.md): Examples:
    - `Bun.deepEquals`
    - `Bun.sleep`
    - `Bun.randomUUIDv7`
- Bun automatically loads .env, so don't use dotenv.

- When asked to make skills/commands, never create commands in `.claude/commands/`, always create `.claude/skills/<skill>/SKILL.md`. Skills were recently made user-invocable.
  - When the user asks to make a reusable skill "use subagents", it's often a good idea to add a dedicated subagent in `.claude/agents` so that the prompt is consistent each time. Otherwise, the model will tend to get lazy as their context window fills up and prompt subagents poorly, as well as just be slower in general because it has to write out many detailed prompts.

- **Never** commit, push, git stash, etc. unless asked
- Never add claude attribution/cosignatures to commits
