# MoneyLooter - Loot and Gold Farm Tracker Addon

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A lightweight and blazingly-fast 🦀 World of Warcraft addon designed to track your gold farms. Track both raw gold and the gold value of looted items thanks to amazing addons like Auctionator or TradeSkillMaster.

## Key Features

* **Lightweight & Efficient:** Minimal impact on your game's performance. Low memory footprint and minimal CPU usage.
* **No dependencies on third-party party libraries:** Ensures maximum compatibility and reducing the risk of conflicts and instability with new game versions. Third-party libraries do a great job making it much easier to develop addons with complex interfaces, but they also introduce a lot of new vectors for potential errors, and for an addon as simple as this, they would only make things more complicated.
* **Accurate Gold Tracking:** Monitors your gold gains from looted gold and items. Excludes vendor sales from the count, allowing you to clear your inventory without affecting your loot tracking. Item prices are determined using TradeSkillMaster (if available), Auctionator (if available), or vendor sell price as a fallback. Crafting reagents are always valued at their auction sell price (if TradeSkillMaster or Auctionator are available), regardless of minimum price thresholds.
* **Reload protection:** If another of your addons crashes or you are forced to reload the interface or even logout, when you come back your gold numbers will still be there. It doesn't matter if you previously paused the gold tracking or the counter was running when you /reload'ed or disconnected, it will still be the same when you come back.
* **Intuitive Interface:** A user-friendly display that presents your gold farm in a clear and organized manner.
* **Minimal Configuration:** Designed for a seamless experience with minimal setup. All configuration is done through simple chat commands, without the need for complex interfaces. Customize the TSM custom price string and set minimum price thresholds for different item qualities.

## New UI and MoneyLooter 1.0

![New UI](https://github.com/will0w7/MoneyLooter/blob/main/images/MoneyLooterNewUI.png?raw=true)

I've been working for a few days on a new UI to get rid of the old look of the previous one but keep it simple and performant, and with the release of the 1.0 here it is!

This new version comes with this flawless UI and a lot of bug fixes!

I might still change a few things, but for now I'm happy with the result 🙂

## Installation

Download the latest release from [Wago](https://addons.wago.io/addons/moneylooter), [CurseForge](https://www.curseforge.com/wow/addons/moneylooter), [WoWInterface](https://www.wowinterface.com/downloads/info26844-MoneyLooter-LootandGoldFarmTrackerAddon.html) or [GitHub](https://github.com/will0w7/MoneyLooter/releases/latest) using your favourite addon manager.

## Manual Installation

1. Download the latest release from the [releases](https://github.com/will0w7/MoneyLooter/releases) page.
2. Extract the contents of the zip file into your `World of Warcraft\VERSION\Interface\AddOns` directory.
3. Launch World of Warcraft and enable the addon in the AddOns list.

## Compatibility Status

|             Version            | Status |
| ------------------------------ | ------ |
| Retail                         |   ✅   |
| Cataclysm Classic              |   ✅   |
| Classic Era                    |   ✅   |
| Classic Hardcore               |   ✅   |
| Season of Discovery            |   ✅   |
| Wrath of the Lich King Classic |   ❔   |
| The Burning Crusade Classic    |   ❔   |

✅ = Compatible

❔ = Untested

❌ = Not compatible

## Usage

Once installed login in to the game or **/reload** your interface and you will see MoneyLooter ready to be used.

You can alternate between **/ml** or **/moneylooter** for chat commands. In the following examples I will use **/ml**.

        /ml: Toggle show/hide addon window
        /ml show: Show MoneyLooter
        /ml hide: Hide MoneyLooter
        /ml info: Shows information about the addon
        
        /ml custom: Sets a custom TSM string to be used in the price calculation. If empty, returns the custom TSM string it's currently using.
        
        /ml mprice: Sets the minimum price threshold for a given quality.
            mpricex: All available qualities.
            mprice1: Quality 1 - Common - White
            mprice2: Quality 2 - Uncommon - Green
            mprice3: Quality 3 - Rare - Blue
            mprice4: Quality 4 - Epic - Purple
        * The rest of the qualities will use the vendor price, if they have it.

The price format for mpricex is a number followed by g(old), s(ilver) or c(opper). If you only specify the number, gold will be used by default.

        /ml mprice1 50 s
        /ml mprice2 5000
        /ml mprice3 500 g
        /ml mprice4 5 c

## Configuration

**Important**: MoneyLooter values items using the TradeSkillMaster and Auctionator addons. If both are available, it will always use TSM. It's a cascading system, first it will check TSM, if it's not available then Auctionator and finally, if neither is available, it will use the vendor value. I've done it this way because, in my opinion, TSM offers the most accurate and up-to-date prices (if you use the TSM custom string correctly, although for the current expansion, 'dbmarket' is a reliable source of information, it's not so true for old content, transmogs, etc).

MoneyLooter by default sets the minimum prices to 0 for all item qualities. Also, the TSM string it uses is 'dbmarket'.
If you want to change this setting you can do the following:

* **TSM Custom String:** Type /ml custom 'TSMCustomString'

        For example:
        /ml custom check(dbmarket - 1000g, 95% dbmarket, 50% dbmarket)

    In this example, MoneyLooter will use TSM (if available) with the custom price string 'check(dbmarket - 1000g, 95% dbmarket, 50% dbmarket)' to value your items (I'm not recommending this custom string, it's just an example 🙂).

    If you want to return to the default settings use:

        /ml custom dbmarket
* **TSM Minimum price threshold:** Type /ml mprice1 '1234 (g|s|c)'

        For example:
        /ml mprice2 5500 g

    In this example, MoneyLooter will use 5500 gold as minimum threshold for items with quality 2 (Uncommon).

    If you want to return to the default settings use:

        /ml mpricex 0

    See [Usage](#usage) and check available qualities.

This setting are account-wide so you only have to set it once and you can use it on all your characters.

**Note:** For accurate item pricing using Auctionator, ensure you have scanned the auction house with it recently.

## Why?

Why not? 🙂

## History

I developed this addon at the end of BFA, during the Shadowlands pre-patch for personal use and every time I come back to the game I use it, almost always unchanged or making slight changes because the Blizzard interface API has changed.

I've used it in Retail, Classic, Classic Era, Classic Hardcore and SoD, but until now I've kept it for personal use (although the GitHub repository was always public).
With the release of TWW I decided to almost completely rewrite the addon code to make it much easier to extend the functionality, debug and make it even more efficient.

So after several days of hard work (never look at that code you wrote all those years ago and thought it was fine), I've decided to make it public, because every time I come back to the game I look for addons to track my farms and I never find anything that I really like.

Plus, I think even if I leave the game, it would cost me little to no effort to keep it updated (I hope).

## Contributing and Issues

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue on the [Issues](https://github.com/will0w7/MoneyLooter/issues) page.

Feel free to report issues or doubts 😊

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
