local m=15000317
local cm=_G["c"..m]
cm.name="人间的锁链"
function cm.initial_effect(c)
	--aux.AddCodeList(c,15000316)
	--aux.AddRitualProcGreater(c,aux.FilterBoolFunction(Card.IsCode,15000316))
	aux.AddRitualProcGreaterCode(c,15000316)
	--Announce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.antg)
	e1:SetOperation(cm.anop)
	c:RegisterEffect(e1)
end
function cm.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,15000317)~=0 then
			local x=0
			for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
				x=x+1
			end
			if x==7 then return false end
		end
	return true end
end
function cm.anop(e,tp,eg,ep,ev,re,r,rp)
	local b1=0
	local b2=0
	local b3=0
	local b4=0
	local b5=0
	local b6=0
	local b7=0
	if Duel.GetFlagEffect(tp,15000317)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000317)} do
			if i==1 then b1=1 end
			if i==2 then b2=2 end
			if i==3 then b3=3 end
			if i==4 then b4=4 end
			if i==5 then b5=5 end
			if i==6 then b6=6 end
			if i==7 then b7=7 end
		end
	end
	local off=1
	local ops={}
	local opval={}
	if b1~=1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2~=2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if b3~=3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if b4~=4 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	if b5~=5 then
		ops[off]=aux.Stringid(m,4)
		opval[off-1]=5
		off=off+1
	end
	if b6~=6 then
		ops[off]=aux.Stringid(m,5)
		opval[off-1]=6
		off=off+1
	end
	if b7~=7 then
		ops[off]=aux.Stringid(m,6)
		opval[off-1]=7
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	Duel.RegisterFlagEffect(tp,15000317,RESET_PHASE+PHASE_END,0,1,sel)
end