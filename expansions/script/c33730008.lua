-- 键★等 －海产同盟 / K.E.Y Etc. Alleanza Fauna Marina
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(Card.IsSetCard,0x460),nil,3,3)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.filter(c,tp)
	return Duel.IsPlayerCanSendtoDeck(tp,c)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil,1-tp) end
	end
	local rg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil,1-tp)
	local ct=c:RemoveOverlayCard(tp,1,#rg,REASON_COST)
	local mg=Duel.GetOperatedGroup()
	for mc in aux.Next(mg) do
		if mc:IsType(TYPE_MONSTER) and mc:IsLocation(LOCATION_GRAVE) then
			mc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
			mc:SetFlagEffectLabel(id,e:GetFieldID())
		end
	end
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rg,ct,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp) and c:GetFlagEffect(id)>0 and c:GetFlagEffectLabel(id)==e:GetFieldID()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(1-tp,s.filter,tp,0,LOCATION_ONFIELD,ct,ct,nil,1-tp)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,ct,nil,LOCATION_DECK+LOCATION_EXTRA) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
			local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
			local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			local max=math.min(ft,#sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,max,max,nil)
			if #tg>0 then
				Duel.SpecialSummon(tg,0,tp,1-tp,true,false,POS_FACEUP)
			end
		end
	end
end