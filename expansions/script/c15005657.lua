if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
if not pcall(function() require("expansions/script/c15000000") end) then require("script/c15000000") end
local m=15005657
local cm=_G["c"..m]
cm.name="枯绿隐匿者-狂风"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon
	Satl.AddWitheredLinkProcedure(c,nil,2,4,cm.lcheck)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.actcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.atkcon)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xf42)
end
function cm.indcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function cm.actcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetMutualLinkedGroupCount()>0 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.atkcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local a,b=Duel.GetBattleMonster(tp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and a and a==c and b and b:IsSummonLocation(LOCATION_EXTRA)
end
function cm.atkval(e,sc)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local a,b=Duel.GetBattleMonster(tp)
	if a and a==c and b and b:IsSummonLocation(LOCATION_EXTRA) then
		return math.floor(b:GetAttack()/2)
	else return 0 end
end