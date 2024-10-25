--虚实难解
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010261)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(cm.smcost)
	e3:SetTarget(cm.smtg)
	e3:SetOperation(cm.smop)
	c:RegisterEffect(e3)
end
function cm.bsfil(c)
	return c:IsCode(60010262,60010263,60010264,60010265) and c:IsFaceup()
end
function cm.bsfil1(c)
	return c:IsCode(60010263) and c:IsFaceup()
end
function cm.bsfil2(c)
	return c:IsCode(60010264) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.IsExistingMatchingCard(cm.bsfil,tp,LOCATION_SZONE,0,1,nil)
end
function cm.filter(c)
	return aux.IsCodeListed(c,60010261) and c:IsDiscardable()
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.filter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local t=0
		local mg=Duel.GetOperatedGroup()
		if Duel.IsExistingMatchingCard(cm.bsfil1,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local g=Duel.GetMatchingGroup(cm.bsfil1,tp,LOCATION_SZONE,0,nil)
			if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
				local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
				local tg=cg:GetMinGroup(Card.GetAttack)
				if tg:GetCount()>1 then
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
					local sg=tg:Select(1-tp,1,1,nil)
					Duel.HintSelection(sg)
					Duel.Destroy(sg,REASON_RULE)
				else Duel.Destroy(tg,REASON_RULE) end
			end
		end
		if Duel.IsExistingMatchingCard(cm.bsfil2,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local g=Duel.GetMatchingGroup(cm.bsfil2,tp,LOCATION_SZONE,0,nil)
			if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
				local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
				local tg=g:GetMinGroup(Card.GetDefense)
				if tg:GetCount()>1 then
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
					local sg=tg:Select(1-tp,1,1,nil)
					Duel.HintSelection(sg)
					Duel.Destroy(sg,REASON_RULE)
				else Duel.Destroy(tg,REASON_RULE) end
			end
		end
		if t~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end

function cm.smter(c,tp)
	return c:IsFaceup() and c:IsCode(60010261) and Duel.IsExistingMatchingCard(cm.smter2,tp,LOCATION_MZONE,0,1,c,c:GetAttribute())
end
function cm.smter2(c,attr)
	return c:IsFaceup() and not c:IsAttribute(attr)
end
function cm.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smter,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.smter,tp,LOCATION_MZONE,0,1,nil,tp) then return end
	local tc=Duel.SelectMatchingCard(tp,cm.smter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local sc=Duel.SelectMatchingCard(tp,cm.smter2,tp,LOCATION_MZONE,0,1,1,nil,tc:GetAttribute()):GetFirst()
	if not sc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(0xff)
	e1:SetValue(sc:GetAttribute())
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	tc:RegisterEffect(e1)
end





