# DM-Throw-Place-Item — Installation (OX & QB)

This package enables players to **throw** items (with physics) or **place** them in the world as custom **drops with props**.  
It supports **both** `ox_inventory` and `qb-inventory` (selectable in `config.lua`).

---

## Dependencies

- **Required:** `ox_lib`
- **Inventory (choose one):**
  - **OX Path:** `ox_inventory`
  - **QB Path:** `qb-inventory`
- **Your throw helper resource** (name used below: `Dm-throwitems`) that exports:
  - `exports('throwItem', ...)`
  - `exports('placeItem', ...)`

> If your helper resource is named differently, replace `Dm-throwitems` in the snippets accordingly.

---

## A) Script Configuration (this resource)

In `config.lua` of **this** resource:

```lua
Config.Inventory = 'ox'   -- or 'qb'

Config.DropSize = {
  slots = 25,
  maxweight = 30000,
}

-- QB fallback/overrides (if a QB item lacks a modelp/prop in Shared.Items)
Config.ItemProps = {
  water = 'prop_ld_flow_bottle',
  sandwich = 'prop_sandwich_01',
  kurkakola = 'prop_ecola_can',
  bread = 'v_res_fa_bread03',
  advancedlockpick = 'prop_tool_box_04',
}
```

- **OX** reads `modelp/prop` from `ox_inventory:Items()` directly.
- **QB** reads `modelp/prop` from `QBCore.Shared.Items[name]`. If missing, it falls back to `Config.ItemProps`.

---

## B) OX Integration

> The following steps integrate throw/place with **ox_inventory**.

### 1) Replace `RegisterNUICallback('giveItem')`

**File:** `ox_inventory/client/***` (where `giveItem` is defined)

```lua
RegisterNUICallback('giveItem', function(data, cb)
	cb(1)

    if usingItem then return end
      local item = lib.callback.await('inv:getItemFromSlot', false, data.slot)

    local props = Items[item.name]

    local slotId = item.slot

	
    if slotId == currentWeapon?.slot then
        currentWeapon = Weapon.Disarm(currentWeapon)
    end
	
	if props and props.modelp and not props.disableThrow then
		client.closeInventory()

			lib.showTextUI('[N] place\n[ESC] cancel', {
				position = 'bottom-center',  

			})

		local entity = exports["Dm-throwitems"]:throwItem(data.slot, props, data.count)
		
		while DoesEntityExist(entity) do
			DisableFrontendThisFrame()

			if IsControlJustReleased(2, 200) then
				DeleteEntity(entity)
				RemoveWeaponFromPed(playerPed, 'WEAPON_BALL')

				lib.hideTextUI()
			end

			if IsControlJustReleased(0, 306) then
				DeleteEntity(entity)
				RemoveWeaponFromPed(playerPed, 'WEAPON_BALL')
				lib.hideTextUI()

				exports["Dm-throwitems"]:placeItem(data.slot, props, data.count)
			end

			Wait(0)
		end
	end



	if client.giveplayerlist then
		local nearbyPlayers = lib.getNearbyPlayers(GetEntityCoords(playerPed), 3.0)
        local nearbyCount = #nearbyPlayers

		if nearbyCount == 0 then return end

        if nearbyCount == 1 then
			local option = nearbyPlayers[1]

            if not isGiveTargetValid(option.ped, option.coords) then return end

            return giveItemToTarget(GetPlayerServerId(option.id), data.slot, data.count)
        end

        local giveList, n = {}, 0

		for i = 1, #nearbyPlayers do
			local option = nearbyPlayers[i]

            if isGiveTargetValid(option.ped, option.coords) then
				local playerName = GetPlayerName(option.id)
				option.id = GetPlayerServerId(option.id)
                ---@diagnostic disable-next-line: inject-field
				option.label = ('[%s] %s'):format(option.id, playerName)
				n += 1
				giveList[n] = option
			end
		end

        if n == 0 then return end

		lib.registerMenu({
			id = 'ox_inventory:givePlayerList',
			title = 'Give item',
			options = giveList,
		}, function(selected)
            giveItemToTarget(giveList[selected].id, data.slot, data.count)
        end)

		return lib.showMenu('ox_inventory:givePlayerList')
	end

    if cache.vehicle then
		local seats = GetVehicleMaxNumberOfPassengers(cache.vehicle) - 1

		if seats >= 0 then
			local passenger = GetPedInVehicleSeat(cache.vehicle, cache.seat - 2 * (cache.seat % 2) + 1)

			if passenger ~= 0 and IsEntityVisible(passenger) then
                return giveItemToTarget(GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger)), data.slot, data.count)
			end
		end

        return
	end

    local entity = Utils.Raycast(1|2|4|8|16, GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 3.0, 0.5), 0.2)

    if entity and IsPedAPlayer(entity) and IsEntityVisible(entity) and #(GetEntityCoords(playerPed, true) - GetEntityCoords(entity, true)) < 3.0 then
        return giveItemToTarget(GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)), data.slot, data.count)
    end
end)
```

