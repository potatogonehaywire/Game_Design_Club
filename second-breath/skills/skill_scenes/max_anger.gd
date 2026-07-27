extends Node3D

var timeInEffect : float = 0
var animationTime : float = 0.5
var skillCooldown : int = 15
var healthChange : int = -15
var dmgDealt : int = 23
var debuff : int = 0
var dmgDebuff : int = 0
var weaponBuff : float = 1 #was 1.5
var speedBuff : float = 0
var maxHealth : int = 100
var staminaDrain : int = 10
var type : String = "melee"
var colour : Color = Color("a90075ff")
