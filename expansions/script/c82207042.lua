local m=82207042
local cm=c82207042

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYED)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(ct)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)  
end  

function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	if ct>0 then  
		Duel.Draw(p,ct,REASON_EFFECT)  
	end  
end  