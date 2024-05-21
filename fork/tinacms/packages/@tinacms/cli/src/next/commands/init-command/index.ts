import { Command, Option } from 'clipanion'
import { logger } from '../../../logger'
import { command } from '../../../cmds/init'

export class InitCommand extends Command {
  static paths = [['init'], ['init', 'backend']]
  pathToForestryConfig = Option.String('--forestryPath', {
    description:
      'Specify the relative path to the .forestry directory, if importing an existing forestry site.',
  })
  rootPath = Option.String('--rootPath', {
    description:
      'Specify the root directory to run the CLI from (defaults to current working directory)',
  })
  debug = Option.Boolean('--debug', false, {
    description: 'Enable debug logging',
  })
  noTelemetry = Option.Boolean('--noTelemetry', false, {
    description: 'Disable anonymous telemetry that is collected',
  })
  tinaVersion = Option.String('--tinaVersion', {
    description: 'Specify a version for tina dependencies',
  })
  static usage = Command.Usage({
    category: `Commands`,
    description: `Add Tina to an existing project`,
  })

  async catch(error: any): Promise<void> {
    logger.error('Error occured during tinacms init')
    console.error(error)
    process.exit(1)
  }

  async execute(): Promise<number | void> {
    const isBackend = Boolean(this.path.find((x) => x === 'backend'))
    const rootPath = this.rootPath || process.cwd()
    await command.execute({
      isBackendInit: isBackend,
      rootPath: rootPath,
      pathToForestryConfig: this.pathToForestryConfig || rootPath,
      noTelemetry: this.noTelemetry,
      debug: this.debug,
      tinaVersion: this.tinaVersion,
    })
    process.exit()
  }
}
