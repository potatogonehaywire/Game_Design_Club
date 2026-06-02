extends Node3D

var timeInEffect : float = 0
var animationTime : float = 0.5
var skillCooldown : int = 10
var healthChange : int = 0
var dmgDealt : int = 10
var debuff : int = 0
var dmgDebuff : int = 0
var weaponBuff : float = 1
var speedBuff : float = 0
var maxHealth : int = 100
var staminaDrain : int = 15
var type : String = "ranged"
var colour : Color = Color("5785ffff")
