local addonName, AHFD  = ...

-- Blizzard_AuctionHouseUI\Blizzard_AuctionHouseUtil.lua:31
AHFD.filters = {
	[Enum.AuctionHouseFilter.UncollectedOnly] = false,
	[Enum.AuctionHouseFilter.UsableOnly] = false,
	[Enum.AuctionHouseFilter.CurrentExpansionOnly] = false,
	[Enum.AuctionHouseFilter.UpgradesOnly] = false,
	[Enum.AuctionHouseFilter.PoorQuality] = true,
	[Enum.AuctionHouseFilter.CommonQuality] = true,
	[Enum.AuctionHouseFilter.UncommonQuality] = true,
	[Enum.AuctionHouseFilter.RareQuality] = true,
	[Enum.AuctionHouseFilter.EpicQuality] = true,
	[Enum.AuctionHouseFilter.LegendaryQuality] = true,
	[Enum.AuctionHouseFilter.ArtifactQuality] = true,
};

local addon1LoadedFrame = CreateFrame("Frame")
addon1LoadedFrame:RegisterEvent("ADDON_LOADED")
addon1LoadedFrame:SetScript("OnEvent", function(self, event, name)
    if name == "Blizzard_AuctionHouseUI"then
        if AUCTION_HOUSE_DEFAULT_FILTERS and AHFDDB then 
			AUCTION_HOUSE_DEFAULT_FILTERS = AHFDDB
			DevTool:AddData(AUCTION_HOUSE_DEFAULT_FILTERS, "AHFAUCTION_HOUSE_DEFAULT_FILTERSDB")
      	end
    end
end)

local addon = CreateFrame("Frame")
addon:RegisterEvent("PLAYER_LOGIN")
addon:SetScript("OnEvent", function()
	AHFDDB = AHFDDB or AHFD.filters
	local function hasError(tab)
		for index, value in pairs(tab) do
			if type(value) ~= "boolean" or type(index) ~= "number" then return true end
		end
		if #AHFDDB ~= #AHFD.filters then return true end
		return false
	end

	if hasError(AHFDDB) then 
		AHFDDB = AHFD.filters
	end

	AHFD.Options:init()
end)

function AuctionHouseFilterDefaults_OnAddonCompartmentClick()
	Settings.OpenToCategory(AHFD.OptionsID)
end
