--呼龙秘仪
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m+1)
	aux.AddRitualProcEqual2(c,aux.FilterBoolFunction(Card.IsRace,8192),18,aux.FilterBoolFunction(Card.IsRace,2),aux.FilterBoolFunction(Card.IsRace,2))
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EFFECT_DESTROY_REPLACE)
	e:SetRange(LOCATION_GRAVE)
	e:SetTarget(cm.tg)
	e:SetValue(cm.val)
	e:SetOperation(cm.op)
	c:RegisterEffect(e)
end
function cm.tgf(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsCode(m+1)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.tgf,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.val(e,c)
	return cm.tgf(c,e:GetHandlerPlayer())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end