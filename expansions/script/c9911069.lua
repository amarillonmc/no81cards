--魔狱之领主 恋慕骑士
function c9911069.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9954),c9911069.mfilter,true)
	c:EnableReviveLimit()
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c9911069.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9911069.negcon)
	e3:SetTarget(c9911069.negtg)
	e3:SetOperation(c9911069.negop)
	c:RegisterEffect(e3)
end
function c9911069.mfilter(c)
	return c:GetCounter(0x1954)>0 and c:IsFusionType(TYPE_EFFECT)
end
function c9911069.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1954)*-100
end
function c9911069.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and Duel.IsChainNegatable(ev)
end
function c9911069.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1954,4,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9911069.filter(c,tp)
	return c:GetCounter(0x1954)>0 and c:IsCanRemoveCounter(tp,0x1954,1,REASON_EFFECT)
end
function c9911069.atkfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and not c:IsAttack(3000)
end
function c9911069.negop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	if not Duel.IsCanRemoveCounter(tp,1,1,0x1954,4,REASON_EFFECT) then return end
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911069,i))
		local sc=Duel.SelectMatchingCard(tp,c9911069.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp):GetFirst()
		sc:RemoveCounter(tp,0x1954,1,REASON_EFFECT)
		if sc:IsLocation(LOCATION_MZONE) then sg:AddCard(sc) end
	end
	if Duel.NegateActivation(ev) and sg:IsExists(c9911069.atkfilter,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(9911069,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local cg=sg:FilterSelect(tp,c9911069.atkfilter,1,1,nil,tp)
		Duel.HintSelection(cg)
		local tc=cg:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(3000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
