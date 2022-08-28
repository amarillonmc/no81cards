--last upd 20220104
Seine_yijing={}
local m=90700070
local yj=_G["Seine_yijing"]
function yj.enable(c,op)
	aux.AddCodeList(c,m)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(yj.topcon)
	e1:SetOperation(yj.topop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(yj.bancon)
	e2:SetOperation(yj.banop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(op)
	e3:SetCountLimit(1,c:GetCode()+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e3)
end
function yj.topcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function yj.topop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function yj.bancon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,e:GetHandler())==0
end
function yj.banop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end