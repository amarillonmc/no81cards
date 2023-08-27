--PSY骨架装备·原型
function c98920567.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c98920567.splimit)
	c:RegisterEffect(e0)
	--sps
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920567,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,98920567)
	e3:SetCondition(c98920567.condition)
	e3:SetCost(c98920567.cost)
	e3:SetTarget(c98920567.target)
	e3:SetOperation(c98920567.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920567,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,98920567)
	e1:SetTarget(c98920567.sstarget)
	e1:SetOperation(c98920567.ssoperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c98920567.sscon)
	c:RegisterEffect(e2)
end
function c98920567.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c98920567.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsPlayerAffectedByEffect(tp,8802510))
end
function c98920567.sscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RETURN)
end
function c98920567.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c98920567.spfilter(c,e,tp)
	return c:IsSetCard(0xc1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920567.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c98920567.synfilter,tp,LOCATION_EXTRA,0,1,nil,g) or Duel.IsExistingMatchingCard(c98920567.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g) and g:IsExists(Card.IsCode,1,nil,49036338) and g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function c98920567.synfilter(c,g)
	return c:IsSetCard(0xc1) and c:IsSynchroSummonable(nil,g)
end
function c98920567.lkfilter(c,g)
	return c:IsSetCard(0xc1) and c:IsLinkSummonable(g,nil,2,2)
end
function c98920567.chkfilter(c,tp)
	return (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK)) and c:IsSetCard(0xc1) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98920567.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return false end
		local cg=Duel.GetMatchingGroup(c98920567.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local g=Duel.GetMatchingGroup(c98920567.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		return g:CheckSubGroup(c98920567.fselect,2,2,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920567.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local cg=Duel.GetMatchingGroup(c98920567.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg>0 then
			local g=Duel.GetMatchingGroup(c98920567.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,c98920567.fselect,false,2,2,tp)
			if sg then
				local tc=sg:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					tc:RegisterEffect(e2)
					tc=sg:GetNext()
				end
				Duel.SpecialSummonComplete()
				local og=Duel.GetOperatedGroup()
				Duel.AdjustAll()
				if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
				local tg=Duel.GetMatchingGroup(c98920567.synfilter,tp,LOCATION_EXTRA,0,nil,og)
				local lg=Duel.GetMatchingGroup(c98920567.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
				if og:GetCount()==sg:GetCount() and tg:GetCount()>0 and Duel.SelectOption(tp,1164,1166)==0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local rg=tg:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
				elseif og:GetCount()==sg:GetCount() and lg:GetCount()>0 then
				   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				   local rrg=lg:Select(tp,1,1,nil)
				   Duel.LinkSummon(tp,rrg:GetFirst(),og,nil,#og,#og)
				end
			end
		end
	end
end
function c98920567.sspfilter(c,e,tp)
	return c:IsCode(49036338) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920567.sstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c98920567.sspfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c98920567.ssoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920567.sspfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
	tc:RegisterFlagEffect(98920567,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	c:RegisterFlagEffect(98920567,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	Duel.SpecialSummonComplete()
	g:AddCard(c)
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(c98920567.rmcon)
	e1:SetOperation(c98920567.rmop)
	Duel.RegisterEffect(e1,tp)
end
function c98920567.rmfilter(c,fid)
	return c:GetFlagEffectLabel(98920567)==fid
end
function c98920567.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c98920567.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c98920567.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c98920567.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end