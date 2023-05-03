--[[

  BasicExample

  This example showcases the basics of Toned

]]

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local Toned = require(ReplicatedStorage.Toned)

local New, Children = Fusion.New, Fusion.Children
local StyleSheet, Trait = Toned.StyleSheet, Toned.Trait

local player = Players.LocalPlayer

New 'ScreenGui' {
  Parent = player.PlayerGui,

  [StyleSheet] = require(script.Parent.StyleSheet),

  [Children] = {
    New 'Frame' {
      Name = 'MyFrame',
    },

    New 'TextLabel' {
      Text = 'Hello World!',

      [Trait] = {'Red Background', 'White Text'},
    },

    New 'Frame' {
      Size = UDim2.new(0.1, 0, 0.1, 0),
      Position = UDim2.new(0.8, 0, 0.8, 0),

      [Trait] = 'Red Background',
    }
  }
}