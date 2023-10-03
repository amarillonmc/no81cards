--梦蚀
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c71400025.tg1)
	e1:SetCost(c71400025.cost1)
	e1:SetOperation(c71400025.op1)
	e1:SetCountLimit(1,71400025+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--[[
	--Activate(field)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400025,1))
	e2:SetCondition(yume.YumeCon)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,71400025+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c71400025.cost2)
	e2:SetTarget(c71400025.tg2)
	e2:SetOperation(c71400025.op2)
	c:RegisterEffect(e2)
	--]]
end
function c71400025.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c71400025.filter1(c,tp)
	return yume.ActivateFieldFilter(c,tp,0,2) and Duel.IsExistingMatchingCard(c71400025.filter1a,tp,LOCATION_DECK,0,1,c)
end
function c71400025.filter1a(c)
	return c:IsSetCard(0x714) and c:IsAbleToGrave()
end
function c71400025.filter1b(c,g)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x714) and c:IsLinkSummonable(g)
end
function c71400025.filter1c(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c71400025.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c71400025.filter1b,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c71400025.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c71400025.filter1,tp,LOCATION_DECK,0,1,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b2=yume.IsYumeFieldOnField(tp) and Duel.IsPlayerCanSpecialSummonCount(tp,2) and ft>0
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local linkcountgroup=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local ct=0
	for tc in aux.Next(linkcountgroup) do
		ct=ct+tc:GetLink()
	end
	if ct>ft then ct=ft end
	local g=Duel.GetMatchingGroup(c71400025.filter1c,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	g:Merge(fg)
	b2=b2 and ct>0 and g:CheckSubGroup(c71400025.fselect,1,ct,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(71400025,0),aux.Stringid(71400025,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(71400025,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(71400025,1))+1
	end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1,op) else e:SetLabel(0,op) end
	if op==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		local og=Duel.GetMatchingGroup(c71400025.filter1a,tp,LOCATION_DECK,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,og,1,0,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function c71400025.op1(e,tp,eg,ep,ev,re,r,rp)
	local act,op=e:GetLabel()
	if op==0 then
		if not yume.ActivateYumeField(e,tp,nil,2) then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c71400025.filter1a,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local linkcountgroup=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
		local ct=0
		for tc in aux.Next(linkcountgroup) do
			ct=ct+tc:GetLink()
		end
		if ct>ft then ct=ft end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71400025.filter1c),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,ct,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			local og=Duel.GetOperatedGroup()
			Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
			if og:GetCount()<1 then return end
			local tg=Duel.GetMatchingGroup(c71400025.filter1b,tp,LOCATION_EXTRA,0,nil,nil)
			if tg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local rg=tg:Select(tp,1,1,nil)
				Duel.LinkSummon(tp,rg:GetFirst(),nil)
			end
		end
	end
end
--[[
function c71400025.filter2(c)
	return c:IsType(TYPE_LINK)
end
function c71400025.filter2a(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400025.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71400025,tp,ACTIVITY_SPSUMMON)==0 and Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c71400025.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c71400025.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_LINK) and c:IsSetCard(0x714)) and c:IsLocation(LOCATION_EXTRA)
end
function c71400025.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_LINK) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71400025.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c71400025.filter2a,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71400025.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71400025.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),tc:GetLink())
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400025.filter2a),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil,e,tp)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		local fid=c:GetFieldID()
		while sc do
			if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				sc:RegisterFlagEffect(71400025,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			sc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c71400025.rmcon)
		e1:SetOperation(c71400025.rmop)
		e1:SetLabel(fid)
		e1:SetLabelObject(sg)
		Duel.RegisterEffect(e1,tp)
	end
end
function c71400025.rmfilter(c,fid)
	return c:GetFlagEffectLabel(71400025)==fid
end
function c71400025.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c71400025.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c71400025.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c71400025.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
--]]