--宣告之堕天使
function c98920352.initial_effect(c)
	c:SetSPSummonOnce(98920352)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c98920352.matfilter,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,LOCATION_ONFIELD,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920352.splimit)
	c:RegisterEffect(e1)
--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920352,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98920352)
	e1:SetCondition(c98920352.tgcon)
	e1:SetTarget(c98920352.tgtg)
	e1:SetOperation(c98920352.tgop)
	c:RegisterEffect(e1)
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920352,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c98920352.descon)
	e3:SetTarget(c98920352.destg)
	e3:SetOperation(c98920352.desop)
	c:RegisterEffect(e3)
end
function c98920352.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xef)
end
function c98920352.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c98920352.cfilter(c,fc)
	return c:IsAbleToGraveAsCost()
end
function c98920352.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function c98920352.filter(c)
	return c:IsSetCard(0xef) and c:IsAbleToHand()
end
function c98920352.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5)
		and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c98920352.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			if g:IsExists(c98920352.filter,1,nil) then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c98920352.filter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			else
				Duel.ShuffleDeck(tp)
			end
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
end
function c98920352.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(0xef) and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsReason(REASON_EFFECT)
end
function c98920352.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920352.cfilter,1,nil,tp)
end
function c98920352.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98920352.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end