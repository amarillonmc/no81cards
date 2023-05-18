local m=82209045
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--cannot be target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_PZONE,0)  
	e2:SetTarget(cm.tgtg)  
	e2:SetValue(aux.indoval)  
	c:RegisterEffect(e2)  
	--draw  
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_DRAW)  
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)  
	e5:SetCountLimit(1,m)   
	e5:SetCost(cm.drcost)  
	e5:SetTarget(cm.drtg)  
	e5:SetOperation(cm.drop)  
	c:RegisterEffect(e5) 
	--draw2  
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)  
	e6:SetType(EFFECT_TYPE_IGNITION)  
	e6:SetRange(LOCATION_SZONE)  
	e6:SetCountLimit(1,m) 
	e6:SetTarget(cm.drtg2)  
	e6:SetOperation(cm.drop2)  
	c:RegisterEffect(e6) 
end
cm.SetCard_01_Kieju=true
function cm.isKieju(code)
	local ccode=_G["c"..code]
	return ccode.SetCard_01_Kieju
end
function cm.tgtg(e,c)  
	return cm.isKieju(c:GetCode())
end  
function cm.drfilter(c)
	return cm.isKieju(c:GetCode()) and c:IsReleasable()
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) 
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil) end
	if ct>2 then ct=2 end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE) 
	local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,ct,nil)  
	local rct=Duel.Release(g,REASON_COST)  
	e:SetLabel(rct)  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(e:GetLabel()) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)  
end  
function cm.drfilter2(c)
	return cm.isKieju(c:GetCode()) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.drfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,4,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK) 
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.drfilter2),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,4,4,nil)  
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end  