### 2) Replace `Weapon.Disarm`

**File:** `ox_inventory/modules/weapon/client.lua`

```lua
function Weapon.Disarm(currentWeapon, noAnim)
	if currentWeapon?.timer then
		currentWeapon.timer = nil

        TriggerServerEvent('ox_inventory:updateWeapon')
		SetPedAmmo(cache.ped, currentWeapon.hash, 0)

		if client.weaponanims and not noAnim then
			if cache.vehicle and vehicleIsCycle(cache.vehicle) then
				goto skipAnim
			end

			ClearPedSecondaryTask(cache.ped)

			local item = Items[currentWeapon.name]
			local coords = GetEntityCoords(cache.ped, true)
			local anim = item.anim or anims[GetWeapontypeGroup(currentWeapon.hash)]

			if anim == anims[`GROUP_PISTOL`] and not client.hasGroup(shared.police) then
				anim = nil
			end

			local sleep = anim and anim[6] or 1400

			Utils.PlayAnimAdvanced(sleep, anim and anim[4] or 'reaction@intimidation@1h', anim and anim[5] or 'outro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(cache.ped), 8.0, 3.0, sleep, 50, 0)

			RemoveWeaponFromPed(cache.ped, currentWeapon.hash)
		end

		::skipAnim::

		if client.weaponnotify then
			Utils.ItemNotify({ currentWeapon, 'ui_holstered' })
		end

		TriggerEvent('ox_inventory:currentWeapon')
	end

	Utils.WeaponWheel()

	if client.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(cache.ped, chute, 0, true, false)
		SetPedGadget(cache.ped, chute, true)
		SetPlayerParachuteTintIndex(PlayerData.id, client.parachute?[2] or -1)
	end
end
```

### 3) Add `modelp` to items

**File:** `ox_inventory/data/items.lua`

```lua
['money'] = {
    label = 'Money',
    weight = 3000,
    modelp = "prop_anim_cash_pile_02"
},
```

### 4) Throw distance & item weight

- Heavier items (higher **weight**) → shorter throw distance.
- Lighter items (lower **weight**) → longer throw distance.

---

## C) QB Integration

> The following edits integrate throw/place with **qb-inventory**.

### 1) Client target for custom drops

**File:** `qb-inventory/client/drops.lua`

```lua
RegisterNetEvent('qb-inventory:client:setupDropTarget', function(dropId, iscustom)
    while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
    local bag = NetworkGetEntityFromNetworkId(dropId)
    while not DoesEntityExist(bag) do Wait(10) end
    local newDropId = 'drop-' .. dropId

    exports['qb-target']:AddTargetEntity(bag, {
        options = {
            {
                icon = 'fas fa-backpack',
                label = Lang:t('menu.o_bag'),
                action = function()
                    TriggerServerEvent('qb-inventory:server:openDrop', newDropId)
                    CurrentDrop = newDropId
                end,
            },
            {
                icon = 'fas fa-hand-pointer',
                label = 'Pick up bag',
                action = function()
                    if IsPedArmed(PlayerPedId(), 4) then
                        return QBCore.Functions.Notify("You can not be holding a Gun and a Bag!", "error", 5500)
                    end
                    if HoldingDrop then
                        return QBCore.Functions.Notify("Your already holding a bag, Go Drop it!", "error", 5500)
                    end
                    AttachEntityToEntity(
                        bag,
                        PlayerPedId(),
                        GetPedBoneIndex(PlayerPedId(), Config.ItemDropObjectBone),
                        Config.ItemDropObjectOffset[1].x,
                        Config.ItemDropObjectOffset[1].y,
                        Config.ItemDropObjectOffset[1].z,
                        Config.ItemDropObjectOffset[2].x,
                        Config.ItemDropObjectOffset[2].y,
                        Config.ItemDropObjectOffset[2].z,
                        true, true, false, true, 1, true
                    )
                    bagObject = bag
                    HoldingDrop = true
                    heldDrop = newDropId
                    exports['qb-core']:DrawText('Press [G] to drop the bag')
                end,
                canInteract = function(_)
                    return not iscustom
                end,
            }
        },
        distance = 2.5,
    })
end)
```

