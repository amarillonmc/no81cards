--星幽洞视
function c9910291.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910291+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910291.cost)
	e1:SetTarget(c9910291.target)
	e1:SetOperation(c9910291.activate)
	c:RegisterEffect(e1)
end
function c9910291.rfilter(c,e,tp)
	return c:IsSetCard(0x957) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9910291.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c9910291.spfilter(c,e,tp,code)
	return c:IsSetCard(0x957) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910291.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910291.rfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910291.rfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c9910291.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,6)
	local b1=Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
	local b2=g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)>2
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9910291.chainlm)
	end
end
function c9910291.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER) or e:GetHandler():IsType(TYPE_PENDULUM)
end
function c9910291.thfilter(c)
	return c:IsSetCard(0x957) and c:IsAbleToHand()
end
function c9910291.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910291.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.ShuffleDeck(tp)
	local g=Duel.GetDecktopGroup(tp,6)
	local b1=Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
	local b2=g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)>2
	if not (b1 or b2) then return end
	Duel.BreakEffect()
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9910291,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910291,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif opval[op]==2 then
		local g=Duel.GetDecktopGroup(1-tp,6)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
		if tg:GetCount()==0 then return end
		local sg=tg:Select(tp,3,3,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleDeck(1-tp)
	end
end
