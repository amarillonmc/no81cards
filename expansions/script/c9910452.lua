--永恒辉映的韶光
function c9910452.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910452,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910452+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910452.target)
	e1:SetOperation(c9910452.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910452,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9910452+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c9910452.cost)
	e2:SetTarget(c9910452.target2)
	e2:SetOperation(c9910452.activate2)
	c:RegisterEffect(e2)
end
function c9910452.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<10 then return false end
		local g=Duel.GetDecktopGroup(tp,10)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c9910452.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<10 then return end
	Duel.ConfirmDecktop(tp,10)
	local g=Duel.GetDecktopGroup(tp,10)
	if g:GetCount()>0 and g:GetClassCount(Card.GetCode)==g:GetCount() and g:IsExists(Card.IsAbleToHand,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
	Duel.ShuffleDeck(tp)
end
function c9910452.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,60,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function c9910452.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<10 then return false end
		local g=Duel.GetDecktopGroup(tp,10)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetChainLimit(c9910452.chlimit)
end
function c9910452.chlimit(e,ep,tp)
	return tp==ep
end
function c9910452.spfilter(c,e,tp)
	return c:IsSetCard(0x9950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910452.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<10 then return end
	Duel.ConfirmDecktop(tp,10)
	local g=Duel.GetDecktopGroup(tp,10)
	if g:GetCount()>0 and g:GetClassCount(Card.GetCode)==g:GetCount() and g:IsExists(Card.IsAbleToHand,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleHand(tp)
		g:Sub(sg1)
		g:Merge(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0))
		local ct=e:GetLabel()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>=ct and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
			and g:IsExists(aux.NecroValleyFilter(c9910452.spfilter),ct,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(9910452,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g:FilterSelect(tp,aux.NecroValleyFilter(c9910452.spfilter),ct,ct,nil,e,tp)
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	Duel.ShuffleDeck(tp)
end
