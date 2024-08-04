--天外来客 地狱之星
function c98933006.initial_effect(c)
	c:SetUniqueOnField(1,0,98933006)
		--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c98933006.ovfilter,aux.Stringid(98933006,2),3,c98933006.xyzop)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98933006.discon)
	e3:SetOperation(c98933006.disop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98933006,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c98933006.negop)
	c:RegisterEffect(e4)
	if not c98933006.global_check then
		c98933006.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c98933006.reccon)
		ge1:SetOperation(c98933006.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98933006.ovfilter(c)
	return c:IsFaceup() and not c:IsSummonableCard()
end
function c98933006.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98933006)>=3 end
end
function c98933006.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),98933006,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c98933006.reccon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	return eg:IsExists(c98933006.ecfilter,1,nil,tp)
end
function c98933006.ecfilter(c,tp)
	return c:IsSummonPlayer(tp) and not c:IsSummonableCard() and c:IsSummonLocation(LOCATION_HAND)
end
function c98933006.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function c98933006.disop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(98933006,2)) then
		Duel.Hint(HINT_CARD,0,98933006)
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
function c98933006.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(c98933006.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98933006,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c98933006.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c98933006.thfilter(c)
	return not c:IsSummonableCard() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end