--FREEDOM DIVE
local m=33711107
local cm=_G["c"..m]
function cm.initial_effect(c)
	cm[c]=0
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(1)
		if chk==0 then return true end
		local c=e:GetHandler()
		local op=Duel.SelectOption(tp,m*16,m*16+1)
		cm[c]=1-op
		if op==0 then
			c:SetEntityCode(m)
		else
			c:SetEntityCode(m+1)
		end
	end)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e2:SetTarget(cm.exstg)
	c:RegisterEffect(e2)  
	--ADD Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3) 
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetCategory(CATEGORY_DAMAGE)
	e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_1:SetRange(LOCATION_FZONE)
	e3_1:SetCode(EVENT_BATTLE_DAMAGE)
	e3_1:SetCondition(cm.damcon1)
	e3_1:SetOperation(cm.damop)
	c:RegisterEffect(e3_1)
	local e3_2=e3_1:Clone()
	e3_2:SetCode(EVENT_DAMAGE)
	e3_2:SetCondition(cm.damcon2)
	c:RegisterEffect(e3_2)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e4:SetTarget(cm.sumval)
	c:RegisterEffect(e4) 
	--Effect Draw
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DRAW_COUNT)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,1)
	e5:SetCondition(cm.drcon)
	e5:SetValue(2)
	c:RegisterEffect(e5)
	--recover
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_RECOVER)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(cm.rmcon)
	e6:SetOperation(cm.rmop)
	c:RegisterEffect(e6)
	--cannot summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_MSET)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(1,1)
	e7:SetTarget(cm.splimit)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e8)
end
function cm.exstg(e,c)
	return c:IsControler(cm[e:GetHandler()])
end
function cm.GetData(g,f)
	local v=0
	for tc in aux.Next(g) do
		v=v|f(tc)
	end
	return v
end
function cm.GetNorthPlayer(c,tp)
	--Debug.Message(cm[c])
	if cm[c]==0 then
		return tp
	else
		return 1-tp
	end
end
function cm.GetDataCount(g,f)
	local v=cm.GetData(g,f)
	local col=1
	local count=0
	while col<=v do
		if col&v>0 then count=count+1 end
		col=col<<1
	end
	return count
end
function cm.val(e,re,dam,r,rp,rc)
	local sp=cm.GetNorthPlayer(e:GetHandler(),e:GetHandlerPlayer())
	if rp==sp then
		return dam*2
	else
		return dam
	end
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local sp=cm.GetNorthPlayer(e:GetHandler(),tp)
	return Duel.GetLP(1-ep)>0 and rp==1-sp
end
function cm.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local sp=cm.GetNorthPlayer(e:GetHandler(),tp)
	return Duel.GetLP(1-ep)>0 and bit.band(r,REASON_BATTLE)==0 and re and re:GetHandlerPlayer()==1-sp and re:GetHandler()~=e:GetHandler() and ep~=rp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(ep,ev,REASON_EFFECT)
end
function cm.sumval(e,c)
	local sp=cm.GetNorthPlayer(e:GetHandler(),e:GetHandlerPlayer())
	return c:IsControler(sp)
end
function cm.drcon(e)
	return Duel.GetTurnPlayer()==1-cm.GetNorthPlayer(e:GetHandler(),e:GetHandlerPlayer())
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local sp=cm.GetNorthPlayer(e:GetHandler(),tp)
	return ep==1-sp and re:GetHandler()~=e:GetHandler()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	tp=cm.GetNorthPlayer(e:GetHandler(),tp)
	Duel.Recover(1-tp,ev,REASON_EFFECT)
end
function cm.splimit(e,c)
	local sp=cm.GetNorthPlayer(e:GetHandler(),e:GetHandlerPlayer())
	return c:IsControler(1-sp)
end