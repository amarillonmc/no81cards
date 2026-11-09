--Gentle Telepathy
function c33741093.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33741093,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c33741093.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33741093.target)
	e1:SetOperation(c33741093.activate)
	c:RegisterEffect(e1)
	if not c33741093.global_check then
		c33741093.global_check=true
		c33741093.damage_turn={[0]={},[1]={}}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c33741093.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33741093.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=rp then
		c33741093.damage_turn[rp][Duel.GetTurnCount(rp)]=true
	end
end
function c33741093.handcon(e)
	local tp,t=e:GetHandlerPlayer(),Duel.GetTurnCount(e:GetHandlerPlayer())
	return t>1 and not c33741093.damage_turn[tp][t-1]
end
function c33741093.samfilter(c,tc)
	return c:IsRace(tc:GetRace()) or c:IsAttribute(tc:GetAttribute()) or c:IsAttack(tc:GetAttack()) or c:IsDefense(tc:GetDefense())
end
function c33741093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) end
end
function c33741093.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER):GetFirst()
	if not tc then return end
	local g1,g2=Group.FromCards(tc),Group.CreateGroup()
	for i=1,283 do
		local p=i%2==0 and tp or 1-tp
		if not Duel.IsExistingMatchingCard(c33741093.samfilter,p,LOCATION_DECK,0,1,nil,tc) or not Duel.SelectYesNo(tp,aux.Stringid(33741093,3)) then break end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CONFIRM)
		tc=Duel.SelectMatchingCard(p,c33741093.samfilter,p,LOCATION_DECK,0,1,1,nil,tc):GetFirst()
		if i%2==0 then g1:AddCard(tc) else g2:AddCard(tc) end
	end
	local ct=#g1+#g2
	if ct==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	if ct>=2 then
		Duel.Recover(tp,#g1*300,REASON_EFFECT,true)
		Duel.Recover(1-tp,#g2*300,REASON_EFFECT,true)
		Duel.RDComplete()
	end
	if ct>=4 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if ct>=6 then
		Duel.BreakEffect()
		for p in aux.TurnPlayers() do
			local g=p==tp and g1 or g2
			if g:IsExists(Card.IsAbleToHand,1,nil,p) and Duel.SelectYesNo(p,aux.Stringid(33741093,0)) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local tg=g:FilterSelect(p,Card.IsAbleToHand,1,2,nil,p)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,tg)
			end
		end
	end
	if ct>=8 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c33741093.setop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c33741093.setfilter(c)
	return c:IsCode(33741093) and c:IsSSetable()
end
function c33741093.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c33741093.setfilter,tp,LOCATION_GRAVE,0,1,nil) or not Duel.SelectYesNo(tp,aux.Stringid(33741093,3)) then return end
	Duel.Hint(HINT_CARD,0,33741093)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,c33741093.setfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if sc then Duel.SSet(tp,sc) end
end
