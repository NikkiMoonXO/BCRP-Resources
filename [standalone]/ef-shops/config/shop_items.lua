---@class ShopItem
---@field id? number internal id number, do not set
---@field name? string item name as referenced in ox_inventory
---@field price number base price of the item
---@field defaultStock? integer the amount of items available in the shop by default
---@field category? string the category of the item in the shop (e.g. 'Snacks', 'Tools', 'Firearms', 'Ammunition', 'Drinks')
---@field license? string the license required to purchase the item
---@field jobs? table<string, number> map of group names to min grade required to access the shop
---@field metadata? table | string metadata for item

---@type table<string, table<string | number, ShopItem>>
local ITEMS = {
	normal = {
		sprunk = { price = 150, defaultStock = 50, category = 'Drinks' },
		water = { price = 100, defaultStock = 50, category = 'Drinks' },
		burger = { price = 300, defaultStock = 50, category = 'Snacks' },
	},
	bar = {
		-- water_bottle = { price = 1, defaultStock = 50 },
		-- ambeer = { price = 6, defaultStock = 50 },
		-- dusche = { price = 6, defaultStock = 50 },
		-- pisswasser = { price = 7, defaultStock = 50 },
		-- pisswasser2 = { price = 7, defaultStock = 50 },
		-- pisswasser3 = { price = 7, defaultStock = 50 },
		-- logger = { price = 6, defaultStock = 50 },
		-- whiskey = { price = 20, defaultStock = 50 },
		-- vodka = { price = 12, defaultStock = 50 }
	},
	hardware = {
		{ name = 'lockpick', price = 500, defaultStock = 50, category = 'Tools' },
	},
	weapons = {
		{ name = 'WEAPON_KNIFE',      price = 500,   defaultStock = 50,        category = 'Point Defense' },
		{ name = 'WEAPON_BAT',        price = 800,   defaultStock = 50,        category = 'Point Defense' },
		{ name = 'WEAPON_PISTOL',     price = 2500,  defaultStock = 20,          license = "weapon",        category = 'Firearms' },
		{ name = 'ammo-9',            price = 5,     defaultStock = 9500,       license = "weapon",        category = 'Ammunition' },
	},
	electronics = {
		{ name = 'phone', price = 250 },
		{ name = 'radio', price = 850 },
	},
}

local newFormatItems = {}
for category, categoryItems in pairs(ITEMS) do
	local newCategoryItems = {}

	for item, data in pairs(categoryItems) do
		if not data.name then
			data.name = tostring(item)
		end

		newCategoryItems[#newCategoryItems + 1] = data
	end

	table.sort(newCategoryItems, function(a, b)
		return a.name < b.name
	end)

	newFormatItems[category] = newCategoryItems
end

return newFormatItems
