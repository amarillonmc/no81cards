local m=53737021
local cm=_G["c"..m]
cm.name="次元秽魔导 卑侮"
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.acop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.acop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(3)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(cm.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(cm.negcon)
	e7:SetCost(cm.negcost)
	e7:SetTarget(cm.negtg)
	e7:SetOperation(cm.negop)
	c:RegisterEffect(e7)
end
function cm.acop1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function cm.acfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function cm.acop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.acfilter,1,nil) then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function cm.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.IsPlayerCanRemove(1-tp) end
end
function cm.rmfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 or not Duel.IsPlayerCanRemove(1-tp) then return end
	local b1=Duel.GetDecktopGroup(1-tp,1):GetFirst():IsAbleToRemove()
	local b2=Duel.IsExistingMatchingCard(cm.rmfilter,1-tp,LOCATION_DECK,0,1,nil)
	local opt=0
	if b1 and b2 then opt=Duel.SelectOption(1-tp,aux.Stringid(m,2),aux.Stringid(m,3))+1 elseif b1 then opt=1 elseif b2 then opt=2 end
	if opt==1 then
		local g=Duel.GetDecktopGroup(1-tp,1)
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif opt==2 then
		local g=Duel.GetMatchingGroup(cm.rmfilter,1-tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.atkval(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x1)*-100
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,2,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.__add(Duel.GetMatchingGroup(Card.IsAbleToRemove,rp,LOCATION_HAND,0,re:GetHandler()),Duel.GetMatchingGroup(Card.IsAbleToRemove,rp,LOCATION_GRAVE,LOCATION_GRAVE,re:GetHandler()))
	if Duel.IsChainDisablable(0) and #g>0 and Duel.SelectYesNo(rp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_REMOVE)
		local sg=g:Select(rp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		return
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
