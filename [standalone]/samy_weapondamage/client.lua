local cfg = Config.WeaponDamage
CreateThread(function()
    for weaponHash, damageMultiplier in pairs(cfg) do
        SetWeaponDamageModifier(weaponHash, damageMultiplier)
    end
end)