local m=53799241
local cm=_G["c"..m]
cm.name="职业病"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA) and Duel.GetCurrentChain()==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	local t={0}
	for tc in aux.Next(g) do if tc:IsSummonPlayer(tp) then table.insert(t,tc:GetOriginalCodeRule()) end end
	table.insert(t,1)
	for tc in aux.Next(g) do if tc:IsSummonPlayer(1-tp) then table.insert(t,tc:GetOriginalCodeRule()) end end
	e:SetLabel(table.unpack(t))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.filter(c,e,tp,t)
	return c:IsOriginalCodeRule(table.unpack(t)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	if #g==0 then return end
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	e1:SetLabel(e:GetLabel())
	e1:SetLabelObject(g)
	Duel.RegisterEffect(e1,tp)
	for tc in aux.Next(g) do tc:CreateEffectRelation(e1) end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetLabelObject():Filter(Card.IsRelateToEffect,nil,e)
	if #rg==0 then return false end
	local cg=Group.__band(eg,rg)
	return #cg>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local rg=e:GetLabelObject():Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	if #dg==0 then return end
	local og=rg:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if #og==0 then return end
	local st={}
	local ot={}
	local t={e:GetLabel()}
	local rt=0
	for i=2,#t do
		if t[i]~=1 then table.insert(st,t[i]) else
			rt=i
			break end
	end
	for i=rt,#t do if t[i]~=1 then table.insert(ot,t[i]) end end
	local ct1=og:FilterCount(Card.IsControler,nil,tp)
	local ct2=og:FilterCount(Card.IsControler,nil,1-tp)
	local g1,g2=Group.CreateGroup(),Group.CreateGroup()
	if #st>0 then g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,st) end
	if #ot>0 then g2=Duel.GetMatchingGroup(cm.filter,1-tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,1-tp,ot) end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local res1=#st>0 and ct1>0 and ft1>0 and #g1>0
	local res2=#ot>0 and ct2>0 and ft2>0 and #g2>0
	if not (res1 or res2) then return end
	Duel.BreakEffect()
	if res1 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft1,g1:GetClassCount(Card.GetOriginalCodeRule)))
		for tc1 in aux.Next(sg1) do Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP) end
	end
	if res2 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg2=g2:SelectSubGroup(1-tp,aux.dncheck,false,1,math.min(ft2,g2:GetClassCount(Card.GetOriginalCodeRule)))
		for tc2 in aux.Next(sg2) do Duel.SpecialSummonStep(tc2,0,1-tp,1-tp,false,false,POS_FACEUP) end
	end
	Duel.SpecialSummonComplete()
end
