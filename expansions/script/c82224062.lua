local m=82224062
local cm=_G["c"..m]
cm.name="虚妄之梦"
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(3)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_DRAW)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	Duel.RegisterEffect(e1,p)
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_DRAW_COUNT)  
	e2:SetValue(0)  
	Duel.RegisterEffect(e2,p)  
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK)) 
	Duel.RegisterEffect(e3,p)
end  
