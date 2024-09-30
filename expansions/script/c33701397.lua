--血本无归
local m=33701387
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COIN+CATEGORY_DRAW+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCondition(cm.cocon)
	e2:SetTarget(cm.cotg)
	e2:SetOperation(cm.coop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TOSS_COIN)
		ge1:SetProperty(EFFECT_FLAG_DELAY)
		ge1:SetOperation(cm.tossop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TOSS_DICE)
		ge2:SetOperation(cm.diceop)
		Duel.RegisterEffect(ge2)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(cm.clear)
		Duel.RegisterEffect(ge3,0)
	end
	
end
cm.toss_coin=true
function cm.cocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)==0
end
function cm.cotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function cm.coop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	if coin~=res then
		local t1=Duel.IsPlayerCanDraw(tp)
		local op=0
		local m={}
		local n={}
		local ct=1
		if t1 then m[ct]=aux.Stringid(m,1) n[ct]=1 ct=ct+1 end
		m[ct]=aux.Stringid(m,2) n[ct]=2 ct=ct+1
		local sp=Duel.SelectOption(tp,table.unpack(m))
		op=n[sp+1]
		Duel.BreakEffect()
		if op==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		else op==2 then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	else
		c:RegisterFlagEffect(c,m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	if tp:GetFlagEffect()<=0 then
		Duel.RegisterFlagEffect(c,m,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(cm.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if cm[tp]>=3 then
		Duel.Hint(HINT_CARD,1,m)
		if Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,cm[tp]*2,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function cm.tossop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==e:GetHandlerPlayer() then
		for i=1,ev do
			cm[0]=cm[0]+1
		end
	else
		for i=1,ev do
			cm[1]=cm[1]+1
		end
	end
end
function cm.diceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=bit.band(ev,0xffff)
	local ct2=bit.rshift(ev,16)
	if ep==e:GetHandlerPlayer() then
		for i=1,ct1 do
			cm[0]=cm[0]+1
		end
		for i=1,ct2 do
			cm[1]=cm[1]+1
		end
	else
		for i=1,ct2 do
			cm[0]=cm[0]+1
		end
		for i=1,ct1 do
			cm[1]=cm[1]+1
		end
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
