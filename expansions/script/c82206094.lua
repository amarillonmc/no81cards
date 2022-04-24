local m=82206094
local cm=_G["c"..m]
cm.name="六界祭坛"
function cm.initial_effect(c)
	--Activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e0) 
	--cannot be target  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e1:SetRange(LOCATION_FZONE)  
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x29b))  
	e1:SetValue(aux.tgoval)  
	c:RegisterEffect(e1)
	--Indes  
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e2:SetValue(aux.indoval)  
	c:RegisterEffect(e2) 
	--draw   
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCountLimit(1)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e4:SetCode(EVENT_CHAIN_SOLVING) 
	e4:SetRange(LOCATION_FZONE)  
	e4:SetCondition(cm.drcon)  
	e4:SetTarget(cm.drtg)  
	e4:SetOperation(cm.drop)  
	c:RegisterEffect(e4)  
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)   
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x29b)
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp,chk)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  