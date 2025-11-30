--陵墓噬尸虫
function c9911628.initial_effect(c)
	aux.AddCodeList(c,9911614)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911628)
	e1:SetCost(c9911628.spcost)
	e1:SetTarget(c9911628.sptg)
	e1:SetOperation(c9911628.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911629)
	e2:SetCost(c9911628.thcost)
	e2:SetTarget(c9911628.thtg)
	e2:SetOperation(c9911628.thop)
	c:RegisterEffect(e2)
end
function c9911628.cfilter1(c,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
	if #g==0 then return false end
	local tg1=g:GetMaxGroup(Card.GetLevel)
	local tg2=g:GetMinGroup(Card.GetLevel)
	return not c:IsPublic() and tg1:IsContains(c) and tg2:IsExists(c9911628.cfilter2,1,c)
end
function c9911628.cfilter2(c)
	return not c:IsPublic()
end
function c9911628.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911628.cfilter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
	local tg1=g:GetMaxGroup(Card.GetLevel)
	local tg2=g:GetMinGroup(Card.GetLevel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=tg1:FilterSelect(tp,c9911628.cfilter2,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=tg2:FilterSelect(tp,c9911628.cfilter2,1,1,sg1)
	sg1:Merge(sg2)
	sg1:KeepAlive()
	e:SetLabelObject(sg1)
	Duel.ConfirmCards(1-tp,sg1)
end
function c9911628.spfilter(c,e,tp)
	return c:IsSetCard(0x54) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911628.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911628.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	local g=e:GetLabelObject()
	if #g~=2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	g:DeleteGroup()
	if tc1:IsOriginalCodeRule(tc2:GetOriginalCodeRule()) then return end
	local lv1=tc1:GetLevel()
	local lv2=tc2:GetLevel()
	if lv1==lv2 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,tc1:GetOriginalCodeRule()))
	e1:SetValue(lv2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetTargetRange(0xff,0xff)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,tc2:GetOriginalCodeRule()))
	e2:SetValue(lv1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9911628.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9911628.thfilter(c)
	return c:IsCode(9911601,9911614) and c:IsAbleToHand()
end
function c9911628.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911628.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911628.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911628.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,g)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and not c:IsType(TYPE_TUNER) and Duel.SelectYesNo(tp,aux.Stringid(9911628,0)) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
