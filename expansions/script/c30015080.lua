--归墟塌陷
local m=30015080
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--activate
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_ACTIVATE)
	e30:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e30)
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(cm.sdcon)
	c:RegisterEffect(e1)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--Effect 2  
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(cm.rstcon)
	e12:SetOperation(cm.rstop)
	c:RegisterEffect(e12)
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
end
c30015080.isoveruins=true
--maintain
function cm.ff(c) 
	return c:IsFaceup() and ors.stf(c) 
end 
function cm.sdcon(e)
	local g=Duel.GetMatchingGroup(cm.ff,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return #g==0
end
--Effect 1
function cm.cfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.mrf(c) 
	local b1=c:IsAbleToRemove(tp,POS_FACEDOWN) 
	local b2=c:IsLocation(LOCATION_GRAVE)
	return b1 and b2 
end   
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.cfilter,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local og=Group.CreateGroup()
	local g=eg:Filter(cm.cfilter,nil)
	local tc=g:GetFirst()
	while tc do
		if cm.mrf(tc) then
			if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)>0 
				and tc:IsLocation(LOCATION_REMOVED) then
				tc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
				og:AddCard(tc)
			end
		end
		tc=g:GetNext()
	end
	if #og==0 then return false end
	Duel.Recover(tp,#og*150,REASON_EFFECT)
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(og)
	e1:SetOperation(cm.retop)
	Duel.RegisterEffect(e1,tp)
end
function cm.retfilter(c)
	return c:GetFlagEffect(m+100)>0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.retfilter,nil)
	if #sg==0 then return false end
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
end
--Effect 2
function cm.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(ors.ofm,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return ct>0 
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(ors.ofm,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.Hint(HINT_CARD,0,m)
	local dct=0
	local rct=0
	if ct*300>1800 then 
		dct=1800
	else
		dct=ct*300 
	end
	if ct*500>3600 then 
		rct=3600
	else
		rct=ct*500 
	end
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-dct)
	Duel.Recover(tp,rct,REASON_EFFECT) 
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
		ors.ptorm(e,tp,sc,exchk)
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
		ors.ptorm(e,tp,sc,exchk)
	end
end