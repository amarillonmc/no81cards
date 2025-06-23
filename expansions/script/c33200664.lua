--电子音姬 Disco
function c33200664.initial_effect(c)
	c:SetSPSummonOnce(33200664)
	aux.AddXyzProcedureLevelFree(c,c33200664.mfilter,c33200664.xyzcheck,2,2)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200664,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33200664)
	e1:SetCondition(c33200664.drcon)
	e1:SetTarget(c33200664.drtg)
	e1:SetOperation(c33200664.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200664,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200665)
	e2:SetTarget(c33200664.atktg)
	e2:SetOperation(c33200664.atkop)
	c:RegisterEffect(e2)
end
function c33200664.mfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function c33200664.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end

--e1
function c33200664.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33200664.drfilter(c)
	return c:IsSetCard(0xa32a) and c:IsAbleToDeck() and not c:IsPublic()
end
function c33200664.fselect(g)
	return g:IsExists(Card.IsSetCard,1,nil,0xa32a)
end
function c33200664.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(c33200664.drfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c33200664.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	local sg=g:SelectSubGroup(tp,c33200664.fselect,false,1,99)
	if sg:GetCount()>0 then
		Duel.ConfirmCards(1-p,sg)
		local ct=aux.PlaceCardsOnDeckBottom(p,sg)
		if ct==0 then return end
		Duel.BreakEffect()
		Duel.Draw(p,ct+1,REASON_EFFECT)
	end
end

--e2
function c33200664.atkfilter(c)
	return c:IsFaceup()
end
function c33200664.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200664.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c33200664.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c33200664.atkfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
	end
end