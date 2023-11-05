--归墟奇裂点
local m=30015035
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--activate
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_ACTIVATE)
	e30:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e30)
	--Effect 1  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(30015035)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--Effect 2 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(2)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)	
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
c30015035.isoveruins=true
--
function cm.ff(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsCode(30015037)
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
--Effect 2
function cm.filter(c)
	local b1=ors.stf(c) or c:IsLevelAbove(5)
	local b2=c:IsSummonable(true,nil) or c:IsMSetable(true,nil) 
	return b1 and b2
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	ors.sumop(e,tp,g)
	local res=1
	ors.exrmop(e,tp,res)
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