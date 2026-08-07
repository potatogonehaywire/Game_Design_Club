extends Node3D

var timeInEffect : float = 0
var animationTime : float = 0.4
var skillCooldown : int = 0.6
var healthChange : int = 15
var dmgDealt : int = 0
var debuff : int = 0
var dmgDebuff : int = 0
var weaponBuff : float = 0
var speedBuff : float = 0
var maxHealth : int = 100
var staminaDrain : int = -5
var type : String = "buff"
var colour : Color = Color("7d0500ff")
