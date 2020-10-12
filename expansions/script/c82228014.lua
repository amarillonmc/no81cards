function c82228014.initial_effect(c)  
	--destroy 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228014,0))   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)   
	e1:SetCountLimit(1,82228014)  
	e1:SetCategory(CATEGORY_DRAW)   
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)   
	e1:SetTarget(c82228014.target)  
	e1:SetOperation(c82228014.activate) 
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e2)
end  

function c82228014.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function c82228014.activate(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  