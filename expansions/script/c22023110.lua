--人理之诗 开拓黑暗的星条之象
function c22023110.initial_effect(c)
	aux.AddCodeList(c,22023050) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023110,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22023110.condition)
	e1:SetTarget(c22023110.target)
	e1:SetOperation(c22023110.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023110,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22023110)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22023110.drtg)
	e2:SetOperation(c22023110.drop)
	c:RegisterEffect(e2)
end
function c22023110.cfilter(c)
	return c:IsFaceup() and c:IsCode(22023050) and c:IsLevelAbove(10)
end
function c22023110.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023110.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22023110.filter(c)
	return c:IsFaceup()
end
function c22023110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023110.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22023110.filter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	Duel.SelectOption(tp,aux.Stringid(22023110,2))
end
function c22023110.atkfilter(c)
	return c:IsFaceup() and (c:IsAttackAbove(0) or c:IsDefenseAbove(0)) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c22023110.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22023110.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			Duel.SelectOption(tp,aux.Stringid(22023110,3))
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
		if Duel.IsExistingMatchingCard(c22023110.atkfilter,tp,0,LOCATION_MZONE,1,nil) then
			local g=Duel.GetMatchingGroup(c22023110.atkfilter,tp,0,LOCATION_MZONE,nil)
			local tc=g:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
				tc=g:GetNext()
			end
		end
	end
end
function c22023110.cfilter(c)
	return c:IsCode(22023050) and c:IsLevel(10)
end
function c22023110.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22023110.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetCount()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c22023110.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c22023110.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetCount()
	Duel.SelectOption(tp,aux.Stringid(22023110,4))
	Duel.Draw(p,ct,REASON_EFFECT)
end