### 2) Server exports for custom drops

**File:** `qb-inventory/server/main.lua` (append at bottom)

```lua
local function _toVec3(coords)
    if type(coords) == 'vector3' then return coords, nil end
    if type(coords) == 'vector4' then return vector3(coords.x, coords.y, coords.z), coords.w end
    if type(coords) == 'table' then
        return vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3]),
               (coords.w or coords.heading or coords[4] or 0.0)
    end
    error('CreateCustomDrop: invalid coords')
end

local function _resolveModel(model)
    if model == nil then return Config.ItemDropObject end
    if type(model) == 'number' then return model end
    if type(model) == 'string' then
        local h = GetHashKey(model)
        return model -- keep name/hash
    end
    return Config.ItemDropObject
end

function CreateCustomDrop(opts)
    assert(type(opts) == 'table', 'CreateCustomDrop: opts must be a table')

    local coords, heading = _toVec3(opts.coords)
    local model = _resolveModel(opts.model)
    local label = opts.label or 'Drop'
    local slots = tonumber(opts.slots or (Config.DropSize and Config.DropSize.slots) or 20)
    local maxweight = tonumber(opts.maxweight or (Config.DropSize and Config.DropSize.maxweight) or 20000)

    local obj = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, true, false)
    if heading then SetEntityHeading(obj, heading + 0.0) end
    FreezeEntityPosition(obj, true)

    local netId = NetworkGetNetworkIdFromEntity(obj)
    local dropId = 'drop-' .. netId

    local itemsTable = setmetatable({}, {
        __len = function(t) local n=0 for _ in pairs(t) do n=n+1 end return n end
    })

    local nextSlot = 1
    if type(opts.items) == 'table' then
        for _, it in ipairs(opts.items) do
            if it and it.name then
                local shared = QBCore.Shared.Items[(it.name):lower()]
                if shared then
                    local slot = tonumber(it.slot) or nextSlot
                    nextSlot = math.max(nextSlot, slot + 1)
                    itemsTable[#itemsTable + 1] = {
                        name  = shared.name,  label = shared.label, type  = shared.type,
                        image = shared.image, weight = shared.weight, unique = shared.unique,
                        usable = shared.usable, description = shared.description, shouldClose = shared.shouldClose,
                        amount = tonumber(it.amount) or 1, info = it.info or {}, slot = slot
                    }
                else
                    print(('[qb-inventory] CreateCustomDrop: unknown item \"%s\" skipped'):format(tostring(it.name)))
                end
            end
        end
    end

    Drops[dropId] = {
        name = dropId, label = label, items = itemsTable, entityId = netId,
        createdTime = os.time(), coords = coords, maxweight = maxweight,
        slots = slots, isOpen = false
    }

    local iscustom = true
    TriggerClientEvent('qb-inventory:client:setupDropTarget', -1, netId, iscustom)

    local openFor = tonumber(opts.openFor or 0)
    if openFor and openFor > 0 then
        local Player = QBCore.Functions.GetPlayer(openFor)
        if Player then
            local formatted = { name = dropId, label = label, maxweight = maxweight, slots = slots, inventory = itemsTable }
            Drops[dropId].isOpen = true
            TriggerClientEvent('qb-inventory:client:openInventory', openFor, Player.PlayerData.items, formatted)
        end
    end

    return dropId, netId
end
exports('CreateCustomDrop', CreateCustomDrop)

function RemoveDrop(dropId)
    local d = Drops[dropId]
    if not d then return false end
    TriggerClientEvent('qb-inventory:client:removeDropTarget', -1, d.entityId)
    Wait(300)
    local entity = NetworkGetEntityFromNetworkId(d.entityId)
    if DoesEntityExist(entity) then DeleteEntity(entity) end
    Drops[dropId] = nil
    return true
end
exports('RemoveDrop', RemoveDrop)
```

