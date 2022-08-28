local m=15004225
local cm=_G["c"..m]
cm.name="陵薮层岩·白垩之子"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.ctfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsCanAddCounter(0x1f31,1)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and cm.ctfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,15004226,nil,TYPES_TOKEN_MONSTER,1000,1000,2,RACE_ROCK,ATTRIBUTE_EARTH)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9f31) and c:IsAbleToHand()
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	local tc=tg:GetFirst()
	local x=0
	while tc do
		if tc:AddCounter(0x1f31,1,REASON_EFFECT) then x=x+1 end
		tc=tg:GetNext()
	end
	if x~=tg:GetCount() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,15004226,nil,TYPES_TOKEN_MONSTER,1000,1000,2,RACE_ROCK,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,15004226)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetCounter(0x1f31)~=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,15004226)
		local b2=Duel.IsCanRemoveCounter(tp,1,1,0x1f31,2,REASON_COST)
		return b1 or b2
	end
	local b1=Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,15004226)
	local b2=Duel.IsCanRemoveCounter(tp,1,1,0x1f31,2,REASON_COST)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	if op==0 then
		local sg=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,15004226)
		Duel.Release(sg,REASON_COST)
	end
	if op==1 then
		Duel.RemoveCounter(tp,1,1,0x1f31,2,REASON_COST)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local ag=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	local ac=ag:GetFirst()
	if ac then
		Duel.HintSelection(Group.FromCards(ac))
		Duel.NegateRelatedChain(ac,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ac:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ac:RegisterEffect(e2)
		if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,ac) then
			local bg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,ac)
			local bc=bg:GetFirst()
			while bc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				bc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e2:SetValue(0)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				bc:RegisterEffect(e2)
				bc=bg:GetNext()
			end
		end
	end
end