# MoneyLooter - Loot and Gold Farm Tracker Addon

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A lightweight and fast World of Warcraft addon designed to track your gold farms. Track both raw gold and the gold value of looted items using the price source you pick in the configuration menu, TradeSkillMaster, Auctionator, Auctioneer, OribosExchange or RECrystallize, with reload protection so you don't need to worry about disconnections.

## New in 2.0: Configuration menu, UI scale, selectable price source, Forever support and more

![MoneyLooter 2.0 Config menu](https://github.com/will0w7/MoneyLooter/blob/main/images/MoneyLooter2.0.png?raw=true)

MoneyLooter 2.0 adds a proper configuration menu. Click the gear button in the bottom right corner of the addon to open it, change what you need and press _Save_ to apply the changes.

**Price source:** You now choose which addon provides your item prices -> **TradeSkillMaster**, **Auctionator**, **Auctioneer**, **OribosExchange** or **RECrystallize**. There is no automatic fallback between addons anymore: only the selected addon is queried. **Make sure you select your price source in the configuration menu, TradeSkillMaster is the default.**

From the same menu you can also configure:

- **Force vendor price:** Use only the vendor sell price.
- **Use disenchant value:** Use the disenchant value when the regular price is below your minimum threshold.
- **Force disenchant value:** One toggle per quality (Uncommon, Rare, Epic). When enabled, that quality is always valued by its disenchant value.
- **TSM custom string:** Your custom TSM price string, with _Validate_ and _Reset_ buttons.
- **Minimum prices:** One threshold per quality (Poor through Epic) in gold/silver/copper. _Poor_ and _Common_ are disabled outside of retail (except for items that are not armor or weapons).

**UI scale:** An account-wide setting that scales the whole interface (window, text and icons). Default `1.0`, adjustable between `0.5` and `2.0` in steps of `0.1`.

**Forever support:** The Forever Beta is now supported. The client is a beta, so support for this version is also considered beta.

_The sections below are historical changelog entries for earlier releases and may not reflect how the addon works today._

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

## New in 1.5: OribosExchange, RECrystallize and Auctioneer

Added support for OribosExchange, RECrystallize and Auctioneer.

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
| Retail              | ✅      |
| Forever             | ✅      |
| Classic Era         | ✅      |
| Classic Hardcore    | ✅      |
| Season of Discovery | ✅      |
| Burning Crusade     | ✅      |
| WOTLK               | ✅      |
| Cataclysm           | ✅      |
| Mists of Pandaria   | ✅      |

✅ = Compatible

❔ = Untested

❌ = Not compatible

## Price source

MoneyLooter uses a single, configurable price source. Open the configuration menu (the gear button in the bottom right corner) and select the addon that will provide your item prices:

- TradeSkillMaster
- Auctionator
- Auctioneer
- OribosExchange (only Retail)
- RECrystallize (only Retail, available in Wago)

Only the selected addon is queried. There is no automatic fallback between addons: if it returns no price, the vendor sell price is used instead. **Remember to select your price source in the configuration menu, TradeSkillMaster is the default.**

## How items are valued

When an item is looted, MoneyLooter determines its value in this order:

1. If **Force vendor price** is enabled, the vendor sell price is always used and no other source is checked.
2. If the item is not armor or a weapon, the quality thresholds are ignored and its price is requested directly from the configured price source. If no price is returned, the vendor sell price is used.
3. If the item's quality is not managed, the vendor sell price is used. Uncommon (2), Rare (3) and Epic (4) are managed everywhere; Poor (0) and Common (1) are only managed in retail, and only for armor/weapons (they can be sold for transmog).
4. Otherwise the regular price is requested from the configured price source. If it reaches the **minimum price threshold** configured for that quality, it is used.
5. If the regular price is below the threshold (or **Force disenchant** is enabled for that quality), and the item is disenchantable (armor/weapon/jewelry of Uncommon, Rare or Epic), the disenchant value is requested instead.
6. If nothing returns a price, the vendor sell price is used as a last resort.

## Usage

Once installed login in to the game or **/reload** your interface and you will see MoneyLooter ready to be used.

You can alternate between **/ml** or **/moneylooter** for chat commands. In the following examples I will use **/ml**.

        /ml: Toggle show/hide addon window
        /ml show: Show MoneyLooter
        /ml hide: Hide MoneyLooter
        /ml info: Shows information about the addon

**Deprecated:** The following commands change settings that are also available in the configuration menu. They will be removed as chat commands in a future version.

        /ml custom: Sets a custom TSM string to be used in the price calculation. If empty, returns the custom TSM string it's currently using.

        /ml forcevendorprice: This command forces the merchant's selling price to always be used, skipping addons. It's a toggle.

        /ml disenchant: Toggles the use of the disenchantment value when it is higher than the direct auction price.

        /ml mprice: Sets the minimum price threshold for a given quality.
            mpricex: All available qualities.
            mprice0: Quality 0 - Poor - Grey
            mprice1: Quality 1 - Common - White
            mprice2: Quality 2 - Uncommon - Green
            mprice3: Quality 3 - Rare - Blue
            mprice4: Quality 4 - Epic - Purple

The price format for mprice is a number followed by g(old), s(ilver) or c(opper). If you only specify the number, gold will be used by default.

        /ml mprice0 50 s
        /ml mprice1 50 s
        /ml mprice2 5000
        /ml mprice3 500 g
        /ml mprice4 5 c

## Configuration

All settings are configured from the in-game menu. Click the **gear button** in the bottom right corner of the addon to open it, change what you need and press **Save** to apply.

- **Price source:** Choose which addon provides your item prices -> TradeSkillMaster, Auctionator, Auctioneer, OribosExchange or RECrystallize. Only the selected addon is queried; there is no automatic fallback between addons.
- **Force vendor price:** Use only the vendor sell price, skipping all price addons.
- **Use disenchant value:** Use the disenchant value when the regular price is below your minimum threshold.
- **Force disenchant value:** One toggle per quality (Uncommon, Rare, Epic). When enabled, that quality is always valued by its disenchant value.
- **TSM custom string:** Your custom TSM price string, with **Validate** and **Reset** buttons.
- **Minimum prices:** One threshold per quality (Poor through Epic) in gold/silver/copper.
- **UI scale:** Account-wide scaling of the whole interface, from `0.5` to `2.0` (default `1.0`).

By default, MoneyLooter sets all minimum prices to `0`, uses **TradeSkillMaster** as the price source, and the TSM string `dbmarket`.

Settings are account wide, so you only have to set them once and they apply to all your characters.

Some settings can still be changed with chat commands, but those commands are deprecated and will be removed in a future version, see [Usage](#usage).

**Note:** For accurate item pricing using Auctionator, make sure you have scanned the auction house with it recently.

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