### 3) Add prop-aware `GiveItem` (client)

**File:** `qb-inventory/client/main.lua`

Add this helper **above** the callback:

```lua
local function getPropForItemQB(itemName)
    local shared = QBCore.Shared.Items[itemName]
    local prop = shared and (shared.modelp or shared.prop or shared.dropProp or shared.object or shared.model)
    if type(prop) == 'table' then
        prop = prop.modelp or prop.prop or prop.object or prop.model
    end
    if not prop and lib and lib.callback then
        prop = lib.callback.await('inv:getItemProp', false, itemName)
    end
    return prop
end
```

Replace the `RegisterNUICallback('GiveItem', ...)` with:

```lua
RegisterNUICallback('GiveItem', function(data, cb)
    cb(1)  

    local playerPed = PlayerPedId()

    if usingItem then return end

    local item = data and data.item
    if not item or not item.name then
        QBCore.Functions.Notify('Invalid item payload', 'error')
        return cb(false)
    end

    local prop = getPropForItemQB(item.name)

    if prop and not item.disableThrow then
        if client and client.closeInventory then
            client.closeInventory()
        else
            SetNuiFocus(false, false)
            SendNUIMessage({ action = 'close' })
        end

        if lib and lib.showTextUI then
            lib.showTextUI('[N] place\\n[ESC] cancel', { position = 'bottom-center' })
        end

        local entity = exports['Dm-throwitems']:throwItem(data.slot, { modelp = prop, prop = prop }, tonumber(data.amount))

        while DoesEntityExist(entity) do
            DisableFrontendThisFrame()

            if IsControlJustReleased(2, 200) then 
                DeleteEntity(entity)
                RemoveWeaponFromPed(playerPed, `WEAPON_BALL`)
                if lib and lib.hideTextUI then lib.hideTextUI() end
            end

            if IsControlJustReleased(0, 306) then 
                DeleteEntity(entity)
                RemoveWeaponFromPed(playerPed, `WEAPON_BALL`)
                if lib and lib.hideTextUI then lib.hideTextUI() end
                exports['Dm-throwitems']:placeItem(data.slot, { modelp = prop, prop = prop }, tonumber(data.amount))
            end

            Wait(0)
        end

        return
    end

    local player, distance = QBCore.Functions.GetClosestPlayer(GetEntityCoords(playerPed))
    if player ~= -1 and distance < 3.0 then
        local playerId = GetPlayerServerId(player)
        QBCore.Functions.TriggerCallback('qb-inventory:server:giveItem', function(success)
            cb(success)
        end, playerId, item.name, tonumber(data.amount) or 1, data.slot, data.info)
    else
        QBCore.Functions.Notify(Lang and Lang.t and Lang:t('notify.nonb') or 'No nearby player', 'error')
        cb(false)
    end
end)
```

### 4) (Recommended) Add `modelp` to QB items

**File:** `qb-core/shared/items.lua`

```lua
armor = {
  name = 'armor', label = 'Armor', modelp = "prop_bodyarmour_03",
  weight = 5000, type = 'item', image = 'armor.png',
  unique = false, useable = true, shouldClose = true,
  description = "Some protection won't hurt... right?"
}
```

**Alternative:** Instead of editing shared items, define props in **this resource’s** `Config.ItemProps` (see section A).

---

## Controls

- **Throw:** (handled by your throw resource, typically LMB)
- **Place:** **N**
- **Cancel:** **ESC**

> You can remap these inside your throw/placement resource.

---

## Notes

- If a QB item doesn’t spawn a prop: ensure it has `modelp/prop` in `QBCore.Shared.Items` or add a mapping in `Config.ItemProps`.
- OX path requires the `modelp` field in `ox_inventory/data/items.lua` for items you want to throw/place.
- Custom drops created server-side via QB export: `exports['qb-inventory']:CreateCustomDrop(opts)` / `RemoveDrop(dropId)`.

