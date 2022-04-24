--祖先和祖父
local m=64800132
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsSummonLocation(LOCATION_EXTRA) then return end
	while tc do
		local mg=tc:GetMaterial()
		local ct=mg:GetCount()
		for sc in aux.Next(mg) do
			if sc:IsLocation(LOCATION_GRAVE) then
				sc:RegisterFlagEffect(m,RESET_EVENT+0x1f20000,0,1)
			end
			tc:RegisterFlagEffect(m+1,RESET_EVENT+RESET_TODECK,0,1)
		end
		tc=eg:GetNext()
	end
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA) and c:IsAbleToExtra()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,0))
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,tc)
	local ct=tc:GetFlagEffect(m+1)
	local tep=tc:GetOwner()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and ct>0 and ct<=Duel.GetLocationCount(tep,LOCATION_MZONE) and #g==ct and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.SelectYesNo(tep,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			if Duel.SpecialSummon(g,0,tep,tep,false,false,POS_FACEUP)==#g then
				if tc:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.xyzfilter,tep,LOCATION_EXTRA,0,1,nil,g,e,tep,tc) and Duel.SelectYesNo(tep,aux.Stringid(m,2)) then
					Duel.Hint(HINT_SELECTMSG,tep,HINTMSG_SPSUMMON)
					local sg=Duel.SelectMatchingCard(tep,cm.xyzfilter,tep,LOCATION_EXTRA,0,1,1,nil,g,e,tep,tc)
					if sg:GetCount()>0 then
						Duel.XyzSummon(tep,sg:GetFirst(),g,#g,#g)
					end
				elseif tc:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(cm.synfilter,tep,LOCATION_EXTRA,0,1,nil,g,e,tep,tc) and Duel.SelectYesNo(tep,aux.Stringid(m,2)) then
					Duel.Hint(HINT_SELECTMSG,tep,HINTMSG_SPSUMMON)
					local sg=Duel.SelectMatchingCard(tep,cm.synfilter,tep,LOCATION_EXTRA,0,1,1,nil,g,e,tep,tc)
					if g:GetCount()>0 then
						Duel.SynchroSummon(tep,sg:GetFirst(),nil,g,#g,#g)
					end
				elseif tc:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(cm.linkfilter,tep,LOCATION_EXTRA,0,1,nil,g,e,tep,tc) and Duel.SelectYesNo(tep,aux.Stringid(m,2)) then
					Duel.Hint(HINT_SELECTMSG,tep,HINTMSG_SPSUMMON)
					local sg=Duel.SelectMatchingCard(tep,cm.linkfilter,tep,LOCATION_EXTRA,0,1,1,nil,g,e,tep,tc)
					if g:GetCount()>0 then
						Duel.LinkSummon(tep,sg:GetFirst(),g,nil,#g,#g)
					end
				end
			end
		end
	end
end
function cm.thfilter1(c,e,tp,tc)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(m)~=0
		and c:IsLocation(LOCATION_GRAVE)
		and c:IsCanBeSpecialSummoned(e,0,tc:GetOwner(),false,false)
end
function cm.xyzfilter(c,mg,e,tp,tc)
	return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(mg,#mg,#mg) and not c:IsCode(tc:GetOriginalCodeRule())
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function cm.synfilter(c,mg,e,tp,tc)
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,mg,#mg,#mg) and not c:IsCode(tc:GetOriginalCodeRule())
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function cm.linkfilter(c,mg,e,tp,tc)
	return c:IsType(TYPE_LINK) and c:IsLinkSummonable(mg,nil,#mg,#mg) and not c:IsCode(tc:GetOriginalCodeRule())
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end