--忘忧的旋律
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410013)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.effcon)
	e2:SetTarget(cm.efftg)
	e2:SetOperation(cm.effop)
	c:RegisterEffect(e2)
end
function cm.cfilter2(c)
	return c:IsCode(23410013) or c:IsType(TYPE_RITUAL)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_REMOVED) and not tc:IsReason(REASON_REDIRECT) then
		
		local cg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,nil)
		Duel.ConfirmCards(tp,cg)
		local rg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,rc):Filter(Card.IsCode,nil,tc:GetCode())
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
function cm.cfilter(c,tp)
	return c:IsFacedown() and c:GetControler()==1-tp
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
		and aux.exccon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.filter(c)
	return aux.IsCodeListed(c,23410013) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end