--心散华·困兽决斗
local m=33711903
local cm=_G["c"..m]
function cm.initial_effect(c)
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==1 and Duel.GetMatchingGroupCount(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,1,nil)
	g1:Merge(g2)
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_SZONE,0,e:GetHandler())==0 then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	end
end
function cm.check(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.check2(c)
	return not c:IsForbidden() and c:IsType(TYPE_EQUIP)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE+EFFECT_CANNOT_DISABLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,1))
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLE_START)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e3:SetHintTiming(TIMING_DAMAGE_STEP)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(cm.atkcon)
		e3:SetOperation(cm.atkop)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BATTLE_DAMAGE)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetCondition(cm.condition2)
		e4:SetOperation(cm.operation2)
		tc:RegisterEffect(e4)
	end
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:GetOwner()~=e:GetOwner()
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToBattle() then
		return false 
	end
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if b and b==e:GetHandler() then
		return a:GetFlagEffect(m)==0
	else
		return b and b:GetFlagEffect(m)==0
	end 
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if b and b==e:GetHandler() then
		Duel.SendtoGrave(a,REASON_EFFECT)
	elseif a==e:GetHandler() then
		Duel.SendtoGrave(b,REASON_EFFECT)
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	return (t==c and a:GetFlagEffect(m)>0)
			or (a==c and t and t:GetFlagEffect(m)>0)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local rg=g:GetMinGroup(Card.GetAttack)
	if Duel.SendtoGrave(rg,REASON_EFFECT) then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		local effp=tc:GetPreviousControler()
		if Duel.IsExistingMatchingCard(cm.sp,effp,LOCATION_DECK,0,1,nil,e,effp,tc) and Duel.GetLocationCount(effp,LOCATION_MZONE)>0 and Duel.SelectYesNo(effp,aux.Stringid(m,3)) then
			local dg=Duel.GetFieldGroup(effp,LOCATION_DECK,0)
			Duel.ConfirmCards(1-effp,dg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(effp,cm.sp,effp,LOCATION_DECK,0,1,1,nil,e,effp,tc)
			Duel.SpecialSummon(sg,0,effp,effp,false,false,POS_FACEUP)
		else
			local lp=Duel.GetLP(effp)
			Duel.SetLP(effp,lp/2)
		end
	end
end