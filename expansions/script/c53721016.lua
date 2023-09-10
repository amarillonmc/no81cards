local m=53721016
local cm=_G["c"..m]
cm.name="悚牢巨擘"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter,nil,nil,aux.NonTuner(nil),1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+50)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.matfilter(c,syncard)
	return c:IsTuner(syncard) or c:IsRace(RACE_FISH)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
	local g=Duel.GetOperatedGroup()
	e:SetLabelObject(g:GetFirst())
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_SEASERPENT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	if e:GetLabelObject():IsRace(RACE_FISH) then Duel.SetChainLimit(cm.chainlm) end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetLabelObject():IsAttribute(ATTRIBUTE_WATER) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetLabelObject():IsRace(RACE_FISH) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetLabelObject(tc)
		e1:SetOperation(cm.chainop)
		Duel.RegisterEffect(e1,tp)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_LEAVE_FIELD_P)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e0:SetLabelObject(e1)
		e0:SetOperation(cm.chk)
		tc:RegisterEffect(e0)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetLabelObject() then Duel.SetChainLimit(cm.chainlm) end
end
function cm.chk(e,tp,eg,ep,ev,re,r,rp)
	local c,le=e:GetHandler(),e:GetLabelObject()
	local te=c:GetReasonEffect()
	if c:GetFlagEffect(m)==0 or not te or not te:IsActivated() or te:GetHandler()~=c then le:Reset() else
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(le)
		e0:SetOperation(cm.resetop)
		Duel.RegisterEffect(e0,tp)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
