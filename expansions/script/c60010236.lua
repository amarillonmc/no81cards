--不觅浪尘
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.negreg)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetCondition(cm.thcon2)
	c:RegisterEffect(e3)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]==true
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_MONSTER)
	local g3=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	if not (g1 and g2 and g3) then return end
	g1:Merge(g2):Merge(g3)
	if g1:GetCount()==3 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		local g=Duel.GetOperatedGroup()
		local ag=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil,g)
		if #g==3 and g:GetClassCount(Card.IsRace)==#g and g:GetClassCount(Card.IsAttribute)==#g and #ag~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local xg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,g)
			if xg:GetCount()>0 then
				Duel.SendtoHand(xg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,xg)
			end
		end
	end
end
function cm.filter2(c,g)
	local tf=0
	for xc in aux.Next(g) do
		if xc:GetRace()~=c:GetRace() and xc:GetAttribute()~=c:GetAttribute() then
			tf=tf+1
		end
	end
	return tf==#g and c:IsAbleToHand()
end


function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return rp==tp and de and dp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end


function cm.negreg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetLabelObject(e)
	e1:SetOperation(cm.negcheck)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.negcheck(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	if rp==tp and de and dp==1-tp and re==te then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetOperation(cm.negevent)
		e1:SetLabelObject(te)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.negevent(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.RaiseEvent(te:GetHandler(),EVENT_CUSTOM+m,te,0,tp,tp,0)
	e:Reset()
end





