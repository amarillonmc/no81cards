--归墟熵落点
local m=30015037
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.immtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Effect 2 
	local e23=Effect.CreateEffect(c)
	e23:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e23:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e23:SetCode(EVENT_ATTACK_ANNOUNCE)
	e23:SetRange(LOCATION_FZONE)
	e23:SetCountLimit(2)
	e23:SetCondition(cm.spacon)
	e23:SetTarget(cm.spatg)
	e23:SetOperation(cm.spaop)
	c:RegisterEffect(e23)
	--Effect 3 
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.orscon)
	e21:SetTarget(cm.orstg)
	e21:SetOperation(cm.orsop)
	c:RegisterEffect(e21)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_REMOVE)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e32:SetCode(EVENT_CHAIN_NEGATED)
	e32:SetProperty(EFFECT_FLAG_DELAY)
	e32:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e32:SetCondition(cm.tthcon)
	e32:SetTarget(cm.tthtg)
	e32:SetOperation(cm.tthop)
	c:RegisterEffect(e32)
	local e33=e32:Clone()
	e33:SetCode(EVENT_CUSTOM+30015500)
	e33:SetCondition(cm.tthcon2)
	c:RegisterEffect(e33)
	--all
	local ge1=ors.allop2(c)
end
c30015037.isoveruins=true
--
function cm.ff(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsCode(30015035)
		and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48934760,0))
	local tc=Duel.SelectMatchingCard(tp,cm.ff,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
--Effect 1
function cm.immtg(e,c)
	return ors.stf(c) 
end
--Effect 2
---
function cm.spacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil
end
function cm.smf(c)
	if not c:IsType(TYPE_MONSTER) or c:IsExtraDeckMonster() then return false end
	local b0=ors.stf(c) or c:IsLevelAbove(5)
	local b1=c:IsFacedown()
	local b2=c:IsSummonableCard()
	local b3=c:IsAbleToHand()
	return b0 and b1 and b2 and b3
end
function cm.spatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smf,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
end
function cm.spaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	local g=xg:Filter(cm.smf,nil)
	if #g==0 then return false end
	local sg=g:FilterSelect(tp,cm.smf,1,1,nil)
	local tc=sg:GetFirst()
	if #sg==0 or Duel.SendtoHand(sg,nil,REASON_EFFECT)==0 or tc:GetLocation()~=LOCATION_HAND then return false end
	Duel.ConfirmCards(1-tp,tc)
	if not ors.sumchk(tc) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	else
		if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil)
			or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
			Duel.Summon(tp,tc,true,nil)
		else Duel.MSet(tp,tc,true,nil) end
	end
end
--Effect 3 
function cm.orscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.orstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				Duel.SetTargetCard(sc)
				sg:AddCard(sc)
			end
		end 
		if rc then 
			Duel.SetTargetCard(rc)
			sg:AddCard(rc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.orsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if ct==1 then
		local sc=Duel.GetFirstTarget() 
		local exchk=2
		Duel.Hint(HINT_CARD,0,m)
		local b1=sc:IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
		local b2=sc:IsRelateToEffect(e) 
		local b3=sc:GetControler()==1-tp
		local b4=sc:IsAbleToRemove(tp,POS_FACEDOWN)
		local b5=not sc:IsType(TYPE_TOKEN)
		if b1 and b2 and b3 and b4 and b5 then
			Duel.BreakEffect()
			Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
			local org=Duel.GetOperatedGroup()
			if org:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
				exchk=1
			end
		end
		local ag=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_DECK,0,nil,tp)
		if exchk==0 or #ag==0 then return false end
		Duel.BreakEffect()
		cm.activate(e,tp,eg,ep,ev,re,r,rp)
	end
end
--negop--
function cm.tthcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	local dc=de:GetHandler()
	if de and de~=nil and dc:IsControler(1-tp) then
		e:SetLabelObject(dc)
	end
	return rp==tp and de and de~=nil and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function cm.tthcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end
function cm.tthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(30015500)
	local dc=e:GetLabelObject()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		Duel.SetTargetParam(1) 
	end
	if dc and dc~=nil then
		Duel.SetTargetCard(dc)
		sg:AddCard(dc)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.tthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=e:GetLabelObject()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if dc and dc~=nil then
		local sc=Duel.GetFirstTarget() 
		local exchk=2
		Duel.Hint(HINT_CARD,0,m)
		local b1=sc:IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
		local b2=sc:IsRelateToEffect(e) 
		local b3=sc:GetControler()==1-tp
		local b4=sc:IsAbleToRemove(tp,POS_FACEDOWN)
		local b5=not sc:IsType(TYPE_TOKEN)
		if b1 and b2 and b3 and b4 and b5 then
			Duel.BreakEffect()
			Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
			local org=Duel.GetOperatedGroup()
			if org:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
				exchk=1
			end
		end
		local ag=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_DECK,0,nil,tp)
		if exchk==0 or #ag==0 then return false end
		Duel.BreakEffect()
		cm.activate(e,tp,eg,ep,ev,re,r,rp)
	end
end