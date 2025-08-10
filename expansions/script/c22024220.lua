--人理之基 呼延灼
function c22024220.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xff1),2,true)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22024220.reccon)
	e2:SetOperation(c22024220.recop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22024220.reccon1)
	e3:SetOperation(c22024220.recop1)
	c:RegisterEffect(e3)

	--destory 2000
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22024220,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,22024220)
	e4:SetCondition(c22024220.dcon2)
	e4:SetTarget(c22024220.destg)
	e4:SetOperation(c22024220.desop)
	c:RegisterEffect(e4)
	--destory 5000
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22024220,3))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,22024220)
	e5:SetCondition(c22024220.dcon5)
	e5:SetTarget(c22024220.destg1)
	e5:SetOperation(c22024220.desop1)
	c:RegisterEffect(e5)
	--destory 2000 ere
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22024220,2))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCost(c22024220.erecost)
	e7:SetCountLimit(1,22024220)
	e7:SetCondition(c22024220.conere2)
	e7:SetTarget(c22024220.destg)
	e7:SetOperation(c22024220.desop)
	c:RegisterEffect(e7)
	--destory 5000 ere
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(22024220,3))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e8:SetCountLimit(1,22024220)
	e8:SetCost(c22024220.erecost)
	e8:SetCondition(c22024220.conere5)
	e8:SetTarget(c22024220.destg1)
	e8:SetOperation(c22024220.desop1)
	c:RegisterEffect(e8)
end
function c22024220.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and rp==tp and e:GetHandler():GetFlagEffect(1)>0
end
function c22024220.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c22024220.reccon1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and rp==1-tp and e:GetHandler():GetFlagEffect(1)>0
end
function c22024220.recop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end

function c22024220.dcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(2000) and e:GetHandler():IsAttackBelow(4999)
end
function c22024220.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SelectOption(tp,aux.Stringid(22024220,4))
end
function c22024220.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22024220,5))
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c22024220.dcon5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(5000) 
end
function c22024220.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SelectOption(tp,aux.Stringid(22024220,6))
end
function c22024220.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22024220,7))
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c22024220.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22024220.conere2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(2000) and e:GetHandler():IsAttackBelow(4999) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22024220.conere5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(5000) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end