--陆行珍珠
local m=43990079
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCondition(c43990079.con)
	e1:SetCost(c43990079.rspcost)
	e1:SetTarget(c43990079.rsptg)
	e1:SetOperation(c43990079.rspop)
	c:RegisterEffect(e1)
	--release replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990079,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetCountLimit(1,43990079)
	e3:SetTarget(c43990079.reptg)
	e3:SetValue(function(e,c) return c:GetFlagEffect(43990079)>0 end)
	c:RegisterEffect(e3)
	
end
function c43990079.confilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function c43990079.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990079.confilter,1,e:GetHandler(),tp)
end
function c43990079.rscfilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToGraveAsCost()
end
function c43990079.rspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c43990079.rscfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990079.rscfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c43990079.rsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c43990079.rspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 and e:GetActivateLocation()==LOCATION_HAND and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(43990079,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990079.filter2(c,re,tp,r)
	return bit.band(r,REASON_COST)~=0 and c:GetDestination()==LOCATION_GRAVE and c:IsType(TYPE_MONSTER) and re and aux.GetValueType(re)=="Effect" and re:IsActivated() and re:GetHandlerPlayer()==tp
end
function c43990079.rrfilter(c)
	return c:IsSetCard(0x5510) and c:IsAbleToDeckAsCost()
end
function c43990079.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return re and re:GetHandler():IsRace(RACE_ILLUSION) and eg:IsExists(c43990079.filter2,1,nil,re,tp,r) end
	if Duel.IsExistingMatchingCard(c43990079.rrfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990079,1)) then
		local g=eg:Filter(c43990079.filter2,nil,re,tp,r)
		g:ForEach(Card.RegisterFlagEffect,43990079,RESET_CHAIN,0,1)
		local g2=Duel.SelectMatchingCard(tp,c43990079.rrfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
		Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_COST)
		return true
	else return false end
end
