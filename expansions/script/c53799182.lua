local m=53799182
local cm=_G["c"..m]
cm.name="永不枯萎的思念"
function cm.initial_effect(c)
	bgmhandle(c,m,4,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(cm.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(cm.distarget)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(cm.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsDisabled,1,nil) then c:RegisterFlagEffect(m,RESET_EVENT+0x4fe0000,0,1) end
end
function cm.disable(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	if p==1-tp or tc:GetFlagEffect(m)==0 then return false end
	for _,st in ipairs{SUMMON_TYPE_RITUAL,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK} do
		if tc:IsSummonType(st) then return true end
	end
	return false
end
function cm.distarget(e,c)
	return c:GetFlagEffect(m)>0
end
function bgmhandle(c,code,count,bgmid,con,cost,tg,op)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	if con then e0:SetCondition(con) end
	e0:SetCost((cost and {cost} or {function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		if bgmid then Duel.Hint(HINT_MUSIC,0,aux.Stringid(code,bgmid)) end
	end})[1])
	if tg then e0:SetTarget(tg) end
	if op then e0:SetOperation(op) end
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetValue(function(e,re,tp)
		return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) end)
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(function(e,c)
		return c:IsType(TYPE_FIELD) end)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return tp==Duel.GetTurnPlayer() end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)   
		local c=e:GetHandler()
		if c:GetFlagEffect(1082946)==0 then
			c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,count)
			c:SetTurnCounter(0)
		end
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if ct>=count then
			Duel.SendtoGrave(c,REASON_RULE)
			c:ResetFlagEffect(1082946)
		end end)
	c:RegisterEffect(e0)
	c:RegisterEffect(e1)
	c:RegisterEffect(e2)
	c:RegisterEffect(e3)
	c:RegisterEffect(e4)
	_G["c"..code][c] = e1  
end
