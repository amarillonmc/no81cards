--物为群分
local m=33701406
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.fselect(g)
	return (g:GetClassCount(Card.GetRace())==g:GetCount() and g:GetClassCount(Card.GetAttribute())==g:GetCount())
	or (g:GetClassCount(Card.GetRace())==1)
	or (g:GetClassCount(Card.GetAttribute())==1)
end
function cm.fselect1(g,op)
	return (op==0 and g:GetClassCount(Card.GetRace())==g:GetCount() and g:GetClassCount(Card.GetAttribute())==g:GetCount())
	or (op==1 and g:GetClassCount(Card.GetRace())==1)
	or (op==2 and g:GetClassCount(Card.GetAttribute())==1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	return g:CheckSubGroup(cm.fselect,1,15)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local mg=g:SelectSubGroup(tp,cm.fselect,false,1,15)
	local op=0
	local ct=mg:GetCount()
	if mg:GetClassCount(Card.GetRace())==mg:GetCount() and mg:GetClassCount(Card.GetAttribute())==mg:GetCount() then op=0
	elseif mg:GetClassCount(Card.GetRace())==1 then op=1
	elseif mg:GetClassCount(Card.GetAttribute())==1 then op=2 end
	Duel.ConfirmCards(1-tp,mg)
	local g1=Duel.GetMatchingGroup(cm.filter,1-tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g1:CheckSubGroup(cm.fselect1,ct,ct,op) and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then 
		local mg1=g:SelectSubGroup(tp,cm.fselect,false,ct,ct)
		Duel.ConfirmCards(tp,mg1)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
	else
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
