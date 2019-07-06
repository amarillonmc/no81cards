--动物朋友 大熊猫
function c33700071.initial_effect(c)
	c33700071[c]={}
	local effect_list=c33700071[c]
	  --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700071.cost)
	e1:SetTarget(c33700071.target)
	e1:SetOperation(c33700071.operation)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(7)
	effect_list[7]=e2
	e2:SetCondition(c33700071.effcon)
	e2:SetTarget(c33700071.tg)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetLabel(15)
	effect_list[15]=e3
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetTarget(c33700071.tg2)
	c:RegisterEffect(e3)
   --skip
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetLabel(20)
	effect_list[20]=e4
	e4:SetCondition(c33700071.effcon2)
	e4:SetCode(EFFECT_SKIP_BP)
	c:RegisterEffect(e4)
end
function c33700071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700071.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700071)
end
function c33700071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700071.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700071.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700071.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c33700071.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700071.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700071.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700071.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700071.effcon(e)
	local g=Duel.GetMatchingGroup(c33700071.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090
end
function c33700071.effcon2(e)
	local g=Duel.GetMatchingGroup(c33700071.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() 
end
function c33700071.tg(e,c)
   return c:GetLevel()>e:GetHandler():GetLevel() and not c:IsImmuneToEffect(e)
end
function c33700071.tg2(e,c)
   return c:GetAttack()>e:GetHandler():GetAttack() and not c:IsImmuneToEffect(e)
end