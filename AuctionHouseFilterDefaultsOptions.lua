local addonName, AHFD  = ...

AHFD.Options = {}

-- Blizzard_AuctionHouseUI\Blizzard_AuctionHouseUtil.lua:10
local function GetQualityFilterString(itemQuality)
	local hex = select(4, C_Item.GetItemQualityColor(itemQuality));
	local text = _G["ITEM_QUALITY"..itemQuality.."_DESC"];
	return "|c"..hex..text.."|r";
end

-- Blizzard_AuctionHouseUI\Blizzard_AuctionHouseUtil.lua:16
AHFD.Options.filtersStrings = {
	[Enum.AuctionHouseFilter.UncollectedOnly] = AUCTION_HOUSE_FILTER_UNCOLLECTED_ONLY,
	[Enum.AuctionHouseFilter.UsableOnly] = AUCTION_HOUSE_FILTER_USABLE_ONLY,
	[Enum.AuctionHouseFilter.CurrentExpansionOnly] = AUCTION_HOUSE_FILTER_CURRENTEXPANSION_ONLY,
	[Enum.AuctionHouseFilter.UpgradesOnly] = AUCTION_HOUSE_FILTER_UPGRADES_ONLY,
	[Enum.AuctionHouseFilter.PoorQuality] = GetQualityFilterString(Enum.ItemQuality.Poor),
	[Enum.AuctionHouseFilter.CommonQuality] = GetQualityFilterString(Enum.ItemQuality.Common),
	[Enum.AuctionHouseFilter.UncommonQuality] = GetQualityFilterString(Enum.ItemQuality.Uncommon),
	[Enum.AuctionHouseFilter.RareQuality] = GetQualityFilterString(Enum.ItemQuality.Rare),
	[Enum.AuctionHouseFilter.EpicQuality] = GetQualityFilterString(Enum.ItemQuality.Epic),
	[Enum.AuctionHouseFilter.LegendaryQuality] = GetQualityFilterString(Enum.ItemQuality.Legendary),
	[Enum.AuctionHouseFilter.ArtifactQuality] = GetQualityFilterString(Enum.ItemQuality.Artifact),
	[Enum.AuctionHouseFilter.LegendaryCraftedItemOnly] = AUCTION_HOUSE_FILTER_RUNECARVING,
};

-- Blizzard_AuctionHouseUI\Blizzard_AuctionHouseUtil.lua:45
AHFD.Options.categoryStrings = {
	[Enum.AuctionHouseFilterCategory.Uncategorized] = "",
	[Enum.AuctionHouseFilterCategory.Equipment] = AUCTION_HOUSE_FILTER_CATEGORY_EQUIPMENT,
	[Enum.AuctionHouseFilterCategory.Rarity] = AUCTION_HOUSE_FILTER_CATEGORY_RARITY,
};

AHFD.Options.filterGroups = {
    {
        category = nil,
        index = 1,
        items = {
            Enum.AuctionHouseFilter.UncollectedOnly, 
            Enum.AuctionHouseFilter.UsableOnly, 
            Enum.AuctionHouseFilter.CurrentExpansionOnly
        }
    },
    {
        category = AHFD.Options.categoryStrings[Enum.AuctionHouseFilterCategory.Equipment],
        index = 2,
        items = {
            Enum.AuctionHouseFilter.UpgradesOnly, 
        }
    },
    {
        category = AHFD.Options.categoryStrings[Enum.AuctionHouseFilterCategory.Rarity],
        index = 3,
        items = {
            Enum.AuctionHouseFilter.PoorQuality,
            Enum.AuctionHouseFilter.CommonQuality,
            Enum.AuctionHouseFilter.UncommonQuality,
            Enum.AuctionHouseFilter.RareQuality,
            Enum.AuctionHouseFilter.EpicQuality,
            Enum.AuctionHouseFilter.LegendaryQuality,
            Enum.AuctionHouseFilter.ArtifactQuality,
            Enum.AuctionHouseFilter.LegendaryCraftedItemOnly,
        }
    }
}

sort(AHFD.Options.filterGroups, function(a,b) return a.index < b.index end)

function  AHFD.Options:init()
    local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
    local category, layout = Settings.RegisterVerticalLayoutCategory(AddOnInfo[2])
    Settings.RegisterAddOnCategory(category)
    AHFD.OptionsID = category:GetID()
 
    for k, entry in pairs(AHFD.Options.filterGroups) do
        if entry.category then
            layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(entry.category))
        end

        for _, id in ipairs(entry.items) do
            local setting = Settings.RegisterAddOnSetting(self.category, "filters" .. id, id, AHFDDB, "boolean", self.filtersStrings[id], AHFD.filters[id])
            Settings.CreateCheckbox(category, setting, nil)
        end
    end

  
end