--恍殇华·永劫锥心复归
local m=33711410
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabelObject(e1)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
   if cm.check==nil then
		cm.check=true
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1_1:SetCode(EVENT_TO_GRAVE)
		e1_1:SetOperation(cm.op1_1)
		Duel.RegisterEffect(e1_1,0)
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1_2:SetCode(EVENT_REMOVE)
		e1_2:SetOperation(cm.op1_1)
		Duel.RegisterEffect(e1_2,0)
	end
end
--
function cm.op1_1(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsReason(REASON_DESTROY) then
			local sp=tc:GetReasonPlayer()
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,Duel.GetTurnCount())
		end
	end
end
function cm.spfilter1(c,e,tp)
	if not c:IsFaceup() then return false end
	if Duel.GetTurnPlayer()==tp then
		return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==Duel.GetTurnCount()-1
	else
		return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==Duel.GetTurnCount()-2
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetCode())
end
function cm.spfilter(c,e,tp)
	return c:IsCode(e:GetLabelObject():GetLabel()) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_DEFENSE) and c:IsFaceup()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local tc=Duel.GetFirstTarget()
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 and Duel.GetTurnPlayer()~=tp then
			Duel.SetLP(tp,Duel.GetLP(tp)/2)
		end
	end
end