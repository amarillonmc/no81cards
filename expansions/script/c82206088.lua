local m=82206088
local cm=_G["c"..m]
cm.name="混沌界王"
function cm.initial_effect(c)
	--instant 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DAMAGE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.intg)  
	e1:SetOperation(cm.inop)  
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e11)
	--delayed 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_DAMAGE)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost) 
	e2:SetOperation(cm.deop)  
	c:RegisterEffect(e2)
	local e21=e2:Clone()
	e21:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e21)
	--special summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_SPSUMMON_PROC)  
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e3:SetRange(LOCATION_HAND)  
	e3:SetCountLimit(1,m+10000)  
	e3:SetCondition(cm.spcon)  
	c:RegisterEffect(e3) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())  
end  
function cm.intg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(1000)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)  
end  
function cm.inop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Damage(p,d,REASON_EFFECT)  
end  
function cm.decon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp  
end 
function cm.deop(e,tp,eg,ep,ev,re,r,rp)  
	local e2=Effect.CreateEffect(e:GetHandler()) 
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)  
	e2:SetCountLimit(1)   
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)  
	e2:SetCondition(cm.decon)
	e2:SetOperation(cm.deop2)  
	Duel.RegisterEffect(e2,tp)   
end  
function cm.deop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,m)
	Duel.Damage(1-tp,2000,REASON_EFFECT)  
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x29b) and not c:IsCode(m)  
end  
function cm.spcon(e,c)  
	if c==nil then return true end  
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)  
end  