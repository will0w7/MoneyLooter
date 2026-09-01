# MoneyLooter - Loot and Gold Farm Tracker Addon

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A lightweight and fast World of Warcraft addon designed to track your gold farms. Track both raw gold and the gold value of looted items thanks to amazing addons like TradeSkillMaster, Auctionator, Auctioneer, OribosExchange or RECrystallized, with reload protection so you don't need to worry about disconnections.

## New in 2.0: Configuration menu, UI scale and more

![MoneyLooter 2.0 Config menu](https://github.com/will0w7/MoneyLooter/blob/main/images/MoneyLooter2.0.png?raw=true)

\[**_WARNING_**\] This version changes a lot of things in the addon, a lot of internal refactors and major changes in the loot price calculations (for the new disenchant settings). Please, if you find a bug, report it on Github (https://github.com/will0w7/MoneyLooter/issues). Thank you!

MoneyLooter 2.0 brings a proper configuration menu, so you no longer need slash commands to configure the addon.

I hadn't added this option in the past in order to keep the addon as simple as possible, but the addon has reached a point where the simplest thing (for the user) is to add it.

\[**_NEW_**\] **Configuration menu:** Click the gear button in the bottom right corner of the addon to open/close the new configuration window, change what you need and press _Save_ to apply the changes. From here you can configure:

- \[**_NEW_**\] **Use disenchant value:** The same toggle as `/ml disenchant`. Now per character, it was account wide in the previous version (released in 1.11).
- \[**_NEW_**\] **Force disenchant value:** One toggle per quality (Common, Uncommon, Rare, Epic). When enabled for a quality, that quality always uses the disenchant value instead of the regular price (except for crafting reagents). **This works only with Auctionator** and only when it is possible to determine whether the item can be disenchanted. In the retail version, Auctionator provides this information (**according to Auctionator**) for **WoD, Legion, BfA, and Shadowlands**. **If it cannot be determined** whether the item can be disenchanted, **the _raw_ auction value will be used** (if it's higher than the configured thresholds).
- **Force vendor price:** The same toggle as `/ml forcevendorprice`. Per character (as it has always been).
- **TSM custom string:** With a _Validate_ button that tells you whether the string is valid, and a _Reset_ button to restore the default (`dbmarket`).
- **Minimum prices:** One row per quality (Common, Uncommon, Rare, Epic) with gold/silver/copper fields, the same as `/ml mprice1..4 value` or `/ml mpricex value`.

\[**_NEW_**\] **UI scale:** A new account wide setting that scales the whole interface (window, text and icons). The default is `1.0`, and it can be adjusted between `0.5` and `2.0` in steps of `0.1`.

## New in 1.11: Auto pick between disenchant value and auction value (disabled by default)

Now, when enabled (using the toggle **_/ml disenchant_** or **_/moneylooter disenchant_**) the addon is going to pick the highest price between the disenchant value and the _raw_ auction value (just selling the item as is). For now, this is only enabled for Auctionator.

Picking the highest value seems like a logical choice, since no one would disenchant an item with a disenchantment value of 2g and an auction price of 500g. However, I'm open to suggestions.

~~This setting is account wide.~~

## New in 1.8: Performance improvements, internal profiler and cache system

**EMA‑based GPH calculation:** GPH (Gold Per Hour) is now computed with an EMA (Exponential Moving Average), smoothing spikes. During the first 30 seconds, an adaptive alpha is applied in the calculation to prevent sudden spikes.

**Two new cache systems:**

- **Item cache:** A cache that persists only during the active session (a /reload clears it) and dramatically reduces calls to WoW’s internal APIs.
- **Price cache:** A cache that also persists only during the active session but has a **one‑hour** expiration time. It prevents unnecessary calls to other addons APIs, as price updates are uncommon during farming sessions. To purge the cache, simply run **_/reload_** to delete it completely.

These caching systems trade a small amount of extra memory for significant performance gains.

**Core refactor:** A general refactor was performed on the addon, mainly in the Core module. This brings performance improvements and simplifies the code for easier maintenance.

**Internal profiler:** I can now track performance regressions and improvements reliably (and everyone can, just use /ml profiler to toggle on/off the profiler).

**Translations:** Translations were added for languages that previously had no localization. They were generated with gpt‑oss. While not perfect, providing them is better than nothing (esES, esMX, enUS, ruRU already had manual translations).

## New in 1.5: OribosExchange, RECrystallized and Auctioneer

Added support for OribosExchange, RECrystallized and Auctioneer.

**Restored the fallback system**: In the past I disabled this system because with certain items (mainly in Retail), when TSM didn't find a price or that price was below the filter, Auctionator could return unrealistically high prices due to lack of auction data.

I've received a few requests, mainly from players of the classic versions, to be able to use Auctionator while they have TSM active and since it is a "bug" that occurs very rarely, I'm reactivating this system and I'll see if I receive any complaints over time.

**Note:** ~~Auctioneer is disabled since the addon is broken and orphaned. I would like to enable it (and complete the implementation) in the future if the developers fix it.~~ Auctioneer is now enabled and working (at least in Retail) using "Best" for the prices ("Median" by default).

## New in 1.1: Summary Mode

![Summary Mode](https://github.com/will0w7/MoneyLooter/blob/main/images/MoneyLooterSummaryMode.gif?raw=true)

Now you can see your loot summary in a clear and organized manner. You can toggle between the loot summary and the loot list by right clicking the toggle button (right click again to come back).

Thanks to [loksinss](https://github.com/loksinss) ([Issue #12](https://github.com/will0w7/MoneyLooter/issues/12)) for the idea :)

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

| Version             | Status |
| ------------------- | ------ |
| Retail              | ✅     |
| Cataclysm Classic   | ✅     |
| Classic Era         | ✅     |
| Classic Hardcore    | ✅     |
| Season of Discovery | ✅     |
| Mists of Pandaria   | ✅     |

✅ = Compatible

❔ = Untested

❌ = Not compatible

## Price source order

1. TSM
2. Auctionator
3. Auctioneer
4. OribosExchange (only Retail)
5. RECrystallize (only Retail, available in Wago)

It's a cascading fallback system, if TSM doesn't find a price, it will look for it in Auctionator, then in Auctioneer, etc. When it finds a valid price, it doesn't continue searching in other addons.

For example, if it finds a valid price in TSM, it won't search in Auctionator or other addons.

## How items are valued

When an item is looted, MoneyLooter determines its value in this order:

1. If **Force vendor price** is enabled, the vendor sell price is always used and no other source is checked.
2. If the item is not Common, Uncommon, Rare or Epic quality, the vendor sell price is used.
3. If **Force disenchant value** is enabled for the item's quality and the external addon can determine its disenchant value, the item is valued using its disenchant value. Currently only Auctionator provides disenchant values. If no disenchant value is available, the regular pricing below is used instead.
4. Otherwise, the regular price sources are tried in the order described above and the first valid price wins.
5. Each price source must return at least the **minimum price threshold** configured for that quality (crafting reagents ignore it). If a source's auction price is below the threshold, it's treated as "no price" and the next source is tried. This threshold is meant to skip items whose auction price is overvalued.
6. If **Use disenchant value** is enabled, the disenchant value is also checked and the higher of the two is used. The disenchant value ignores the threshold, so an item whose auction price falls below the threshold can still be counted by its disenchant value.
7. If no source returns a price, the vendor sell price is used as a last resort.

## Usage

Once installed login in to the game or **/reload** your interface and you will see MoneyLooter ready to be used.

You can alternate between **/ml** or **/moneylooter** for chat commands. In the following examples I will use **/ml**.

        /ml: Toggle show/hide addon window
        /ml show: Show MoneyLooter
        /ml hide: Hide MoneyLooter
        /ml info: Shows information about the addon

        /ml custom: Sets a custom TSM string to be used in the price calculation. If empty, returns the custom TSM string it's currently using.

        /ml forcevendorprice: This command forces the merchant's selling price to always be used, skipping addons. It's a toggle.

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

**Important**: MoneyLooter values items using the TradeSkillMaster, Auctionator, Auctioneer, OribosExchange and RECrystallized addons. If all are available, it will always use TSM. It's a cascading system, first it will check TSM, if it's not available then Auctionator, etc. and finally, if neither is available, it will use the vendor value. I've done it this way because, in my opinion, TSM offers the most accurate and up-to-date prices (if you use the TSM custom string correctly, although for the current expansion, 'dbmarket' is a reliable source of information, it's not so true for old content, transmogs, etc).

MoneyLooter by default sets the minimum prices to 0 for all item qualities. Also, the TSM string it uses is 'dbmarket'.
If you want to change this setting you can do the following:

- **TSM Custom String:** Type /ml custom 'TSMCustomString'

        For example:
        /ml custom check(dbmarket - 1000g, 95% dbmarket, 50% dbmarket)

    In this example, MoneyLooter will use TSM (if available) with the custom price string 'check(dbmarket - 1000g, 95% dbmarket, 50% dbmarket)' to value your items (I'm not recommending this custom string, it's just an example 🙂).

    If you want to return to the default settings use:

        /ml custom dbmarket

- **TSM Minimum price threshold:** Type /ml mprice1 '1234 (g|s|c)'

        For example:
        /ml mprice2 5500 g

    In this example, MoneyLooter will use 5500 gold as minimum threshold for items with quality 2 (Uncommon).

    If you want to return to the default settings use:

        /ml mpricex 0

    See [Usage](#usage) and check available qualities.

This setting are account wide so you only have to set it once and you can use it on all your characters.

**Note:** For accurate item pricing using Auctionator, ensure you have scanned the auction house with it recently.

## Why?

Why not? 🙂

## History

I developed this addon at the end of BFA, during the Shadowlands pre-patch for personal use and every time I come back to the game I use it, almost always unchanged or making slight changes because the Blizzard interface API has changed.

I've used it in Retail, Classic, Classic Era, Classic Hardcore and SoD, but until now I've kept it for personal use (although the GitHub repository was always public).
With the release of TWW I decided to almost completely rewrite the addon code to make it much easier to extend the functionality, debug and make it even more efficient.

So after several days of hard work (never look at that code you wrote all those years ago and thought it was fine), I've decided to make it public, because every time I come back to the game I look for addons to track my farms and I never find anything that I really like.

Plus, I think even if I leave the game, it would cost me little to no effort to keep it updated (I hope - I can confirm after more than a year without playing that the addon needed 0 maintenance, aside from toc updates).

## Contributing, Translating and Issues

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue on the [Issues](https://github.com/will0w7/MoneyLooter/issues) page.

Feel free to report issues or doubts 😊

You can also help translate MoneyLooter! You can find the translations files inside the **locales** folder.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
