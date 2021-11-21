--G-神智的强欲
local m=16107101
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x5ccc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return --Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and
	Duel.IsExistingMatchingCard(Card.IsDisabled,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local loc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.min(hg:GetCount(),hg:GetCount())
	ct=math.min(ct,loc)
	if ct<=0 then return end
	local ct2=1
	local pack={}
	if ct>1 then
		for i=1,ct do
			pack[#pack+1]=i
		end
		ct2=Duel.AnnounceNumber(tp,table.unpack(pack)) 
	end
	local g=hg:RandomSelect(tp,ct2)
	local ct3=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	return
	if ct3<=0 then return end
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct3=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,ct3,ct3,nil,e,tp)
	if sg:GetCount()<1 then return end
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end