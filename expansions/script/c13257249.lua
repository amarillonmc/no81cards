--宇宙战争兵器 护罩-防护结界
local m=13257249
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableCounterPermit(TAMA_COSMIC_BATTLESHIP_COUNTER_CHARGE,LOCATION_SZONE)
	c:SetCounterLimit(TAMA_COSMIC_BATTLESHIP_COUNTER_CHARGE,3)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(tama.cosmicBattleship_equipLimit_shield)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(cm.econ)
	e12:SetValue(cm.efilter)
	c:RegisterEffect(e12)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter1)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(aux.chainreg)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(cm.acop)
	c:RegisterEffect(e6)
	eflist={{"equipment_rank",3}}
	cm[c]=eflist
end
function cm.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.efilter1(e,te)
	return e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec and e:GetHandler():GetFlagEffect(1)>0 and re:GetHandlerPlayer()~=tp then
		if e:GetHandler():GetCounter(TAMA_COSMIC_BATTLESHIP_COUNTER_SHIELD)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then ec:RemoveCounter(tp,TAMA_COSMIC_BATTLESHIP_COUNTER_SHIELD,1,REASON_EFFECT)
		else e:GetHandler():AddCounter(TAMA_COSMIC_BATTLESHIP_COUNTER_CHARGE,1)
		end
		if e:GetHandler():GetCounter(TAMA_COSMIC_BATTLESHIP_COUNTER_CHARGE)>=3 then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
