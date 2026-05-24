extends Node3D

var timeInEffect : float = 0
var animationTime : float = 0.5
var skillCooldown : int = 15
var healthChange : int = 0
var debuff : int = -2
var dmgDebuff : int = 0
var weaponBuff : float = 0
var speedBuff : float = 0
var maxHealth : int = 100
var staminaDrain : int = 10
var type : String = "ranged"
var colour : Color = Color("039b8eff")
