import { Command, flags } from '@oclif/command'
import * as elastic from 'elasticsearch'
let client = new elastic.Client({
  //set host before running
  host: '',
})

class Elastic extends Command {
  static description = 'CLI for indexing data on aws elasticsearch service'

  static flags = {
    // version, help flag
    version: flags.version({ char: 'v' }),
    help: flags.help({ char: 'h' }),
    createIndex: flags.boolean({ char: 'c', description: 'creates the index' }),
    message: flags.string({ char: 'm', description: 'message to create' })
  }

  static args = [{ name: 'index' }]

  async run() {
    const { args, flags } = this.parse(Elastic)

    //const name = flags.name || 'world'
    //this.log(`hello ${name} from ./src/index.ts`)
    //where more code goes

    if (flags.createIndex) {
      try {
        const response = await client.indices.create({
          index: "documents",
          body: {
            "settings": {
              "number_of_replicas": 1,
              "number_of_shards": 1
            },
            "mappings": {
              "messages": {
                "properties": {
                  "message": { "type": "text" }
                }
              }
            }
          }
        })
        console.log(response)
      } catch (error) {
        console.log(error)
      }
    }
    if (flags.message) {
      const message = flags.message
      try {
        await client.index({
          index: 'documents',
          type: 'messages',
          body: {
            message: "test"
          }
        });
      } catch (error) {
        console.log(error)
      }




      client.ping({
        // ping usually has a 3000ms timeout
        requestTimeout: 1000
      }, function (error) {
        if (error) {
          console.trace('elasticsearch cluster is down!');
        } else {
          console.log('All is well');
        }
      });

    }
  }
}
  export = Elastic
