--电晶皇 晶辉四剑装
function c72410150.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9729),2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410150,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c72410150.discon1)
	e1:SetTarget(c72410150.distg1)
	e1:SetOperation(c72410150.disop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410150,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c72410150.discon2)
	e2:SetTarget(c72410150.distg2)
	e2:SetOperation(c72410150.disop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72410150,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c72410150.discon3)
	e3:SetTarget(c72410150.distg3)
	e3:SetOperation(c72410150.disop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72410150,3))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(en)
	e4:SetCondition(c72410150.con4)
	e4:SetValue(c72410150.efilter)
	c:RegisterEffect(e4)
end
function c72410150.enfliter(e)
	local en=0
	if Card.GetFlagEffect(e:GetHandler(),72410080)~=0 then en=en+1 end
	if Card.GetFlagEffect(e:GetHandler(),72410090)~=0 then en=en+1 end
	if Card.GetFlagEffect(e:GetHandler(),72410102)~=0 then en=en+1 end
	if Card.GetFlagEffect(e:GetHandler(),72410104)~=0 then en=en+1 end
	if Card.GetFlagEffect(e:GetHandler(),72410106)~=0 then en=en+1 end
	if Card.GetFlagEffect(e:GetHandler(),72410110)~=0 then en=en+1 end
	if Card.GetFlagEffect(e:GetHandler(),72410120)~=0 then en=en+1 end
	if Card.GetFlagEffect(e:GetHandler(),72410130)~=0 then en=en+1 end
	if Card.GetFlagEffect(e:GetHandler(),72410140)~=0 then en=en+1 end 
	return en
end
function c72410150.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_TRAP) and (e:GetHandler():GetFlagEffect(72410152)==0 or (e:GetHandler():GetFlagEffect(72410152)==1 and e:GetHandler():GetFlagEffect(72410230)~=0)) and c72410150.enfliter(e)>=2 
end
function c72410150.discon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_SPELL) and (e:GetHandler():GetFlagEffect(72410154)==0 or (e:GetHandler():GetFlagEffect(72410154)==1 and e:GetHandler():GetFlagEffect(72410230)~=0)) and c72410150.enfliter(e)>=4
end
function c72410150.discon3(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER) and (e:GetHandler():GetFlagEffect(72410156)==0 or (e:GetHandler():GetFlagEffect(72410156)==1 and e:GetHandler():GetFlagEffect(72410230)~=0)) and c72410150.enfliter(e)>=6
end
function c72410150.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Card.RegisterFlagEffect(e:GetHandler(),72410152,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1,0) 
end
function c72410150.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Card.RegisterFlagEffect(e:GetHandler(),72410154,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1,0) 
end
function c72410150.distg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Card.RegisterFlagEffect(e:GetHandler(),72410156,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1,0) 
end
function c72410150.disop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c72410150.con4(e)
	return c72410150.enfliter(e)>=8
end
function c72410150.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false
	end
	return te:GetOwnerPlayer()~=c:GetControler()
end