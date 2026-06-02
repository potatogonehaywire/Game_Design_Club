extends Node3D

var timeInEffect : float = 15
var animationTime : float = 0.5
var skillCooldown : int = 25
var healthChange : int = 0
var dmgDealt : int = 0
var debuff : int = 0 #previous 5
var dmgDebuff : int = 5
var weaponBuff : float = 2
var speedBuff : float = 0
var maxHealth : int = 120
var staminaDrain : int = 15
var type : String = "buff"
var colour : Color = Color("afb960ff")
