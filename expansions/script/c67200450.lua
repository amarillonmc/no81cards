--穿行的旅者 阿娜丝塔希雅
function c67200450.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c67200450.ovfilter,aux.Stringid(67200450,0),2,c67200450.xyzop)
	--Draw
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOEXTRA)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,67200450)
	e0:SetCost(c67200450.setcost)
	e0:SetTarget(c67200450.tgtg)
	e0:SetOperation(c67200450.tgop)
	c:RegisterEffect(e0)
	--pendulum 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200450,3))
	e4:SetCategory(CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c67200450.pencon)
	e4:SetTarget(c67200450.pentg)
	e4:SetOperation(c67200450.penop)
	c:RegisterEffect(e4)	 
end
function c67200450.ovfilter(c)
	return c:IsFaceup() and c:IsLevel(7) and c:IsType(TYPE_PENDULUM)
end
function c67200450.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,67200450)==0 end
	Duel.RegisterFlagEffect(tp,67200450,RESET_PHASE+PHASE_END,0,1)
end
--
function c67200450.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	if c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c67200450.tgfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c67200450.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200450.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	--Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	--Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200450.tgop(e,tp,eg,ep,ev,re,r,rp)
--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c67200450.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local th=g:GetFirst():IsAbleToGrave()
		local op=0
		if th then op=Duel.SelectOption(tp,aux.Stringid(67200450,1),aux.Stringid(67200450,2))
		elseif th then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		else
			Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		end
	end
end

--go to P zone
function c67200450.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67200450.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200450.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end


