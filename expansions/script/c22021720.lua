--妖星骑士 高文
function c22021720.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_DARK)
	e1:SetCondition(c22021720.attcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021720,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22021720)
	e2:SetTarget(c22021720.destg)
	e2:SetOperation(c22021720.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021720,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22021720)
	e3:SetCondition(c22021720.erecon)
	e3:SetCost(c22021720.erecost)
	e3:SetTarget(c22021720.destg)
	e3:SetOperation(c22021720.desop)
	c:RegisterEffect(e3)
end
c22021720.effect_with_dark=true
function c22021720.attcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==3 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==4 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==5 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==0 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==9 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==10 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==11
end
function c22021720.filter(c,atk)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c22021720.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22021720.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22021720.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22021720.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c22021720.filter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and c:IsAttribute(ATTRIBUTE_DARK) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(7800)
		c:RegisterEffect(e1)
	end
end
function c22021720.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22021720.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end