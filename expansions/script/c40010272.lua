--光辉的狮子 白金艾泽勒
local m=40010272
local cm=_G["c"..m]
cm.named_with_Ezel=1
function cm.Ezel(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ezel
end
function cm.Ezelferind(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ezelferind
end
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--confiem
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	--e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (cm.Ezel(c) or cm.Ezelferind(c)) 
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2)
	local sg=g:Filter(cm.spfilter,nil,e,tp)
	if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil)
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			g:Sub(tc)
		end
		Duel.Overlay(c,g)
	else
		Duel.ShuffleDeck(tp)
	end
end
