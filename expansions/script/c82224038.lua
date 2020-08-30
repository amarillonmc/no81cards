local m=82224038
local cm=_G["c"..m]
cm.name="昔兰尼加"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)  
	c:EnableReviveLimit() 
	--extra summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCondition(cm.con)   
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1) 
end
function cm.lcheck(g,lc)  
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.BreakEffect()  
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)  
	end  
end  