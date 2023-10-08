--胧之渺翳的炽炎
function c9911324.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911324)
	e2:SetCost(c9911324.thcost)
	e2:SetTarget(c9911324.thtg)
	e2:SetOperation(c9911324.thop)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c9911324.chcon)
	e3:SetOperation(c9911324.chop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,9911325)
	e4:SetCondition(c9911324.regcon)
	e4:SetOperation(c9911324.regop)
	c:RegisterEffect(e4)
end
function c9911324.thfilter(c,tp,ft)
	local b1=c:IsAbleToHand()
	local b2=ft>0 and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	return c:IsSetCard(0xa958) and c:IsType(TYPE_MONSTER) and (b1 or b2)
end
function c9911324.cfilter(c,tp)
	if c:IsFacedown() or not c:IsReleasable() then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then ft=ft+1 end
	return Duel.IsExistingMatchingCard(c9911324.thfilter,tp,LOCATION_DECK,0,1,nil,tp,ft)
end
function c9911324.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9911324.cfilter,tp,LOCATION_ONFIELD,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c9911324.cfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.Release(g,REASON_COST)
end
function c9911324.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)+1
	if chk==0 then return Duel.IsExistingMatchingCard(c9911324.thfilter,tp,LOCATION_DECK,0,1,nil,tp,ft) end
end
function c9911324.thop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9911324.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,ft)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:CheckUniqueOnField(tp) and not tc:IsForbidden()
			and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,aux.Stringid(9911324,0))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			local sc=sg:GetFirst()
			if sc then
				if Duel.Equip(tp,tc,sc) then
					--equip limit
					local e0=Effect.CreateEffect(e:GetHandler())
					e0:SetType(EFFECT_TYPE_SINGLE)
					e0:SetCode(EFFECT_EQUIP_LIMIT)
					e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e0:SetLabelObject(sc)
					e0:SetValue(c9911324.eqlimit)
					e0:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e0)
				end
			end
		end
	end
end
function c9911324.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c9911324.desfilter(c)
	return c:GetEquipCount()>0
end
function c9911324.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c9911324.desfilter,tp,0,LOCATION_MZONE,1,nil)
		and e:GetHandler():GetFlagEffect(9911324)<=0
end
function c9911324.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		c:RegisterFlagEffect(9911324,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		return Duel.ChangeChainOperation(ev,c9911324.repop)
	end
end
function c9911324.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911324)
	local g=Duel.SelectMatchingCard(tp,c9911324.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local sg=tc:GetEquipGroup()
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c9911324.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9911324.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetCondition(c9911324.descon)
	e1:SetOperation(c9911324.desop)
	Duel.RegisterEffect(e1,tp)
end
function c9911324.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)>0
end
function c9911324.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911324)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
