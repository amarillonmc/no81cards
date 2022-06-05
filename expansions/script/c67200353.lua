--鼓炎的结天缘魔 贝利亚
function c67200353.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum
	aux.EnablePendulumAttribute(c,false)
	--Synchro meterial
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM),aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1)
	--Draw
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCost(c67200353.setcost)
	e0:SetTarget(c67200353.tgtg)
	e0:SetOperation(c67200353.tgop)
	c:RegisterEffect(e0)
	--disable and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c67200353.exctcon)
	e3:SetOperation(c67200353.exctop)
	c:RegisterEffect(e3)
	--pendulum 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200353,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c67200353.pencon)
	e4:SetTarget(c67200353.pentg)
	e4:SetOperation(c67200353.penop)
	c:RegisterEffect(e4)	 
end
--
function c67200353.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	if c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c67200353.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x671) and c:IsAbleToGrave()
end
function c67200353.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200353.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c67200353.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200353.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--
function c67200353.cfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c67200353.exctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200353.cfilter,1,nil,1-tp)
end
function c67200353.ctfilter(c,tp)
	return c:IsSetCard(0x671) and c:IsFaceup() and c:IsControler(tp) and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c67200353.ctfilter1(c,tp)
	return c:IsControler(tp) and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c67200353.exctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetCount()~=1 or not Duel.IsExistingMatchingCard(c67200353.ctfilter,tp,LOCATION_MZONE,0,1,c,tp) or not eg:IsExists(c67200353.ctfilter1,1,nil,1-tp) then return end
	local a=eg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200353,3))
	local bb=Duel.SelectMatchingCard(tp,c67200353.ctfilter,tp,LOCATION_MZONE,0,1,1,c,tp)
	local b=bb:GetFirst()
	if a and b then
		Duel.SwapControl(a,b)
	end
end
--go to P zone
function c67200353.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67200353.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200353.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end