# Webhook Manager
A tool written in batch that allows you to host webhooks on a Windows machine, and, when they are triggered, run a customizable task.

![Main Menu Running](https://i.imgur.com/PeLFxDS.jpg)

![Main Menu Stopped](https://i.imgur.com/UIGZ4nu.jpg)



# What Can you do with Webhook Manager?

**Lot's of things!** You can create as many unique tasks as you want, and when you visit the url it will trigger it. For example, you could make a task that launches a website on chrome. Whenever you visit the webhook's URL, it would run! Here's an example script:

  `{`
    `"id": "launch-website",`
    `"execute-command": "chrome.exe",`
    `"command-working-directory": "C:\Program Files (x86)\Google\Chrome\Application\",`
    `"response-message": "Opened Website",`
    `"pass-arguments-to-command": [`
      `{`
        `"source": "url",`
        `"name": "website",`
      `},`
    `],`

  `},`

From this example, you could visit http://localhost:9444/hooks/launch-website?site=http://itcommand.tech,

and it would launch http://itcommand.tech on your computer! This becomes especially powerful when you allow connections through your router, especially if you have a domain that you can forward to the application, since you can run tasks like this remotely.

You can also make scripts that launch programs, save a string to a text file, and you can create crazy complex tasks if you read up on the [documentation for the webhook tool](https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md) we use to host the webhooks!

*Note: You can set the port (:9444 in the example above) to any port you want in the settings!*

 

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

### Let's look at these pieces individually.

**First, look at this chunk:**

`{`
    `"id": "example-launcher",`
    `"execute-command": "example.bat",`
    `"command-working-directory": "G:\\Example\\Path\\To\\Files\\Folder",`
    `"response-message": "Example Triggered.",`

  `},`

This is a very simple webhook. When you go to the url http://localhost:944/hooks/example-launcher it will run the file `example.bat` located in `G:\Example\Path\To\Files\Folder`. It will also display the text `Example Triggered` on the web browser it was triggered with.

***

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

***

**Also note:**

`{`
    `"id": "Internal-Ping",`
    `"response-message": "Pong OK.",`
	`"execute-command": "DummyCommand.bat",`
  `},`

**The `Internal-Ping` webhook MUST be included in any webhook json file you use (where you create the webhooks) or the Webhook-Manager program will not work properly.** This is because the Webhook Manager tool tests its status by using the internal-ping webhook.

***

#### These were just some simple examples. Things get much more powerful!

For more help visit Adnanh's pages:

https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md

https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md

## Editing Parameters

![Parameter Settings](https://i.imgur.com/51nUeI1.jpg)

In the "Edit Parameters" menu you can change some awesome settings:

**Hooks File** - This file is the .json file that the webhooks are written in. See the examples above for help on that.

**HTTPS** - Set this to true if you want to use https when connecting to the webhooks. This will encrypt your data, however unless you have a valid https key file, most browsers will provide a warning that the connection is not secure. This is less important if you are using IOT devices or calling the webhook from a script.

**HTTPS Key File** - Set this to the location of the https key file. Only do so if you are using https.

**Port** - Here you can set the port the program listens on. The default is 9444, but you can set it to any port you would like.

**Hot Reload** - This option will tell the webhook host to automatically reload the webhooks when there is a change in the webhooks json file. Otherwise, when you change, remove, or add a webhook to the json file, you would have to stop and start the webhook program. This uses more resources, however, so only use this while testing things.

## Running an external test (and some tips on setting up webhooks for outside your local network)

**If you plan on calling webhooks from outside your local network, you will need to open ports in your router's settings and forward them to your computer** (make sure your computer has a static IP address too!)

When doing this, it can be helpful to test it to make sure it is working. **The tool works with ipv4 and ipv6 external IP addresses**. The tool also allows you to check a domain-based web address if you have a domain that forwards to your computer (you can set up one for free using [dynu](dynu.com), which also has a super helpful program that checks if your provider has changed your external IP address, which they often do).

If, when you run the test, it looks like you do not have the ports forwarded, the tool will provide a link to your router's settings as well as instructions on how to set it up (note that you will need the administrator username and password for your router. In most homes, these are still set to the default, which you can look up online). If it does not do this, please let us know on the issues page as your router probably isn't in our system yet!



#### Tools used:

**Webhook.exe** https://github.com/adnanh/webhook

**Winhttpjs.bat** https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/winhttpjs.bat

**Tee.bat** https://stackoverflow.com/a/16641964/7872447

**CMDS.bat** https://github.com/ITCMD/CMDS

**JSONedit.exe** https://tomeko.net/software/JSONedit/index.php

*Code for open source tools were analyzed. JSONedit.exe (the only closed source program) was scanned with numerous antiviruses. Results were clean*.

