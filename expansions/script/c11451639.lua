--永夏的零落
local cm,m=GetID()
function cm.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.chcon)
	e1:SetTarget(cm.chtg)
	e1:SetOperation(cm.chop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(cm.imop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_DECK)
		ge1:SetOperation(cm.check)
		--Duel.RegisterEffect(ge1,0)
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_REMOVED) and tc:IsPreviousPosition(POS_FACEDOWN) and tc:IsLocation(LOCATION_DECK) then
			Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) or ((re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.thfilter(c)
	return c:GetCounter(0x6954)~=0 and c:IsAbleToHand()
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return Duel.GetFlagEffect(0,m)>=3 and Duel.IsExistingMatchingCard(cm.filter,rp,LOCATION_REMOVED,0,1,nil) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop2)
	--[[local ph,ph2=Duel.GetCurrentPhase(),Duel.GetCurrentPhase()
	if ph==PHASE_BATTLE then ph2=PHASE_BATTLE_STEP else ph2=PHASE_END end
	if Duel.GetFlagEffect(0,m)>=7 then Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE+ph2,1) end--]]
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
function cm.repop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.GetCounter(0,1,1,0x6954)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local ct2=Duel.GetCounter(0,1,1,0x6954)
		local dam=(ct-ct2)*700
		if dam>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-dam)
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-dam)
		end
	end
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	--inactivatable
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_INACTIVATE)
	e0:SetCondition(cm.flcon)
	e0:SetValue(cm.efilter)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.flcon)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x20000000+m)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
end
function cm.flcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0
end
function cm.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	if p==tp and te:IsActiveType(TYPE_MONSTER) and loc&LOCATION_HAND>0 then
		local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ct,CATEGORY_SPECIAL_SUMMON)
		if (ex1 and (g1==te:GetHandler() or g1:IsContains(te:GetHandler()))) then return true end
	end
	return false
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end