--神碑之源 尤格特拉西尔
function c98941043.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x17f),2,true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98941043,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c98941043.thcon)
	e1:SetCost(c98941043.thcost)
	e1:SetTarget(c98941043.thtg)
	e1:SetOperation(c98941043.thop)
	c:RegisterEffect(e1) 
	 --disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98941043,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c98941043.discon)
	e2:SetTarget(c98941043.distg)
	e2:SetOperation(c98941043.disop)
	c:RegisterEffect(e2)
	--change effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(98942048)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
	--workaround
	if not aux.remove_hack_check then
		aux.remove_hack_check=true
		_drm=Duel.Remove
		function Duel.Remove(tg,pos,r)
			if Duel.IsPlayerAffectedByEffect(c:GetControler(),98942048) and (r==REASON_EFFECT or r==REASON_EFFECT+REASON_TEMPORARY) then
				return _drm(tg,POS_FACEDOWN,r)
			end
			return _drm(tg,pos,r)
		end
	end
end
function c98941043.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function c98941043.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98941043.thfilter(c)
	return c:IsSetCard(0x17f) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c98941043.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941043.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98941043.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98941043.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98941043.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x17f) and te:IsActiveType(TYPE_SPELL) and p==tp and rp==1-tp
end
function c98941043.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98941043.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end