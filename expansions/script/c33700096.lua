--动物朋友 金丝猴
function c33700096.initial_effect(c)
	c33700096[c]={}
	local effect_list=c33700096[c]
	  --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700096.cost)
	e1:SetTarget(c33700096.target)
	e1:SetOperation(c33700096.operation)
	c:RegisterEffect(e1) 
	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700096,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(7)
	effect_list[7]=e2
	e2:SetCondition(c33700096.cbcon)
	e2:SetOperation(c33700096.cbop)
	c:RegisterEffect(e2)  
   --ayk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33700096.atkcon)
	effect_list[3]=e3
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700096,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c33700096.recon)
	e4:SetTarget(c33700096.retg)
	e4:SetOperation(c33700096.reop)
	effect_list[22]=e4
	c:RegisterEffect(e4)
end
function c33700096.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700096.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700096)
end
function c33700096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700096.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700096.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700096.thfilter,tp,LOCATION_DECK,0,1,1,nil)
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
			e1:SetValue(c33700096.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700096.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700096.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700096.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700096.cbcon(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c33700096.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
   return Duel.GetTurnPlayer()==1-tp and Duel.GetAttackTarget()~=e:GetHandler() and  (g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090)
end
function c33700096.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,c)
		end
	end
end
function c33700096.atkcon(e)
	local g=Duel.GetMatchingGroup(c33700096.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3 or e:GetLabel()==33700090
end
function c33700096.recon(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(c33700096.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and g:GetClassCount(Card.GetCode)>=22
end
function c33700096.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c33700096.reop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end