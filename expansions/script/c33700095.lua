--动物朋友 美洲红鹮
function c33700095.initial_effect(c)
	c33700095[c]={}
	local effect_list=c33700095[c]
		--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700095.cost)
	e1:SetTarget(c33700095.target)
	e1:SetOperation(c33700095.operation)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(7)
	effect_list[7]=e2
	e2:SetCondition(c33700095.effcon)
	e2:SetTarget(c33700095.tg)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	 --atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-700)
	e3:SetLabel(3)
	effect_list[3]=e3
	e3:SetCondition(c33700095.atkcon)
	c:RegisterEffect(e3)
  --Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700095,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetLabel(22)
	effect_list[22]=e4
	e4:SetCondition(c33700095.effcon2)
	e4:SetTarget(c33700095.destg)
	e4:SetOperation(c33700095.desop)
	c:RegisterEffect(e4)
end
function c33700095.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700095.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700095)
end
function c33700095.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700095.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700095.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700095.thfilter,tp,LOCATION_DECK,0,1,1,nil)
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
			e1:SetValue(c33700095.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700095.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700095.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700095.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700095.atkcon(e)
	local g=Duel.GetMatchingGroup(c33700095.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090
end
function c33700095.effcon(e)
	local g=Duel.GetMatchingGroup(c33700095.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090
end
function c33700095.tg(e,c)
   local g1,g2=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetMaxGroup(Card.GetAttack,nil)
   return c:GetAttack()>g2 and not c:IsImmuneToEffect(e)
end
function c33700095.effcon2(e)
	local g=Duel.GetMatchingGroup(c33700095.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c33700095.desfilter(c,tp)
   local g1,g2=Duel.GetMatchingGroup(Card.IsFaceup(),tp,LOCATION_MZONE,0,nil):GetMaxGroup(Card.GetAttack,nil) 
   return c:IsType(TYPE_MONSTER) and  c:GetAttack()>g2 
end
function c33700095.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c33700095.desfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	local sg=Duel.GetMatchingGroup(c33700095.desfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c33700095.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c33700095.desfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	Duel.Destroy(sg,REASON_EFFECT)
end