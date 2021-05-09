--死灵舞者·废品
local m=71100113
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x17d7)
   --xyz summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),2,2)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.sumsuc)
	c:RegisterEffect(e1) 
	--set or draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x17d7,8)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x17d7,8,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x17d7,8,REASON_COST)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function cm.tdfilter(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsType(TYPE_TRAP)
end
function cm.setfilter(c,e,tp)
	if c:IsLocation(LOCATION_REMOVED) and not c:IsFaceup() then return false end
	if not c:IsSetCard(0x7d7) then return false end
	if c:IsType(TYPE_MONSTER) then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	elseif c:IsType(TYPE_FIELD) then
		return not c:IsForbidden() and c:IsSSetable(true)
	else
		return c:IsSSetable()
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
	local a=g:IsExists(cm.tdfilter,1,nil) and g:GetCount()>2 and c:IsAbleToExtra() and Duel.IsPlayerCanDraw(tp,1)
	local b=Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return a or b end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.gfilter(g)
	return g:IsExists(cm.tdfilter,1,nil)
end
function cm.sfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
	local a=g:IsExists(cm.tdfilter,1,nil) and g:GetCount()>2 and c:IsAbleToExtra() and Duel.IsPlayerCanDraw(tp,1)
	local b=Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) 
	local op=2
	if not (a or b) then return end
	if a and b then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif a then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	end
	if op==0 then
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
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			if tc:IsType(TYPE_MONSTER) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
		end
	end
end