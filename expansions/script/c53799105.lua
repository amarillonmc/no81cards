local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,24175232,61441708)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.mfilter1,s.mfilter2,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--destroy and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--in grave check
	local egchk=aux.AddThisCardInGraveAlreadyCheck(c)
	--destroy and spsummon self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetLabelObject(egchk)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end

-- Fusion Materials
function s.mfilter1(c)
	return c:IsFusionType(TYPE_RITUAL)
end
function s.mfilter2(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsLevel(8)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end

-- Effect 1
function s.spfilter_monster(c,e,tp)
	return c:IsCode(24175232) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter_spell(c,e,tp)
	return c:IsCode(61441708) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ogmonfilter(c)
	return c:GetType()&TYPE_MONSTER~=0
end
function s.ogstfilter(c)
	return c:GetType()&(TYPE_SPELL+TYPE_TRAP)~=0
end
function s.tgcheck(g,e,tp)
	local has_mon=g:IsExists(s.ogmonfilter,1,nil)
	local has_st=g:IsExists(s.ogstfilter,1,nil)
	if not has_mon and not has_st then return false end
	if has_mon and not Duel.IsExistingMatchingCard(s.spfilter_monster,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return false end
	if has_st and not Duel.IsExistingMatchingCard(s.spfilter_spell,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return false end
	local ct=0
	if has_mon then ct=ct+1 end
	if has_st then ct=ct+1 end
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	return Duel.GetMZoneCount(tp,g)>=ct
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return g:CheckSubGroup(s.tgcheck,1,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:SelectSubGroup(tp,s.tgcheck,false,1,2,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spfilter(c,e,tp,has_mon,has_st)
	return ((has_mon and c:IsCode(24175232))
		or (has_st and c:IsCode(61441708)))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spgcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 and Duel.Destroy(tg,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup()
		local has_mon=dg:IsExists(s.ogmonfilter,1,nil)
		local has_st=dg:IsExists(s.ogstfilter,1,nil)
		if not has_mon and not has_st then return end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local spg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,has_mon,has_st)
		local maxc=0
		if has_mon and spg:IsExists(Card.IsCode,1,nil,24175232) then maxc=maxc+1 end
		if has_st and spg:IsExists(Card.IsCode,1,nil,61441708) then maxc=maxc+1 end
		maxc=math.min(maxc,ft)
		if maxc>0 and #spg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=spg:SelectSubGroup(tp,s.spgcheck,false,1,maxc)
			if sg and #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local sg2=Duel.GetOperatedGroup()
				local fid=e:GetHandler():GetFieldID()
				local tc=sg2:GetFirst()
				while tc do
					tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0,fid)
					tc=sg2:GetNext()
				end
				sg2:KeepAlive()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(sg2)
				e1:SetCondition(s.descon2)
				e1:SetOperation(s.desop2)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.desfilter2(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.desfilter2,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.desfilter2,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end

-- Effect 2
function s.cfilter2(c,se)
	return c:IsSummonLocation(LOCATION_GRAVE) and (se==nil or c:GetReasonEffect()~=se)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(s.cfilter2,1,nil,se)
end
function s.desfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x11f) and Duel.GetMZoneCount(tp,c)>0
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end