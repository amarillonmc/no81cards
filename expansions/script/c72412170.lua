--星宫守护者·双子
function c72412170.initial_effect(c)
		--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72412170)
	e1:SetTarget(c72412170.lvtg)
	e1:SetOperation(c72412170.lvop)
	c:RegisterEffect(e1)
				--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412171)
	e2:SetOperation(c72412170.regop)
	c:RegisterEffect(e2)
end
function c72412170.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9728) and c:IsLevelAbove(1)
end
function c72412170.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412170.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(72412170,0),aux.Stringid(72412170,1))
	e:SetLabel(op)
end
function c72412170.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72412170.lvfilter,tp,LOCATION_MZONE,0,nil)
	local lc=g:GetFirst()
	while lc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(72412170,2)) then
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil) 
		if dg:GetCount()~=0 and Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD) then
		local g2=Duel.GetMatchingGroup(c72412170.lvfilter,tp,LOCATION_MZONE,0,nil)
		local lc2=g:GetFirst()
			while lc2 do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				if e:GetLabel()==0 then
					e1:SetValue(1)
				else
					e1:SetValue(-1)
				end
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				lc2:RegisterEffect(e1)
				lc2=g:GetNext()
			end  
		end
	end
end
function c72412170.thfilter1(c)
	return c:IsCode(72412180) or (Duel.IsPlayerAffectedByEffect(c:GetOwner(),72412340) and c:IsSetCard(0x9728))
end
function c72412170.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,72412170,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c72412170.thcon)
	e1:SetOperation(c72412170.thop)
	Duel.RegisterEffect(e1,tp)
end
function c72412170.thfilter2(c)
	return c72412170.thfilter1(c) and c:IsAbleToHand()
end
function c72412170.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c72412170.thfilter2),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,72412170)==0
end
function c72412170.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72412170)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72412170.thfilter2),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end