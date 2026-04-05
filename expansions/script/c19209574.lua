--判决牢狱的女王蜂 楠梦羽
function c19209574.initial_effect(c)
	aux.AddCodeList(c,19209556)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c19209574.ovfilter,aux.Stringid(19209574,0),2)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209574,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c19209574.rmcon)
	e1:SetTarget(c19209574.rmtg)
	e1:SetOperation(c19209574.rmop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c19209574.pencon)
	e2:SetTarget(c19209574.pentg)
	e2:SetOperation(c19209574.penop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,19209574)
	e3:SetTarget(c19209574.thtg)
	e3:SetOperation(c19209574.thop)
	c:RegisterEffect(e3)
end
function c19209574.ovfilter(c)
	return c:IsCode(19209522) and c:IsSummonableCard() and c:IsFaceup()
end
function c19209574.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c19209574.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsControler,0,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsControler,0,1)
	Duel.SetTargetCard(sg)
end
function c19209574.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c19209574.pencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c19209574.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c19209574.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
end
function c19209574.thfilter(c,chk)
	return c:IsCode(19209556) and c:IsAbleToHand()
end
function c19209574.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209574.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209574.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209574.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(19209574,2)) then return end
end
