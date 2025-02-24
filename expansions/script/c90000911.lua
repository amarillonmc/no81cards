--抉择之座
function c90000911.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddMaterialCodeList(c,90000907,90000909)
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionCode,90000907,90000909),c90000911.mfilter,1,true)
	aux.AddContactFusionProcedure(c,c90000911.cfilter,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,aux.tdcfop(c))
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetTarget(c90000911.destg)
	e3:SetOperation(c90000911.desop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c90000911.reccon)
	e4:SetCost(c90000911.reccost)
	e4:SetTarget(c90000911.rectg)
	e4:SetOperation(c90000911.recop)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c90000911.atkcon)
	e5:SetTarget(c90000911.atktg)
	e5:SetOperation(c90000911.atkop)
	c:RegisterEffect(e5)
end
function c90000911.mfilter(c)
	return c:GetBaseAttack()==0 and c:GetBaseDefense()==0
end
function c90000911.cfilter(c)
	return (c:IsFusionCode(90000907,90000909) or c:IsType(TYPE_MONSTER)) and c:IsAbleToDeckAsCost()
end
function c90000911.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc end
	Duel.SetTargetCard(bc)
end
function c90000911.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c90000911.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c90000911.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c90000911.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c90000911.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c90000911.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
			and not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c90000911.tdfilter,tp,LOCATION_GRAVE,0,1,5,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(#g*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,#g*500)
end
function c90000911.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_FAIRY)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_LIGHT)
		c:RegisterEffect(e2)
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c90000911.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c90000911.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)
		and not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,HINTMSG_DESTROY,g1,2,0,0)
end
function c90000911.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_FIEND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		c:RegisterEffect(e2)
	end
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)==2 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local val=g:GetSum(Card.GetBaseAttack)+g:GetSum(Card.GetBaseDefense)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
