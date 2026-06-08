--缚骸渊孽 墨赫萨拉斯
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.SynMixCondition(s.TunerFilter,s.NonTunerFilter,1,99))
	e0:SetTarget(s.SynMixTarget(s.TunerFilter,s.NonTunerFilter,1,99))
	e0:SetOperation(s.SynMixOperation(s.TunerFilter,s.NonTunerFilter,1,99))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.immval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.TunerFilter(c,syncard)
	return c:GetOriginalType()&TYPE_TUNER>0 and c:IsSetCard(0x54c)
end
function s.NonTunerFilter(c,syncard)
	local ot=c:GetOriginalType()
	return ot&TYPE_MONSTER>0 and ot&TYPE_TUNER==0 and ot&TYPE_SYNCHRO>0
end
function s.IsEquipMonsterFilter(c)
	return c:IsLocation(LOCATION_SZONE) and c:GetEquipTarget()~=nil and c:GetOriginalType()&TYPE_MONSTER>0
end
function s.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	mg=mg:Filter(function(c) return c:GetOriginalType()&TYPE_MONSTER>0 end,nil)
	local eqg=Duel.GetMatchingGroup(s.IsEquipMonsterFilter,tp,LOCATION_SZONE,0,nil)
	mg:Merge(eqg)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(function(c) return c:GetOriginalType()&TYPE_MONSTER>0 end,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return mg
end
function s.SynMixFilter1(c,f1,f2,minc,maxc,syncard,mg,smat,gc,mgchk)
	return f1(c,syncard) and mg:IsExists(s.SynMixFilter2,1,c,f2,minc,maxc,syncard,mg,smat,c,gc,mgchk)
end
function s.SynMixFilter2(c,f2,minc,maxc,syncard,mg1,smat,mat1,gc,mgchk)
	if not f2(c,syncard) then return false end
	local sg=Group.FromCards(mat1,c)
	local mg=mg1:Clone()
	mg=mg:Filter(f2,sg,syncard)
	return s.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk)
end
function s.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc,mgchk)
	local tp=syncard:GetControler()
	local sg=Group.CreateGroup()
	if minc<=0 and s.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc,mgchk) then return true end
	if maxc==0 then return false end
	return mg:IsExists(s.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc,mgchk)
end
function s.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk)
	sg:AddCard(c)
	ct=ct+1
	local res=s.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
		or (ct<maxc and mg:IsExists(s.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function s.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	if ct<minc then return false end
	local g=sg:Clone()
	if sg1 then g:Merge(sg1) end
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not Auxiliary.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(aux.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
	then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 and not mgchk then
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				if hf and hg:IsExists(Auxiliary.SynLimitFilter,1,c,hf,he,syncard) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(Auxiliary.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
function s.SynMixCondition(f1,f2,minct,maxct,gc)
	return function(e,c,smat,mg1,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local minc=minct
		local maxc=maxct
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
			if minc>maxc then return false end
		end
		local tp=c:GetControler()
		local mg
		local mgchk=false
		if mg1 then
			mg=mg1
			mgchk=true
		else
			mg=s.GetSynMaterials(tp,c)
		end
		if smat~=nil then mg:AddCard(smat) end
		return mg:IsExists(s.SynMixFilter1,1,nil,f1,f2,minc,maxc,c,mg,smat,gc,mgchk)
	end
end
function s.SynMixTarget(f1,f2,minct,maxct,gc)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
		local minc=minct
		local maxc=maxct
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
			if minc>maxc then return false end
		end
		::SynMixTargetSelectStart::
		local g=Group.CreateGroup()
		local mg
		local mgchk=false
		if mg1 then
			mg=mg1
			mgchk=true
		else
			mg=s.GetSynMaterials(tp,c)
		end
		if smat~=nil then mg:AddCard(smat) end
		local c1
		local cancel=Duel.IsSummonCancelable()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		c1=mg:Filter(s.SynMixFilter1,nil,f1,f2,minc,maxc,c,mg,smat,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
		if not c1 then return false end
		g:AddCard(c1)
		local g2=Group.CreateGroup()
		for i=0,maxc-1 do
			local mg2=mg:Clone()
			mg2=mg2:Filter(f2,g,c)
			local cg=mg2:Filter(s.SynMixCheckRecursive,g2,tp,g2,mg2,i,minc,maxc,c,g,smat,gc,mgchk)
			if cg:GetCount()==0 then break end
			local minct=1
			if s.SynMixCheckGoal(tp,g2,minc,i,c,g,smat,gc,mgchk) then
				minct=0
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local tg=cg:Select(tp,minct,1,nil)
			if tg:GetCount()==0 then break end
			g2:Merge(tg)
		end
		g:Merge(g2)
		if g:GetCount()>0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else
			return false
		end
	end
end
function s.SynMixOperation(f1,f2,minct,maxct,gc)
	return function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
		g:DeleteGroup()
	end
end
function s.eqfilter(c,e,tp)
	return c:IsSetCard(0x54c) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.eqfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_GRAVE,0,1,3,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g:GetFirst(),#g,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<#g then return end
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	for tc in aux.Next(g) do
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(c)
		tc:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.immval(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:GetEquipTarget()~=nil
		and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.eqfilter2(c)
	return c:IsFaceup()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
		if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(s.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local eqg=Duel.SelectMatchingCard(tp,s.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			local eqc=eqg:GetFirst()
			if eqc then
				if not Duel.Equip(tp,tc,eqc,false) then return end
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(s.eqlimit)
				e1:SetLabelObject(eqc)
				tc:RegisterEffect(e1)
			end
		end
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end