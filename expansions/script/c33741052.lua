--近心芽姬·净流 尼克斯
local s,id,o=GetID()
Duel.LoadScript("GearGal.lua")
function s.initial_effect(c)
	GearGal.AddNearGalEffects(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp) return Duel.GetTurnPlayer()~=tp and Duel.IsMainPhase() end
function s.costfilter(c) return c:IsSetCard(0x1449) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToGraveAsCost() end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_SZONE,0,1,1,nil) Duel.SendtoGrave(g,REASON_COST)
end
function s.filter(c) return c:IsFaceup() and not c:IsForbidden() end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp)
	local tc=Duel.GetFirstTarget() if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then local e1=Effect.CreateEffect(e:GetHandler()) e1:SetType(EFFECT_TYPE_SINGLE) e1:SetCode(EFFECT_CHANGE_TYPE) e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS) e1:SetReset(RESET_EVENT+0x1fc0000) tc:RegisterEffect(e1) end
end
