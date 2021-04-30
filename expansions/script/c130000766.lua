--阿提纳诺-水寺院
function c130000766.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3)

local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(130000766,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_TODECK)
	  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c130000766.retcon)
	e3:SetTarget(c130000766.targetr)
	e3:SetOperation(c130000766.operationr)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(130000766,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c130000766.destg)
	e4:SetCost(c130000766.spcost)
	e4:SetOperation(c130000766.desop)
	c:RegisterEffect(e4)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c130000766.reptg)
	c:RegisterEffect(e7)
end
function c130000766.retcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c130000766.filterd(c)
	return c:IsFaceup() 
end
function c130000766.targetr(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c130000766.filterd,tp,LOCATION_GRAVE,0,1,nil) end
end
function c130000766.operationr(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c130000766.filterd,tp,LOCATION_GRAVE,0,nil)
	local c=e:GetHandler()
	Duel.Overlay(e:GetHandler(),g)
end
function c130000766.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c130000766.filter2(c)
	return  c:IsAbleToHand() and c:GetSequence()==5
end
function c130000766.filter3(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp)
end
function c130000766.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c130000766.filter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c130000766.filter2,tp,LOCATION_SZONE,0,1,nil)
and Duel.IsExistingMatchingCard(c130000766.filter3,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c130000766.filter2,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c130000766.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e)   then

		Duel.SendtoHand(tc,nil,REASON_EFFECT)

	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(130000766,1))
	local tc2=Duel.SelectMatchingCard(tp,c130000766.filter3,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc2 then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc2,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc2:GetActivateEffect()
		local tep=tc2:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc2,EVENT_CHAIN_SOLVED,tc2:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
	end
end
function c130000766.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return true end
	if Duel.SelectYesNo(tp,aux.Stringid(130000766,2)) and g2:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		  Duel.SendtoDeck(sg2,nil,2,REASON_COST)
		return true
	else return false end
end
