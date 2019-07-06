--动物朋友 沙漠猫
function c33700075.initial_effect(c)
	c33700075[c]={}
	local effect_list=c33700075[c]
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700075.cost)
	e1:SetTarget(c33700075.target)
	e1:SetOperation(c33700075.operation)
	c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700075,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetLabel(5)
	effect_list[5]=e2
	e2:SetCondition(c33700075.con)
	e2:SetOperation(c33700075.atkop)
	c:RegisterEffect(e2)
	--td
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700075,1))
	e4:SetRange(LOCATION_MZONE)
   e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e4:SetCode(EVENT_CHAINING)
   e4:SetLabel(12)
	effect_list[12]=e4
	e4:SetCondition(c33700075.con2)
	e4:SetTarget(c33700075.tg)
	e4:SetOperation(c33700075.op)
	c:RegisterEffect(e4)
 --
	 local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_MZONE)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e3:SetCode(EVENT_CHAINING)
   e3:SetCondition(c33700075.flcon)
	e3:SetOperation(c33700075.flop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCondition(c33700075.flcon2)
	e5:SetOperation(c33700075.flop2)
	c:RegisterEffect(e5)
   local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(33700075,2))
	e6:SetLabel(21)
	effect_list[21]=e6
	e6:SetCondition(c33700075.con3)
	c:RegisterEffect(e6)
end
function c33700075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700075.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700075)
end
function c33700075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700075.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700075.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700075.thfilter,tp,LOCATION_DECK,0,1,1,nil)
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
			e1:SetValue(c33700075.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700075.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700075.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700075.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700075.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33700075.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090 and not Duel.GetAttacker():IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK)
end
function c33700075.atkop(e,tp,eg,ep,ev,re,r,rp)
	local coin=Duel.TossCoin(tp,1)
	if coin~=1 then
	Duel.ChangeAttackTarget(nil)
end
end
function c33700075.flcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:GetCount()==1 and g:GetFirst()==e:GetHandler() 
end
function c33700075.flcon2(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	return tc:IsOnField()
end
function c33700075.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(33700075,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end
function c33700075.flop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(33700076,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end
function c33700075.con2(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c33700075.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	 return e:GetHandler():GetFlagEffect(33700075)>0 and (g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090)
end 
function c33700075.con3(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c33700075.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	 return e:GetHandler():GetFlagEffect(33700076)>0 and g:GetClassCount(Card.GetCode)>=e:GetLabel()
end 
function c33700075.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c33700075.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsOnField() and c33700075.filter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then return Duel.IsExistingTarget(c33700075.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c33700075.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c33700075.op(e,tp,eg,ep,ev,re,r,rp)
	local coin=Duel.TossCoin(tp,1)
	if coin~=1 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end
end