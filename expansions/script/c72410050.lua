--信念之战旗 贞德
function c72410050.initial_effect(c)
	aux.AddCodeList(c,72410000)
		--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_RECOVER)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c72410050.thcon)
	e0:SetTarget(c72410050.thtg)
	e0:SetOperation(c72410050.thop)
	c:RegisterEffect(e0)
	--cannot be destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c72410050.con1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot be efftg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72410050.con2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1500)
	e3:SetCondition(c72410050.con3)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72410050,6))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c72410050.con4)
	e4:SetCost(c72410050.discost)
	e4:SetTarget(c72410050.distg)
	e4:SetOperation(c72410050.disop)
	c:RegisterEffect(e4)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(72410050,7))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c72410050.con5)
	e5:SetTarget(c72410050.target)
	e5:SetOperation(c72410050.operation)
	c:RegisterEffect(e5)
	--recover
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(72410050,8))
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCondition(c72410050.con6)
	e6:SetTarget(c72410050.target6)
	e6:SetOperation(c72410050.operation6)
	c:RegisterEffect(e6)
end
--e1-e3
function c72410050.con1(e)
	return Card.GetFlagEffect(e:GetHandler(),72410051)~=0
end
function c72410050.con2(e)
	return Card.GetFlagEffect(e:GetHandler(),72410052)~=0
end
function c72410050.con3(e)
	return Card.GetFlagEffect(e:GetHandler(),72410053)~=0
end
function c72410050.con5(e)
	return Card.GetFlagEffect(e:GetHandler(),72410055)~=0
end
--e4
function c72410050.con4(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and Card.GetFlagEffect(e:GetHandler(),72410054)~=0
end
function c72410050.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c72410050.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c72410050.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--e5
function c72410050.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c72410050.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--e6
function c72410050.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) and Card.GetFlagEffect(e:GetHandler(),72410056)~=0
end
function c72410050.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,dam)
end
function c72410050.operation6(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end


function c72410050.enfliter(e)
	local en=0
	if Card.GetFlagEffect(e:GetHandler(),72410051)~=0 then en=en+100000 end
	if Card.GetFlagEffect(e:GetHandler(),72410052)~=0 then en=en+10000 end
	if Card.GetFlagEffect(e:GetHandler(),72410053)~=0 then en=en+1000 end
	if Card.GetFlagEffect(e:GetHandler(),72410054)~=0 then en=en+100 end
	if Card.GetFlagEffect(e:GetHandler(),72410055)~=0 then en=en+10 end
	if Card.GetFlagEffect(e:GetHandler(),72410056)~=0 then en=en+1 end
	return en
end
function c72410050.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c72410050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  true end
end
function c72410050.thop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=1 
	if Duel.IsEnvironment(72410000) then ct=ct+1 end

		if ct>=1 and c72410050.enfliter(e)==11111 then
			c:RegisterFlagEffect(72410051,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2) 
			ct=ct-1
		elseif ct>=1 and Card.GetFlagEffect(c,72410051)==0 and Duel.SelectYesNo(tp,aux.Stringid(72410050,0)) then
			c:RegisterFlagEffect(72410051,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		end
		Duel.BreakEffect()
--  
		if ct>=1 and c72410050.enfliter(e)==101111 then
			c:RegisterFlagEffect(72410052,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		elseif ct>=1 and Card.GetFlagEffect(c,72410052)==0 and Duel.SelectYesNo(tp,aux.Stringid(72410050,1)) then
			c:RegisterFlagEffect(72410052,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		end
--
		Duel.BreakEffect()
		if ct>=1 and c72410050.enfliter(e)==110111 then
			c:RegisterFlagEffect(72410053,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		elseif ct>=1 and Card.GetFlagEffect(c,72410053)==0 and Duel.SelectYesNo(tp,aux.Stringid(72410050,2)) then
			c:RegisterFlagEffect(72410053,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		end
		Duel.BreakEffect()
--
		if ct>=1 and c72410050.enfliter(e)==111011 then
			c:RegisterFlagEffect(72410054,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		elseif ct>=1 and Card.GetFlagEffect(c,72410054)==0 and Duel.SelectYesNo(tp,aux.Stringid(72410050,3)) then
			c:RegisterFlagEffect(72410054,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		end
		Duel.BreakEffect()
--
		if ct>=1 and c72410050.enfliter(e)==111101 then
			c:RegisterFlagEffect(72410055,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		elseif ct>=1 and Card.GetFlagEffect(c,72410055)==0 and Duel.SelectYesNo(tp,aux.Stringid(72410050,4)) then
			c:RegisterFlagEffect(72410055,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		end
		Duel.BreakEffect()
--
		if ct==2 and c72410050.enfliter(e)==111110 then
			c:RegisterFlagEffect(72410056,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		elseif ct==1 and Card.GetFlagEffect(c,72410056)==0 and Duel.IsEnvironment(72410000) and Duel.SelectYesNo(tp,aux.Stringid(72410050,5)) then
			c:RegisterFlagEffect(72410056,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		elseif ct==1 and Card.GetFlagEffect(c,72410056)==0 and not Duel.IsEnvironment(72410000) then
			c:RegisterFlagEffect(72410056,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			ct=ct-1
		end

end
