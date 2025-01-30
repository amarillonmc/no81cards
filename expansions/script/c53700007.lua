--神 灵 庙
function c53700007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53700007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c53700007.target)
	e1:SetOperation(c53700007.activate)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53700007,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(3)
	e2:SetTarget(c53700007.stg)
	e2:SetOperation(c53700007.sop)
	c:RegisterEffect(e2)
end
function c53700007.filter(c)
	return c:IsCode(53700002,53700003,53700004) and c:IsAbleToHand()
end
function c53700007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53700007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53700007.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53700007.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c53700007.filter2(c)
	return c:IsCode(53700001) and c:IsLevelAbove(1)
end
function c53700007.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c53700007.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c53700007.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c53700007.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:IsLevelBelow(2) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then op=Duel.SelectOption(tp,aux.Stringid(53700007,1))
	else op=Duel.SelectOption(tp,aux.Stringid(53700007,1),aux.Stringid(53700007,2)) end
	e:SetLabel(op)
end
function c53700007.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(2)
		tc:RegisterEffect(e1)
	elseif e:GetLabel()~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsLevelAbove(3) then
		local token=Duel.CreateToken(tp,53700001)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_2:SetCode(EFFECT_CHANGE_LEVEL)
			e1_2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1_2:SetValue(tc:GetLevel()-2)
			token:RegisterEffect(e1_2)
		end
		Duel.SpecialSummonComplete()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetTargetRange(0xff,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
		e2:SetValue(c53700007.sumlimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		Duel.RegisterEffect(e3,tp)
	end
end
function c53700007.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
