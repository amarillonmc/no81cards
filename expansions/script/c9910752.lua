--开拓的远古造物
dofile("expansions/script/c9910700.lua")
function c9910752.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_REMOVED,0)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0xc950)
	c:RegisterEffect(e2)
	local e2g=e2:Clone()
	e2g:SetTargetRange(LOCATION_GRAVE,0)
	e2g:SetCondition(c9910752.gravecon)
	c:RegisterEffect(e2g)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9910752.thcost)
	e3:SetTarget(c9910752.thtg)
	e3:SetOperation(c9910752.thop)
	c:RegisterEffect(e3)
end
function c9910752.gravecon(e)
	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),EFFECT_NECRO_VALLEY)
end
function c9910752.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910752.thfilter(c,e,tp)
	if not (c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER)) then return false end
	return c:IsAbleToHand() or QutryYgzw.SetFilter2(c,e,tp)
end
function c9910752.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910752.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910752.spfilter(c,e,tp,lv)
	return c:IsSetCard(0xc950) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9910752.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9910752.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local res=false
	if tc then
		if tc:IsAbleToHand() and (not QutryYgzw.SetFilter2(tc,e,tp) or Duel.SelectOption(tp,1190,aux.Stringid(9910752,0))==0) then
			res=Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND)
			Duel.ConfirmCards(1-tp,tc)
		else
			res=QutryYgzw.Set(tc,e,tp)
		end
	end
	Duel.AdjustAll()
	local lv=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*4
	local g=Duel.GetMatchingGroup(c9910752.spfilter,tp,LOCATION_HAND,0,nil,e,tp,lv)
	if res and #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9910752,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
