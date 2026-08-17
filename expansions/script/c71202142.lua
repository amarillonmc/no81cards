local s,id,o=GetID()
function s.initial_effect(c)
	--①② effects share count
	--① negate summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	--② GY effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.gytg)
	e3:SetOperation(s.gyop)
	c:RegisterEffect(e3)
end
--①
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,71202132)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function s.desfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_AQUA)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)==0 then return end
	if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--②
function s.gyfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x88f) and c:IsType(TYPE_MONSTER)
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(s.gyfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chkc then return false end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and #g1>0 and #g2>0 end
	local maxnum=math.min(#g1,#g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg1=g1:Select(tp,1,maxnum,nil)
	local sg2=g2:Select(tp,#sg1,#sg1,nil)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg1,sg1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,0)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToDeck() and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)~=0 then
		--Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tg=g:Filter(Card.IsRelateToEffect,nil,e)
		if tg:GetCount()>0 then
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end
