--太虚真诀
local m=77002512
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	aux.AddRitualProcEqual2(c,cm.rt,LOCATION_HAND,nil,cm.mt)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.rt(c)
	return c:IsType(TYPE_RITUAL)
end
function cm.mt(c)
	return c:IsSetCard(0x3eef)
end
--Effect 2
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3eef) and c:IsLocation(LOCATION_MZONE)
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
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
  
