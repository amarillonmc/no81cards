local m=15000316
local cm=_G["c"..m]
cm.name="异界神明"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,15000317)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	if not cm.God_check then
		cm.God_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.regspop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TO_HAND)
		ge2:SetOperation(cm.regthop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_REMOVE)
		ge3:SetOperation(cm.regrmop)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_RECOVER)
		ge4:SetOperation(cm.regrcop)
		Duel.RegisterEffect(ge4,0)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_MSET)
		ge5:SetOperation(cm.regsetop)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge5:Clone()
		ge6:SetCode(EVENT_SSET)
		Duel.RegisterEffect(ge6,0)
		local ge7=Effect.CreateEffect(c)
		ge7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge7:SetCode(EVENT_CHAIN_NEGATED)
		ge7:SetOperation(cm.regneop)
		Duel.RegisterEffect(ge7,0)
		local ge8=ge7:Clone()
		ge8:SetCode(EVENT_CHAIN_DISABLED)
		Duel.RegisterEffect(ge8,0)
	end
end
function cm.spcfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.regspop(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(cm.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.spcfilter,1,nil,1) then v=v+2 end
	Duel.RegisterFlagEffect(0,1,RESET_PHASE+PHASE_END,0,1,({0,1,PLAYER_ALL})[v])
end
function cm.thcfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:IsLocation(LOCATION_HAND) and not c:IsReason(REASON_DRAW)
end
function cm.regthop(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(cm.thcfilter,nil,0)
	local bg=eg:Filter(cm.thcfilter,nil,1)
	local ac=ag:GetFirst()
	while ac do
		Duel.RegisterFlagEffect(0,2,RESET_PHASE+PHASE_END,0,1,0)
		ac=ag:GetNext()
	end
	local bc=ag:GetFirst()
	while bc do
		Duel.RegisterFlagEffect(0,2,RESET_PHASE+PHASE_END,0,1,1)
		bc=ag:GetNext()
	end
end
function cm.rmcfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsLocation(LOCATION_REMOVED) and c:IsReason(REASON_EFFECT)
end
function cm.regrmop(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(cm.thcfilter,nil,0)
	local bg=eg:Filter(cm.thcfilter,nil,1)
	local ac=ag:GetFirst()
	while ac do
		Duel.RegisterFlagEffect(0,3,RESET_PHASE+PHASE_END,0,1,0)
		ac=ag:GetNext()
	end
	local bc=ag:GetFirst()
	while bc do
		Duel.RegisterFlagEffect(0,3,RESET_PHASE+PHASE_END,0,1,1)
		bc=ag:GetNext()
	end
end
function cm.regrcop(e,tp,eg,ep,ev,re,r,rp)
	if ep==0 or ep==PLAYER_ALL then
		Duel.RegisterFlagEffect(0,40,RESET_PHASE+PHASE_END,0,1,0)
		Duel.RegisterFlagEffect(0,41,RESET_PHASE+PHASE_END,0,1,ev)
	end
	if ep==1 then
		Duel.RegisterFlagEffect(0,42,RESET_PHASE+PHASE_END,0,1,1)
		Duel.RegisterFlagEffect(0,43,RESET_PHASE+PHASE_END,0,1,ev)
	end
end
function cm.setcfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsFacedown()
end
function cm.regsetop(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(cm.setcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.setcfilter,1,nil,1) then v=v+2 end
	Duel.RegisterFlagEffect(0,5,RESET_PHASE+PHASE_END,0,1,({0,1,PLAYER_ALL})[v])
end
function cm.regneop(e,tp,eg,ep,ev,re,r,rp)
	local dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER)
	local ap=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER)
	local v=dp+1
	local s=ap+1
	Duel.RegisterFlagEffect(0,6,RESET_PHASE+PHASE_END,0,1,({0,1,PLAYER_ALL})[v])
	Duel.RegisterFlagEffect(0,7,RESET_PHASE+PHASE_END,0,1,({0,1,PLAYER_ALL})[s])
end
--------
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=true
	local b3=true
	local b4=true
	local b5=true
	local b6=true
	local b7=true
	if Duel.GetFlagEffect(0,1)~=0 then
		local x=0
		for _,i in ipairs{Duel.GetFlagEffectLabel(0,1)} do
			if i==1-tp or i==PLAYER_ALL then x=x+1 end
		end
		if Duel.GetFlagEffect(tp,15000317)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
				if i==1 then x=0 end
			end
		end
		if x>=10 then b1=false end
	end
	if Duel.GetFlagEffect(0,2)~=0 then
		local x=0
		for _,i in ipairs{Duel.GetFlagEffectLabel(0,2)} do
			if i==1-tp or i==PLAYER_ALL then x=x+1 end
		end
		if Duel.GetFlagEffect(tp,15000317)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
				if i==2 then x=0 end
			end
		end
		if x>=5 then b2=false end
	end
	if Duel.GetFlagEffect(0,3)~=0 then
		local x=0
		for _,i in ipairs{Duel.GetFlagEffectLabel(0,3)} do
			if i==1-tp or i==PLAYER_ALL then x=x+1 end
		end
		if Duel.GetFlagEffect(tp,15000317)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
				if i==3 then x=0 end
			end
		end
		if x>=5 then b3=false end
	end
	if Duel.GetFlagEffect(0,40)~=0 or Duel.GetFlagEffect(0,42)~=0 then
		local x=0
		if Duel.GetFlagEffect(0,40)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(0,40)} do
				if i==1-tp or i==PLAYER_ALL then
					for _,i in ipairs{Duel.GetFlagEffectLabel(0,41)} do
						x=x+i
					end
				end
			end
		end
		if Duel.GetFlagEffect(0,42)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(0,42)} do
				if i==1-tp or i==PLAYER_ALL then
					for _,i in ipairs{Duel.GetFlagEffectLabel(0,43)} do
						x=x+i
					end
				end
			end
		end
		if Duel.GetFlagEffect(tp,15000317)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
				if i==4 then x=0 end
			end
		end
		if x>=2000 then b4=false end
	end
	if Duel.GetFlagEffect(0,5)~=0 then
		local x=0
		for _,i in ipairs{Duel.GetFlagEffectLabel(0,5)} do
			if i==1-tp or i==PLAYER_ALL then x=x+1 end
		end
		if Duel.GetFlagEffect(tp,15000317)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
				if i==5 then x=0 end
			end
		end
		if x>=3 then b5=false end
	end
	if Duel.GetFlagEffect(0,6)~=0 then
		local x=0
		for _,i in ipairs{Duel.GetFlagEffectLabel(0,6)} do
			if i==1-tp or i==PLAYER_ALL then x=x+1 end
		end
		if Duel.GetFlagEffect(tp,15000317)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
				if i==6 then x=0 end
			end
		end
		if x>=5 then b6=false end
	end
	if Duel.GetFlagEffect(0,7)~=0 then
		local x=0
		for _,i in ipairs{Duel.GetFlagEffectLabel(0,7)} do
			if i==1-tp or i==PLAYER_ALL then x=x+1 end
		end
		if Duel.GetFlagEffect(tp,15000317)~=0 then
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
				if i==7 then x=0 end
			end
		end
		if x>=2 then b7=false end
	end
	return b1 and b2 and b3 and b4 and b5 and b6 and b7 and c:IsSummonType(SUMMON_TYPE_RITUAL) and Duel.GetTurnPlayer()~=tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,0))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,1))
	local WIN_REASON_DIVINITY_FOREIGN = 0x4
	Duel.Win(tp,WIN_REASON_DIVINITY_FOREIGN)
end