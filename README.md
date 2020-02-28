# Webhook Manager
 A Tool to create webhooks to make tasks.





## Creating webhooks

The webhooks are managed through Adnanh/webhooks, which uses a .json config file. Here is an example file:



`[`
  `{`
    `"id": "example-launcher",`
    `"execute-command": "example.bat",`
    `"command-working-directory": "G:\\Example\\Path\\To\\Files\\Folder",`
    `"response-message": "Example Triggered.",`

  `},`

  `{`
    `"id": "PassToBatch",`
    `"execute-command": "example.bat",`
    `"command-working-directory": "G:\\Example\\Path\\To\\Files\\Folder",`
    `"response-message": "Passed Parameter.",`
    `"pass-arguments-to-command": [`
      `{`
        `"source": "url",`
        `"name": "parameter",`
      `},`
    `],`

  `},`

  `{`
    `"id": "Internal-Ping",`
    `"response-message": "Pong OK.",`
	`"execute-command": "DummyCommand.bat",`
  `},`
`]`

**Let's look at these pieces individually.**

First, look at this chunk:

`{`
    `"id": "example-launcher",`
    `"execute-command": "example.bat",`
    `"command-working-directory": "G:\\Example\\Path\\To\\Files\\Folder",`
    `"response-message": "Example Triggered.",`

  `},`

This is a very simple webhook. When you go to the url http://localhost:944/hooks/example-launcher it will run the file `example.bat` located in `G:\Example\Path\To\Files\Folder`. It will also display the text `Example Triggered` on the web browser it was triggered with.

`{`
    `"id": "PassToBatch",`
    `"execute-command": "example.exe",`
    `"command-working-directory": "G:\\Example\\Path\\To\\Files\\Folder",`
    `"response-message": "Passed Parameter.",`
    `"pass-arguments-to-command": [`
      `{`
        `"source": "url",`
        `"name": "parameter",`
      `},`
    `],`

  `},`

This Chunk does something very similar. However, this webhook also accepts parameters. In this example, you can go to the url http://localhost:9444/hooks/PassToBatch?parameter=12345 and the batch file `example.bat` would receive the parameter `1234`. This is where the webhook program gets really powerful.

`{`
    `"id": "Internal-Ping",`
    `"response-message": "Pong OK.",`
	`"execute-command": "DummyCommand.bat",`
  `},`

**The Internal-Ping webhook MUST be included in any webhook files or the Webhook-Manager program will not work properly.**

## These were just some simple examples. Things get much more powerful!

For more help visit Adnanh's pages:

https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md

https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md



