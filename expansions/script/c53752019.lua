local m=53752019
local cm=_G["c"..m]
cm.name="莉莉·林德"
function cm.initial_effect(c)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,1)
		ge1:SetTarget(cm.costtg)
		ge1:SetOperation(cm.costop)
		Duel.RegisterEffect(ge1,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BE_MATERIAL)
		ge3:SetCondition(cm.matcon)
		ge3:SetOperation(cm.matop)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.costtg(e,te,tp)
	local rc=te:GetHandler()
	return rc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and rc:GetFlagEffect(m)>0
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local ge1=Effect.CreateEffect(e:GetHandler())
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_SOLVING)
	ge1:SetLabel(Duel.GetCurrentChain()+1)
	ge1:SetOperation(cm.disop)
	ge1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(ge1,tp)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if ev~=e:GetLabel() then return end
	local dg=Duel.GetMatchingGroup(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,nil)
	if Duel.GetFlagEffect(0,m)>0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,aux.NULL)
	elseif #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,aux.NULL)
		local sg=dg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1)
	end
end
function cm.cfilter(c,r)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) and r==REASON_SYNCHRO
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,r)
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,r)
	g:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,0,0)
end
