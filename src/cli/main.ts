import * as log from './core/logging.ts'

const commands: { [key: string]: () => (Promise<void> | void) } = {
  install: async () => {
    log.info("Install")
  },
  help: () => {
    log.info("Help")
  }
}

commands[Deno.args[0] || 'help']();
