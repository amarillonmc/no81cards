--飞天寒霜而降临华符
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
		--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function s.costfilter(c,tp)
	return c:IsFaceup() and c:IsCode(12869000)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.spfilter1(c,e,tp)
	return c:IsSetCard(0x6a70) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(0) and c:IsSetCard(0x6a70)
end
function s.fselect1(g,tp)
	return Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function s.fselect2(g,tp)
	return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function s.lkfilter(c,g)
	return c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function s.synfilter(c,mg)
	return c:IsSynchroSummonable(nil)
	--return c:IsSynchroSummonable(nil,mg,mg:GetCount(),mg:GetCount())
end
function s.chkfilter1(c,tp)
	return c:IsType(TYPE_LINK) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.chkfilter2(c,tp)
	return c:IsType(TYPE_LINK) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local b1=false
	local b2=false
	local cg1=Duel.GetMatchingGroup(s.chkfilter1,tp,LOCATION_EXTRA,0,nil,tp)
	if #cg1>0 then
		local _,maxlink=cg1:GetMaxGroup(Card.GetLink)
		if maxlink>ft then maxlink=ft end
		local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		b1=g1:CheckSubGroup(s.fselect1,1,maxlink,tp)
	end
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	b2=g2:GetCount()>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if ft<=0 then return false end
		return b1 or b2
	end 
	local op=aux.SelectFromOptions(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function s.synlimit(e,c)
	local g=e:GetLabelObject()
	return not g:IsContains(c)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local op=e:GetLabel()
	if op==1 then 
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		local cg=Duel.GetMatchingGroup(s.chkfilter1,tp,LOCATION_EXTRA,0,nil,tp)
		local _,maxlink=cg:GetMaxGroup(Card.GetLink)
		if ft>0 and maxlink then
			if maxlink>ft then maxlink=ft end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,s.fselect1,false,1,maxlink,tp)
			if not sg then return end
			for tc in aux.Next(sg) do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
			local og=Duel.GetOperatedGroup()
			Duel.AdjustAll()
			if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<sg:GetCount() then return end
			local tg=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
			if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local rg=tg:Select(tp,1,1,nil)
				Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
			end
		end
	elseif op==2 then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil,e,tp)
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(s.synlimit)
		e1:SetLabelObject(og)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.AdjustAll()
		if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<g:GetCount() then return end
		local tg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,rg:GetFirst(),nil)
			--Duel.SynchroSummon(tp,rg:GetFirst(),nil,og,#og,#og)
		end
		e1:Reset()
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
	local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
end