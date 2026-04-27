local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetBaseDefense()==2350 and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.GetFlagEffect(tp,id+2)==0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	e:SetLabel(op)
	Duel.RegisterFlagEffect(tp,id+op+1,RESET_PHASE+PHASE_END,0,1)
	if op==0 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function s.dcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetBaseDefense()==2350
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)==2 then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(s.dcfilter,tp,LOCATION_HAND,0,nil)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			else
				local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.spfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.spfilter,nil)==2
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
