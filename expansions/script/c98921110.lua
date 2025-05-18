--星义熵渊龙
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e12=e1:Clone()
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetCondition(s.spcon2)
	c:RegisterEffect(e12)	
	-- 效果2：属性宣言和检索
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100)
	e2:SetOperation(s.attrop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0
end
function c98921110.sfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function s.cfilter(c)
	return c:IsAbleToDeck() and not Duel.IsExistingMatchingCard(c98921110.sfilter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and s.cfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.attrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-c:GetAttribute())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(att)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(att)
	e2:SetOperation(s.thop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.thfilter(c,att)
	return c:IsSetCard(0x13d) and c:IsAttribute(att) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,att)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end