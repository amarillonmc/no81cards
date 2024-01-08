--宇宙的极限 熵
local m=51351021
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0xa04)
	--disable 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.distg)
	c:RegisterEffect(e4)  
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--add count
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.addct)
	e2:SetOperation(cm.addc)
	c:RegisterEffect(e2)  
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
end
function cm.distg(e,c)
	local seq=e:GetHandler():GetSequence()
	local tp=e:GetHandlerPlayer()
	return aux.GetColumn(c,tp)==seq and c~=e:GetHandler()
end
--
function cm.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xa04)
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xa04,1)
	end
end
--Damage
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetHandler():GetCounter(0xa04)*500
	if dam>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end





