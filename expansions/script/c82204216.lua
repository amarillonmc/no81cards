local m=82204216
local cm=_G["c"..m]
cm.name="堕世魔镜-极欲"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.actcon)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end  
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)   
	local tp=e:GetHandler():GetControler() 
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)~=0 
end
function cm.chainfilter(re,tp,cid)  
	return not (re:GetHandler():IsSetCard(0x3298) and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(2)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  