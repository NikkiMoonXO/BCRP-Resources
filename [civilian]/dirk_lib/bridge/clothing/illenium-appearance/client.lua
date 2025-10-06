return {
  setSkin = function(ped, skin)
    local playerPed = ped or cache.ped
    if not skin then return end
    exports[lib.settings.clothing]:setPedAppearance(playerPed, skin)
  end,

  openCustomisation = function(categories)
    print("illenium-appearance does not support categories")
    local promise = promise.new()
    print("Starting customization")
    exports[lib.settings.clothing]:startPlayerCustomization(function()
      promise:resolve('ok')
    end)
    return Citizen.Await(promise)
  end,

}
