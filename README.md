# Webhook Manager
A tool written in batch that allows you to host webhooks on a Windows machine, and, when they are triggered, run a customizable task. It uses [Adnanh's webhook.exe](https://github.com/adnanh/webhook) to host the webhooks.

![Main Menu Running](https://i.imgur.com/iv6ns68.png)

![Main Menu Stopped](https://i.imgur.com/UIGZ4nu.jpg)



# What Can you do with Webhook Manager?

**Lot's of things!** You can create as many unique tasks as you want, and when you visit the url it will trigger it. For example, you could make a task that launches a website on chrome. Whenever you visit the webhook's URL, it would run! 



## Editing Launch Parameters

![Parameter Settings](https://i.imgur.com/51nUeI1.jpg)

In the "Edit Parameters" menu you can change some awesome settings:

**Hooks File** - This file is the .json file that the webhooks are written in. See the examples above for help on that.

**HTTPS** - Set this to true if you want to use https when connecting to the webhooks. This will encrypt your data, however unless you have a valid https key file, most browsers will provide a warning that the connection is not secure. This is less important if you are using IOT devices or calling the webhook from a script.

**HTTPS Key File** - Set this to the location of the https key file. Only do so if you are using https.

**Port** - Here you can set the port the program listens on. The default is 9444, but you can set it to any port you would like.

**Hot Reload** - This option will tell the webhook host to automatically reload the webhooks when there is a change in the webhooks json file. Otherwise, when you change, remove, or add a webhook to the json file, you would have to stop and start the webhook program. This uses more resources, however, so only use this while testing things.

### Running an external test (and some tips on setting up webhooks for outside your local network)

**If you plan on calling webhooks from outside your local network, you will need to open ports in your router's settings and forward them to your computer** (make sure your computer has a static IP address too!)

When doing this, it can be helpful to test it to make sure it is working. **The tool works with ipv4 and ipv6 external IP addresses**. The tool also allows you to check a domain-based web address if you have a domain that forwards to your computer (you can set up one for free using [dynu](dynu.com), which also has a super helpful program that checks if your provider has changed your external IP address and updates it for you, which they often do).

If, when you run the test, it looks like you do not have the ports forwarded, the tool will provide a link to your router's settings as well as instructions on how to set it up (note that you will need the administrator username and password for your router. In most homes, these are still set to the default, which you can look up online, and then you should change them). If it does not do this, please let us know on the issues page as your router probably isn't in our system yet!

> NOTE: for our XFinity and Comcast users, if you use the comcast provided modem-router-combo tower, you will not be able to use this tool properly. Comcast purposely designed the router to block port forwarding features from outside of your network, so while it will work when you are connected to your WiFi, it will not work for others. There is also some evidence that these routers collect additional information and throttle your network. If you can, buy your own modem and router to unlock the features you are paying comcast for. This also means you will not be able to host websites, mail servers, or gaming servers.

 

## Creating webhooks

The webhooks are managed through the **new built in editor program**.

![Editor main page](https://i.imgur.com/lrca32V.png)

![Add webhook](https://i.imgur.com/SX5qpTo.png)

![Remove Webhooks](https://i.imgur.com/wR6GBFx.png)



***While you don't have to,*** you can also edit the webhooks directly with notepad or notepad++.

This program runs off of Adnanh/webhooks, which uses a .json config file. Here is an example file:

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

Don't worry, the included editor wont let you 

***

#### These were just some simple examples. Things get much more powerful!

For more help visit Adnanh's pages:

https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md

https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md

#### Tools used:

**Webhook.exe** https://github.com/adnanh/webhook

**Winhttpjs.bat** https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/winhttpjs.bat

**Tee.bat** https://stackoverflow.com/a/16641964/7872447

**CMDS.bat** https://github.com/ITCMD/CMDS

**JSONedit.exe** https://tomeko.net/software/JSONedit/index.php

*Code for open source tools were analyzed. JSONedit.exe (the only closed source program) was scanned with numerous antiviruses. Results were clean*.

