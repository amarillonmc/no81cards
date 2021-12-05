--神花的引导者
function c72412140.initial_effect(c)
		--link summon
	c:SetSPSummonOnce(72412140)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe728),1,1)
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c72412140.tgtg)
	e1:SetOperation(c72412140.tgop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72412140,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72412140.necon)
	e2:SetCost(c72412140.necost)
	e2:SetTarget(c72412140.netg)
	e2:SetOperation(c72412140.neop)
	c:RegisterEffect(e2)
end
function c72412140.filter(c)
	return c:IsSetCard(0xe728) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c72412140.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412140.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c72412140.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c72412140.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c72412140.necon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,72412140)==0
end
function c72412140.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c72412140.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c72412140.neop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c72412140.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c72412140.effectfilter)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,72412140,RESET_PHASE+PHASE_END,0,1)
end
function c72412140.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0xe728) and te:GetHandler():IsType(TYPE_MONSTER) and bit.band(loc,LOCATION_HAND)~=0
end
