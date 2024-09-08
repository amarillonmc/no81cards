--血染之月
local m=30005309
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.jcon)
	e2:SetOperation(cm.jop)
	c:RegisterEffect(e2)
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(cm.sdcon)
	c:RegisterEffect(e1)
	--all
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCondition(cm.tcon)
		ge1:SetOperation(cm.top)
		Duel.RegisterEffect(ge1,0)
		local ge11=Effect.CreateEffect(c)
		ge11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge11:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge11:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge11,0)
	end
end
--all
function cm.kf(c) 
	local se=c:GetReasonEffect()
	local b1=c:GetFlagEffect(m)>0
	return b1 or (se and se~=nil and se:GetHandler():GetCode()==m)
end 
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	local sp=Duel.GetTurnPlayer()
	local g=Duel.GetMatchingGroup(cm.kf,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return  Duel.GetFlagEffect(sp,m+100)>0 and #g>0
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.kf,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil):Filter(Card.IsAbleToDeck,nil)
	if #g==0  then return false end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetOriginalType()&TYPE_TRAP==0 then 
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m+m,RESET_PHASE+PHASE_END,0,2)
		end
		tc=eg:GetNext()
	end
end
--Effect 1
function cm.ff(c,rp) 
	if c:GetPreviousLocation()~=LOCATION_DECK then return false end
	local se=c:GetReasonEffect()
	if (se and se~=nil and se:GetHandler():GetCode()==m) then return false end
	if c:GetFlagEffect(m)>0 then return false end
	local ap=c:GetPreviousControler()
	local b1= c:GetReasonPlayer()==ap
	local b2= rp==ap
	return c:GetLocation()~=LOCATION_SZONE and (b1 or b2)  
end 
function cm.tf(c,tp) 
	return c:GetReasonPlayer()==tp
end 
function cm.rf(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local rg=eg:Filter(cm.ff,nil,rp)
	if #rg==0 then 
		return false 
	else 
		return true
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local rg=eg:Filter(cm.ff,nil,rp)
	if not rg or rg==nil or #rg==0 then return end
	local act=rg:FilterCount(cm.tf,nil,tp)
	local bct=rg:FilterCount(cm.tf,nil,1-tp)
	local sp
	local ct
	local tg
	local og
	local tup=Duel.GetTurnPlayer()
	if act>0 then
		sp=tp
		ct=act
		tg=Duel.GetDecktopGroup(sp,ct*3)
		if #tg>Duel.GetFieldGroupCount(sp,LOCATION_DECK,0) then 
			tg=Duel.GetFieldGroup(sp,LOCATION_DECK,0) 
		end
		if tg:FilterCount(cm.rf,nil,sp)~=ct*3 then return false end
		Duel.DisableShuffleCheck()
		if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og>0 then 
			for tc in aux.Next(og) do  
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
			end  
		end   
		Duel.RegisterFlagEffect(tup,m+100,RESET_PHASE+PHASE_END,0,1)
	end
	if bct>0 then
		sp=1-tp
		ct=bct
		tg=Duel.GetDecktopGroup(sp,ct*3)
		if #tg>Duel.GetFieldGroupCount(sp,LOCATION_DECK,0) then 
			tg=Duel.GetFieldGroup(sp,LOCATION_DECK,0) 
		end
		if tg:FilterCount(cm.rf,nil,sp)~=ct*3 then return false end
		Duel.DisableShuffleCheck()
		if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og>0 then 
			for tc in aux.Next(og) do  
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
			end  
		end   
		Duel.RegisterFlagEffect(tup,m+100,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.AdjustAll()
end
--Effect 2
function cm.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(e:GetHandlerPlayer(),m+m)
	return ct>3
end
--??
function cm.jf(c) 
	return c:IsLocation(LOCATION_SZONE) and c:IsPreviousLocation(LOCATION_DECK)
end 
function cm.of(c,tp) 
	return c:GetOwner()==tp
end 
function cm.jcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.jf,1,nil)
end
function cm.jop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.jf,nil)
	if #g==0 then return  end
	local ag=g:Filter(cm.of,nil,tp)
	local bg=g:Filter(cm.of,nil,1-tp)
	local sp
	local ct
	local tg
	local zg
	if #ag>0 then
		sp=tp
		ct=#ag
		zg=ag
		tg=Duel.GetDecktopGroup(sp,ct*3)
		if #tg>Duel.GetFieldGroupCount(sp,LOCATION_DECK,0) then 
			tg=Duel.GetFieldGroup(sp,LOCATION_DECK,0) 
		end
		if tg:FilterCount(cm.rf,nil,sp)~=ct*2 then return false end
		Duel.DisableShuffleCheck()
		if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og>0 then 
			for tc in aux.Next(og) do  
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
			end  
		end   
		Duel.RegisterFlagEffect(tup,m+100,RESET_PHASE+PHASE_END,0,1)
	end
	if #bg>0 then
		sp=1-tp
		ct=#bg
		zg=bg
		tg=Duel.GetDecktopGroup(sp,ct*3)
		if #tg>Duel.GetFieldGroupCount(sp,LOCATION_DECK,0) then 
			tg=Duel.GetFieldGroup(sp,LOCATION_DECK,0) 
		end
		if tg:FilterCount(cm.rf,nil,sp)~=ct*2 then return false end
		Duel.DisableShuffleCheck()
		if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og>0 then 
			for tc in aux.Next(og) do  
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
			end  
		end   
		Duel.RegisterFlagEffect(tup,m+100,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.AdjustAll()
end