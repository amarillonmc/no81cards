--风凌号 赫尔墨斯翌
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddXyzProcedure(c,nil,7,2,s.mfilter,aux.Stringid(id,0),2,s.altop)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.con)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.discost)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.chkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.mfilter(c,e,tp)
	return c:IsLevelBelow(4)
end
function s.altop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+10000)==0 and Duel.GetFlagEffect(tp,id+10000+200)>0 end
	Duel.RegisterFlagEffect(tp,id+10000,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.chkop(e,tp,eg,ep,ev,re,r,rp)
	if ev>=3 then
		for i=1,ev do
			local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if tgp~=ep then return end
		end
		Duel.RegisterFlagEffect(1-ep,id+10000+200,RESET_PHASE+PHASE_END,0,2)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local number=0
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp==1-tp then number=number+1 end
	end
	return number>=2
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1,g2,g3=Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if te:GetHandler():IsLocation(LOCATION_HAND) and tgp==1-tp and Duel.IsChainDisablable(i) then g1:AddCard(te:GetHandler()) end
		if te:GetHandler():IsLocation(LOCATION_ONFIELD) and tgp==1-tp and te:GetHandler():IsRelateToEffect(te) and te:GetHandler():IsAbleToHand() then g2:AddCard(te:GetHandler()) end
		if te:GetHandler():IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and tgp==1-tp and te:GetHandler():IsRelateToEffect(te) and te:GetHandler():IsCanOverlay() and not te:GetHandler():IsImmuneToEffect(e) then g3:AddCard(te:GetHandler()) end
	end
	if chk==0 then return #(g1+g2+g3)>0 end
	e:SetCategory(0)
	if #g1>0 then
		e:SetCategory(e:GetCategory()|CATEGORY_NEGATE)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,g1,#g1,0,0)
	end
	if #g2>0 then
		e:SetCategory(e:GetCategory()|CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,#g2,0,0)
	end
	if g3:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g3:Filter(Card.IsLocation,nil,LOCATION_GRAVE),g3:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE),0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for i=1,ev do
		local te,tgp,loc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
		local tc=te:GetHandler()
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		if tc~=nil then
			if tc:IsLocation(LOCATION_HAND) and tgp==1-tp then Duel.NegateEffect(ev) end
			if tc:IsLocation(LOCATION_ONFIELD) and tc:IsRelateToEffect(te) and tgp==1-tp then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
			if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and tc:IsRelateToEffect(te) and not tc:IsImmuneToEffect(e) and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) and tgp==1-tp then Duel.Overlay(c,tc) end
		end
	end
end