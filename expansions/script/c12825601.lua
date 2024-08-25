--铳影-殷妮
local s,id,o=GetID()
function c12825601.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1109)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c12825601.thcost)
	e1:SetTarget(c12825601.thtg)
	e1:SetOperation(c12825601.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,12825601)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c12825601.spcost)
	e2:SetTarget(c12825601.sptg)
	e2:SetOperation(c12825601.spop)
	c:RegisterEffect(e2)
end
function c12825601.cfilter(c,tp)
	return c:IsSetCard(0x4a76) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c12825601.thfilter,tp,LOCATION_DECK,0,1,nil,c) 
end
function c12825601.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12825601)==0
		and Duel.IsExistingMatchingCard(c12825601.cfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.RegisterFlagEffect(tp,12825601,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c12825601.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c12825601.thfilter(c,mc)
	return c:IsType(TYPE_QUICKPLAY) and aux.IsCodeListed(c,mc:GetCode()) and c:IsAbleToHand()
end
function c12825601.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12825601.thop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12825601.thfilter,tp,LOCATION_DECK,0,1,1,nil,rc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12825601.rcfilter(c,e,tp)
	return c:IsSetCard(0x4a76) and c:IsType(TYPE_QUICKPLAY) and not c:IsCode(12825610,12825611)
		and Duel.IsExistingMatchingCard(c12825601.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) 
end
function c12825601.spfilter(c,e,tp,mc)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(mc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12825601.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() 
		and Duel.IsExistingMatchingCard(c12825601.rcfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c12825601.rcfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	g:AddCard(e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c12825601.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c12825601.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local rc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12825601.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rc)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
