--端午节的小袖之手
function c8709005.initial_effect(c)
		 --DES
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8709005,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,8709005)
	e1:SetCondition(c8709005.descon)
	e1:SetTarget(c8709005.destg)
	e1:SetOperation(c8709005.desop)
	c:RegisterEffect(e1)   
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c8709005.discon)
	e4:SetOperation(c8709005.disop)
	c:RegisterEffect(e4)


end
function c8709005.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()<5
end
function c8709005.desfilter(c)
	return (c:IsFacedown() or not c:IsSetCard(0xafa)) and c:IsType(TYPE_MONSTER)
end
function c8709005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8709005.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c8709005.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c8709005.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8709005.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c8709005.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsSetCard(0xafa) and seq1==4-seq2
end
function c8709005.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(c8709005.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c8709005.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,8709005)
	Duel.NegateEffect(ev)
end



