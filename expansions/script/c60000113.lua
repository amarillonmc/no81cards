--NGNL 机凯种 休瓦尔扎
local m=60000113
local cm=_G["c"..m]
cm.name="NGNL 机凯种 休瓦尔扎"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.mfilter,1)
	c:EnableReviveLimit()
	--avoid destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end
cm.named_with_ExMachina=true 
function cm.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkRace(RACE_MACHINE)
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c.named_with_ExMachina and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end