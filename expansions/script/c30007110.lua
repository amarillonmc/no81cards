--拾荒僵尸
local m=30007110
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),2,2)
	c:EnableReviveLimit() 
	--set or draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function cm.tdfilter(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsType(TYPE_TRAP)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
	local a=g:IsExists(cm.tdfilter,1,nil) and g:GetCount()>2 and c:IsAbleToExtra() and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return a end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
end
function cm.gfilter(g)
	return g:IsExists(cm.tdfilter,1,nil)
end
function cm.sfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
	local a=g:IsExists(cm.tdfilter,1,nil) and g:GetCount()>2 and c:IsAbleToExtra() 
	if a then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g:SelectSubGroup(tp,cm.gfilter,false,3,3)
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(cm.sfilter,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if g:IsExists(cm.sfilter,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==3 then
			Duel.BreakEffect()
			if c:IsAbleToExtra() then
				if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)==1 then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_ZOMBIE)
end