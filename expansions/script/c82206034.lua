local m=82206034
local cm=_G["c"..m]
cm.name="植占师14-忧郁"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),7,2)  
	c:EnableReviveLimit()
	--cannot special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetValue(aux.xyzlimit)  
	c:RegisterEffect(e1)
	--target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(0,LOCATION_MZONE)  
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)  
	e2:SetValue(cm.atlimit)  
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTargetRange(LOCATION_MZONE,0) 
	e3:SetTarget(cm.tglimit)  
	e3:SetValue(aux.tgoval)  
	c:RegisterEffect(e3)
	--destroy replace  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_DESTROY_REPLACE)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTarget(cm.reptg)  
	e4:SetValue(cm.repval)  
	c:RegisterEffect(e4)
	--destroy  
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,0))	
	e5:SetType(EFFECT_TYPE_QUICK_O) 
	e5:SetCode(EVENT_FREE_CHAIN)  
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e5:SetCost(cm.ovcost)
	e5:SetTarget(cm.ovtg)  
	e5:SetOperation(cm.ovop)  
	c:RegisterEffect(e5) 
end
function cm.atlimit(e,c)  
	return c~=e:GetHandler()  
end  
function cm.tglimit(e,c)  
	return c~=e:GetHandler()  
end
function cm.repfilter(c,tp)  
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x129d) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)  
end  
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)  
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end  
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then  
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)  
		return true  
	end  
	return false  
end  
function cm.repval(e,c)  
	return cm.repfilter(c,e:GetHandlerPlayer())  
end
function cm.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end
function cm.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())  
end  
function cm.ovop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.HintSelection(sg)  
		Duel.Overlay(e:GetHandler(),sg)  
	end  
end