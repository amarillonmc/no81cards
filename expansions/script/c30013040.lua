--深土之物 来自深谷的侵染
local m=30013040
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 1
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_DISABLE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCountLimit(1,m+100)
	e12:SetCondition(cm.thcon1)
	e12:SetCost(cm.thcost)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_DISABLE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetCode(EVENT_FREE_CHAIN)
	e32:SetRange(LOCATION_MZONE)
	e32:SetCountLimit(1,m+100)
	e32:SetCondition(cm.thcon2)
	e32:SetCost(cm.thcost)
	e32:SetTarget(cm.thtg)
	e32:SetOperation(cm.thop)
	c:RegisterEffect(e32)
end
--Effect 2
function cm.pos(c)
	return c:IsCanTurnSet() and not c:IsLocation(LOCATION_PZONE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pos,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.pos,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local xg=Group.CreateGroup()
		while tc do   
			if tc:GetOriginalType()&TYPE_MONSTER==0 and Duel.ChangePosition(tc,POS_FACEDOWN)>0 then
				xg:AddCard(tc)
				if tc:IsControler(1-tp) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(aux.Stringid(m,1))
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
					tc:RegisterEffect(e1)
				end
			elseif tc:GetOriginalType()&TYPE_MONSTER>0  then
				local pos=POS_FACEDOWN
				if	c:IsLocation(LOCATION_MZONE) then pos=POS_FACEDOWN_DEFENSE end
				if Duel.ChangePosition(tc,pos)>0 and tc:IsControler(1-tp) and tc:IsAbleToGrave() then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end 
			tc=g:GetNext()
		end
		if #xg>0 then
			Duel.RaiseEvent(xg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end 
	end
end
--Effect 3 
function cm.thcon1(e)
	local tsp=e:GetHandler():GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcon2(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.th(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) 
		and c:IsSetCard(0x92c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local res=false
	if #g>0 then
		local tc=g:GetFirst()
		Duel.HintSelection(g) 
		if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e3)
			end
			res=true
			if res~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.th),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.th),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				if g1:GetCount()>0 then
					Duel.SendtoHand(g1,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g1)
				end
			end
		end 
	end
end
