--djwcb
local m=14010317
local cm=_G["c"..m]
function cm.initial_effect(c)
	--effect gian
	local ef_1=Effect.CreateEffect(c)
	ef_1:SetType(EFFECT_TYPE_SINGLE)
	ef_1:SetCode(m)
	ef_1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	ef_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ef_1)
	local ef_2=Effect.CreateEffect(c)
	ef_2:SetType(EFFECT_TYPE_SINGLE)
	ef_2:SetCode(m+1000)
	ef_2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	ef_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ef_2)
	local ef_3=Effect.CreateEffect(c)
	ef_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ef_3:SetCode(EVENT_ADJUST)
	ef_3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	ef_3:SetOperation(cm.op)
	c:RegisterEffect(ef_3)
	cm[ef_3]={}
	--change name
	aux.EnableChangeCode(c,cm.cname,LOCATION_MZONE+LOCATION_GRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
	e2:SetValue(cm.defval)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Group.CreateGroup()
		cm[0]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.resetcount)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if cm[0]:GetCount()>0 then return end
	if tc:IsLocation(LOCATION_GRAVE) and not tc:IsReason(REASON_RETURN) then
		cm[0]:AddCard(tc)
	end
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]:Clear()
	--Debug.Message("reset")
end
function cm.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and not c:IsHasEffect(m)
end
function cm.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function cm.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(cm.gfilter2,1,nil,c:GetOriginalCode())
end
function cm.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=cm[e]
	local exg=Group.CreateGroup()
	for tc,cid in pairs(copyt) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=cm[0]:Filter(cm.copyfilter,nil,c)
	local dg=exg:Filter(cm.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end
	local cg=g:Filter(cm.gfilter1,nil,exg)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		e:SetCondition(cm.rcon(e:GetCondition(),tc,copyt))
		f(tc,e,forced)
	end
	for tc in aux.Next(cg) do
		local code=tc:GetOriginalCode()
		copyt[tc]=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-EVENT_TO_GRAVE,1)
	end
	Card.RegisterEffect=f
end
function cm.rcon(con,tc,copyt)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsHasEffect(m+1000) then
			c:ResetEffect(c,copyt[tc],RESET_COPY)
			copyt[tc]=nil
			return false
		end
		if not con or con(e,tp,eg,ep,ev,re,r,rp) then return true end
		return e:IsHasType(0x7e0) and c:GetFlagEffect(m)>0
	end
end
function cm.cname() 
	if cm[0] and #cm[0]>0 then 
		return cm[0]:GetFirst():GetOriginalCode()
	else
		return m
	end 
end
function cm.atkval(e,c)
	if cm[0] and #cm[0]>0 then 
		return cm[0]:GetFirst():GetBaseAttack()
	else
		return 0
	end
end
function cm.defval(e,c)
	if cm[0] and #cm[0]>0 then 
		return cm[0]:GetFirst():GetBaseDefense()
	else
		return 0
	end
end