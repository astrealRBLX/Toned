--[[

  PlayerList

  This example creates a basic player list
  using Toned to showcase its full power

]]

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local StarterGui = game:GetService('StarterGui')

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local Toned = require(ReplicatedStorage.Toned)

local New, Children, Value, Cleanup, ForValues = Fusion.New, Fusion.Children, Fusion.Value, Fusion.Cleanup, Fusion.ForValues
local StyleSheet, Trait = Toned.StyleSheet, Toned.Trait

local player = Players.LocalPlayer

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

local players = Value({})

local function resolvePlayers()
  players:set(Players:GetPlayers())
end

local connections = {
  Players.PlayerAdded:Connect(resolvePlayers),
  Players.PlayerRemoving:Connect(resolvePlayers),
}

resolvePlayers()

local playerListGui
playerListGui = New 'ScreenGui' {
  Parent = player.PlayerGui,

  IgnoreGuiInset = true,

  [StyleSheet] = require(script.Parent.StyleSheet),

  [Cleanup] = connections,
  [Children] = New 'Frame' {
    Name = 'PlayerContainer',

    [Children] = {
      -- PlayerList title label
      New 'TextLabel' {
        Name = '$ListTitle',

        [Trait] = 'PlayerListTitle',
        [Children] = New 'TextButton' {
          Text = '<b>X</b>',

          [Fusion.OnEvent 'Activated'] = function()
            playerListGui:Destroy()
          end,

          [Children] = New 'UICorner' {
            [Trait] = 'LargeRadius',
          },
        }
      },

      -- Generate individual player labels
      ForValues(players, function(plr: Player)
        return New 'TextLabel' {
          Text = '• ' .. plr.Name,

          [Trait] = 'PlayerLabel',
          [Children] = {
            New 'UICorner' {},
            New 'UIPadding' {
              [Trait] = 'SmallPadding',
            },
          }
        }
      end, Fusion.cleanup),

      New 'UICorner' {},
      New 'UIListLayout' {},
      New 'UIPadding' {},
    }
  }
}