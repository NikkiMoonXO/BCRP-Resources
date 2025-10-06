return {
  canUseItem = function(item)
    local itemInfo = lib.FW.Functions.CanUseItem(item)
    if type(itemInfo) ~= 'table' then
      return false
    end

    if not itemInfo.func then 
      return false
    end

    return itemInfo.func 
  end,

  useableItem = function(item, cb)
    return lib.FW.Functions.CreateUseableItem(item,cb)
  end,

  get = function(src)
    return lib.FW.Functions.GetPlayer(src)
  end,

  identifier = function(src)
    local ply = lib.player.get(src)
    assert(ply, 'Player does not exist')
    return ply.PlayerData.citizenid
  end, 

  name = function(src)
    local ply = lib.player.get(src)
    assert(ply, 'Player does not exist')
    return ply.PlayerData.charinfo.firstname, ply.PlayerData.charinfo.lastname
  end,

  phoneNumber = function(src)
    local ply = lib.player.get(src)
    assert(ply, 'Player does not exist')
    return ply.PlayerData.charinfo.phone
  end, 

  gender = function(src)
    local ply = lib.player.get(src)
    assert(ply, 'Player does not exist')
    return ply.PlayerData.charinfo.gender or 'unknown'
  end, 

  deleteCharacter = function(src, citizenId)
    return lib.FW.Player.DeleteCharacter(src, citizenId)
  end,

  loginCharacter = function(src, citizenId, slot)
    return lib.FW.Player.Login(src, citizenId)
  end,

  createCharacter = function(src, newData)
    return lib.FW.Player.Login(src, nil, {
      cid = newData.slot, 
      charinfo = {
        firstname = newData.firstName, 
        lastname  = newData.lastName,
        birthdate = newData.dob,
        gender    = newData.gender == 'female' and 1 or 0, 
        nationality = newData.nationallity,
      }
    })
  end,

  logoutCharacter = function(src, citizenId)
    return lib.FW.Player.Logout(src, citizenId)
  end,

  getCharacters = function(src)
    local license = lib.player.getIdentifierType(src, lib.settings.primaryIdentifier or 'license')
    local toRet = {}
    local result = exports.oxmysql:query_async('SELECT * FROM players WHERE license = ?', {license})
    for k,v in pairs(result) do
      local charInfo = json.decode(v.charinfo)
      local lastPos = json.decode(v.position)
      table.insert(toRet, {
        slot       = tonumber(v.cid),
        firstName  = charInfo.firstname,
        lastName   = charInfo.lastname,
        dob        = charInfo.birthdate,
        lastpos    = vector4(lastPos.x or 0.0, lastPos.y or 0.0, lastPos.z or 0.0, lastPos.w or 0.0), 
        citizenId  = v.citizenid, 
        gender     = tonumber(charInfo.gender) == 1 and 'female' or 'male',
        accounts   = json.decode(v.money) or {},
        metadata   = json.decode(v.metadata) or {},
        disabled   = v.disabled,
      })
    end
    return toRet
  end,

  getJob = function(src)
    local ply = lib.player.get(src)
    if not ply then return end
    local rawJob = ply.PlayerData.job
    local ret = {
      name       = rawJob.name,
      type       = rawJob.type,
      label      = rawJob.label,
      grade      = rawJob.grade.level,
      isBoss     = rawJob.grade.isboss,
      bankAuth   = rawJob.bankAuth,
      gradeLabel = rawJob.grade.name,
      duty       = rawJob.onduty
    }
    return ret
  end,

  getGang = function(src)
    local ply = lib.player.get(src)
    if not ply then return end
    local rawGang = ply.PlayerData.gang
    local ret = {
      name       = rawGang.name,
      type       = rawGang.type,
      label      = rawGang.label,
      grade      = rawGang.grade.level,
      isBoss     = rawGang.isboss,
      bankAuth   = rawGang.bankAuth,
      gradeLabel = rawGang.grade.name,
      duty = rawGang.onduty
    }
    return ret
  end,


  setJob = function(src, name, rank)
    local ply = lib.player.get(src)
    if not ply then return end
    ply.Functions.SetJob(name, rank)
  end,
  
  setDuty = function(src, duty)
    local ply = lib.player.get(src)
    if not ply then return end
    ply.Functions.SetJobDuty(duty)
  end,

  setPlayerData = function(src, _key, data)
    local ply = lib.player.get(src)
    if not ply then return end
    ply.Functions.SetPlayerData(_key, data)
  end,

  getPlayerData = function(src, _key)
    local ply = lib.player.get(src)
    if not ply then return end
    if _key then
      return ply.PlayerData[_key]
    end
    return ply.PlayerData
  end,

  setMetadata = function(src, _key, data)
    local ply = lib.player.get(src)
    if not ply then return end
    ply.Functions.SetMetaData(_key, data)
  end,

  getMetadata = function(src, _key)
    local ply = lib.player.get(src)
    if not ply then return end
    return ply.Functions.GetMetaData(_key)
  end,

  jail = function()

  end, 

  getMoney = function(src, acc)
    local ply = lib.player.get(src)
    if not ply then return end
    return ply.Functions.GetMoney(acc)
  end,

  addMoney = function(src, acc, count, reason)
    local ply = lib.player.get(src)
    if not ply then return end
    return ply.Functions.AddMoney(acc, count, reason)
  end, 

  removeMoney = function(src, acc, count, reason, force)
    local ply = lib.player.get(src)
    if not ply then return end
    if not force then
      local has = ply.Functions.GetMoney(acc)
      if has < count then return false, 'not_enough' end
    end
    return ply.Functions.RemoveMoney(acc, count, reason)
  end,

  setMoney = function(src, acc, count)
    local ply = lib.player.get(src)
    if not ply then return end
    return ply.Functions.SetMoney(acc, count)
  end, 

  hasLicense = function(src, license)
    if not license then return true; end 
    local licenses = lib.player.getMetadata(src, 'licenses')
    if not licenses then return false; end 
    if type(license) == 'string' then 
      return licenses[license]
    elseif type(license) == 'table' then 
      for k,v in pairs(license) do 
        if license[v] then 
          return true 
        end  
      end 
    end
    return false 
  end,

  getLicenses = function(src)
    return lib.player.getMetadata(src, 'licenses')
  end, 

  hasGroup = function(src, group)
    return lib.hasGroup(lib.player.getJob(src), lib.player.getGang(src), group)
  end,
}


