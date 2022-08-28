--永夏的零落
local m=11451639
local cm=_G["c"..m]
function cm.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(cm.flag)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.chcon)
	e1:SetTarget(cm.chtg)
	e1:SetOperation(cm.chop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_DECK)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_REMOVED) and tc:IsPreviousPosition(POS_FACEDOWN) then
			Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) or ((re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(0,m)>=3 and Duel.IsExistingMatchingCard(cm.filter,rp,LOCATION_REMOVED,0,1,nil) end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
	local ph,ph2=Duel.GetCurrentPhase(),Duel.GetCurrentPhase()
	if ph==PHASE_BATTLE then ph2=PHASE_BATTLE_STEP else ph2=PHASE_END end
	if Duel.GetFlagEffect(0,m)>=7 then Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE+ph2,1) end
end
function cm.filter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end