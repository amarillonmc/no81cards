local m=53799066
local cm=_G["c"..m]
cm.name="发掘者 ZRKL"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCondition(cm.hspcon)
	e1:SetOperation(cm.hspop)
	c:RegisterEffect(e1)
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g1:GetFirst(),POS_FACEDOWN_DEFENSE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.ChangePosition(g2:GetFirst(),POS_FACEDOWN)
	Duel.RaiseEvent(g2:GetFirst(),EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
