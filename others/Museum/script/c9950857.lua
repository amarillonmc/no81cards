--电子暗黑结合
function c9950857.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950857+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9950857.target)
	e1:SetOperation(c9950857.activate)
	c:RegisterEffect(e1)
--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(aux.exccon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c9950857.thtg)
	e1:SetOperation(c9950857.thop)
	c:RegisterEffect(e1)
end
function c9950857.filter1(c,e)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function c9950857.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x93) and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf,true)
end
function c9950857.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp|0x200
		local mg=Duel.GetMatchingGroup(c9950857.filter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
		return Duel.IsExistingMatchingCard(c9950857.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
end
function c9950857.cffilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function c9950857.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp|0x200
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9950857.filter1),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	local sg=Duel.GetMatchingGroup(c9950857.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf,true)
		local cf=mat:Filter(c9950857.cffilter,nil)
		if cf:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cf)
		end
		Duel.SendtoDeck(mat,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c9950857.thfilter(c)
	return c:IsSetCard(0x93,0x94) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9950857.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950857.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950857.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950857.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
