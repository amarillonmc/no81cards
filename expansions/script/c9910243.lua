--高塔的魔导城 都灵
function c9910243.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,9910243)
	e2:SetTarget(c9910243.rectg)
	e2:SetOperation(c9910243.recop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910243.descon)
	e3:SetTarget(c9910243.destg)
	e3:SetOperation(c9910243.desop)
	c:RegisterEffect(e3)
end
function c9910243.confilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c9910243.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910243.confilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.drccheck,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c9910243.thfilter(c)
	return (c:IsCode(9910871) or aux.IsCodeListed(c,9910871) and c:IsType(TYPE_TUNER)) and c:IsAbleToHand()
end
function c9910243.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910243.confilter,tp,LOCATION_HAND,0,nil)
	if not g:CheckSubGroup(aux.drccheck,2,2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,2,#g)
	if #sg==0 then return end
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	if Duel.Recover(tp,#sg*500,REASON_EFFECT)==0 then return end
	if sg:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9910243,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ssg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP)
		sg:Sub(ssg)
	end
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c9910243.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and sg:IsExists(Card.IsAbleToGrave,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910243,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tsg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910243.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(tsg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tsg)
		end
	end
end
function c9910243.cfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c9910243.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910243.cfilter,1,nil)
end
function c9910243.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910243.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
