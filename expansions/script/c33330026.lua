--深界的诅咒
local m=33330026
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,cm.ritual_filter,LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	--Destroy Replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end
--Activate
function cm.ritual_filter(c)
	return c:IsSetCard(0x556) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
--Destroy Replace
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x556) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
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