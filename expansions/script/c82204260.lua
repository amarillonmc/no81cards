local m=82204260
local cm=_G["c"..m]
cm.name="捕兽夹"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)   
	--destroy  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_DAMAGE)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e4:SetCondition(cm.atkcon)  
	e4:SetTarget(cm.atktg)  
	e4:SetOperation(cm.atkop)  
	c:RegisterEffect(e4)  
end
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x5299) 
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	Duel.Damage(p,Duel.GetFieldGroupCount(p,LOCATION_HAND,0)*500,REASON_EFFECT)  
end  