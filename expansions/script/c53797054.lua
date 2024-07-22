local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.SynMixCondition)
	e1:SetTarget(s.SynMixTarget)
	e1:SetOperation(aux.SynMixOperation(s.f1,nil,nil,s.f4,1,1,nil))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetLabelObject(e2)
	e3:SetValue(s.check)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_DELAY)
		ge1:SetCondition(s.con1)
		ge1:SetOperation(s.op1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetCondition(s.regcon)
		ge2:SetOperation(s.regop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVED)
		ge3:SetCondition(s.con2)
		ge3:SetOperation(s.op2)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:GetLevel()<c:GetOriginalLevel() and c:IsFaceup()
end
function s.procfilter(c)
	return c:GetOriginalCode()==id and s.advc and c:IsSynchroSummonable(s.advc)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsChainSolving()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(s.cfilter,nil):GetFirst()
	if tc then
		s.advc=tc
		local p=tc:GetSummonPlayer()
		local sc=Duel.GetFirstMatchingCard(s.procfilter,p,LOCATION_EXTRA,0,nil)
		if sc and Duel.SelectYesNo(p,aux.Stringid(id,0)) then Duel.SpecialSummonRule(p,sc,SUMMON_TYPE_SYNCHRO) end
		s.advc=nil
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainSolving()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(s.cfilter,nil):GetFirst()
	if tc then s.advc=tc Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1,tc:GetSummonPlayer()) end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>0
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetFlagEffect(0,id)
	local sc=Duel.GetFirstMatchingCard(s.procfilter,p,LOCATION_EXTRA,0,nil)
	if sc and Duel.SelectYesNo(p,aux.Stringid(id,0)) then Duel.SpecialSummonRule(p,sc,SUMMON_TYPE_SYNCHRO) end
	s.advc=nil
	Duel.ResetFlagEffect(0,id)
end
function s.matval(e,c)
	return c:IsControler(e:GetOwnerPlayer())
end
function s.SynMaterialFilter(c,syncard)
	local res=c:IsCanBeSynchroMaterial(syncard)
	if not res and s.advc and not c:IsControler(syncard:GetControler()) then
		if not (c:IsStatus(STATUS_FORBIDDEN) or c:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) or not c:IsHasEffect(EFFECT_SYNCHRO_MATERIAL)) then res=true end
	end
	return c:IsFaceupEx() and res
end
function s.synfilter(c,syncard)
	return not c:IsCanBeSynchroMaterial(syncard) and not (c:IsStatus(STATUS_FORBIDDEN) or c:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)) and c:IsFaceup()
end
function s.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(aux.SynMaterialFilter,nil,syncard)
	local t={}
	local mg4=Duel.GetMatchingGroup(s.synfilter,tp,0,LOCATION_MZONE,nil,syncard)
	if s.advc and mg:IsContains(s.advc) then
		local mg3=Duel.GetMatchingGroup(aux.SynMaterialFilter,tp,0,LOCATION_MZONE,nil,syncard)
		for tc in aux.Next(Group.__add(mg3,mg4)) do
			local e1=Effect.CreateEffect(syncard)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
			e1:SetOwnerPlayer(tp)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(s.matval)
			tc:RegisterEffect(e1,true)
			table.insert(t,e1)
		end
	end
	mg=Group.__add(Duel.GetSynchroMaterial(tp):Filter(s.SynMaterialFilter,nil,syncard),mg4)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	for _,v in pairs(t) do v:Reset() end
	return mg
end
function s.SynMixCondition(e,c,smat,mg1,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	if smat and not smat:IsCanBeSynchroMaterial(c) then return false end
	local tp=c:GetControler()
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
		mgchk=true
	else
		mg=s.GetSynMaterials(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	return mg:IsExists(s.SynMixFilter1,1,nil,s.f1,nil,nil,s.f4,minc,maxc,c,mg,smat,nil,mgchk)
end
function s.SynMixTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
	local minc=2
	local maxc=2
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
		mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
		mgchk=true
	else
		mg=s.GetSynMaterials(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	local cancel=Duel.IsSummonCancelable()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local c1=mg:Filter(s.SynMixFilter1,nil,s.f1,nil,nil,s.f4,minc,maxc,c,mg,smat,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
	if not c1 then return false end
	g:AddCard(c1)
	local g4=Group.CreateGroup()
	for i=0,maxc-1 do
		local mg2=mg:Clone()
		mg2=mg2:Filter(s.f4,g,c,c1,nil,nil)
		local cg=mg2:Filter(s.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,nil,mgchk)
		if cg:GetCount()==0 then break end
		local finish=s.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,nil,mgchk)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local c4=cg:SelectUnselect(g+g4,tp,finish,cancel,minc,maxc)
		if not c4 then
			if finish then break
			else return false end
		end
		if g:IsContains(c4) or g4:IsContains(c4) then goto SynMixTargetSelectStart end
		g4:AddCard(c4)
	end
	g:Merge(g4)
	if g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function s.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk)
	if f1 and not f1(c,syncard) then return false end
	local res=mg:IsExists(s.SynMixFilter4,1,c,f4,minc,maxc,syncard,mg,smat,c,nil,nil,gc,mgchk)
	return res
end
function s.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local e1
	if s.advc and s.advc==c1 then
		e1=Effect.CreateEffect(syncard)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
		e1:SetOwnerPlayer(tp)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.matval)
		c:RegisterEffect(e1,true)
	end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard,c1,c2,c3)
	else
		mg:Sub(sg)
	end
	local res=s.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk)
	if e1 then e1:Reset() end
	return res
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
function s.GetSynchroLevel(c,syncard,hg)
	local lv=c:GetSynchroLevel(syncard)
	if c:IsLocation(LOCATION_MZONE) and hg:IsContains(c) then lv=1 end
	return lv
end
function s.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	local t={}
	local hg=Group.CreateGroup()
	if s.advc and g:IsContains(s.advc) then
		hg=g:Filter(Card.IsControler,nil,1-tp)
		for tc in aux.Next(hg) do
			local e1=Effect.CreateEffect(syncard)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
			e1:SetOwnerPlayer(tp)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(s.matval)
			tc:RegisterEffect(e1,true)
			table.insert(t,e1)
		end
	end
	if not g:CheckWithSumEqual(s.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard,hg)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(aux.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then for _,v in pairs(t) do v:Reset() end return false end
	if not (mgchk or aux.SynMixHandCheck(g,tp,syncard)) then for _,v in pairs(t) do v:Reset() end return false end
	for _,v in pairs(t) do v:Reset() end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
function s.f1(c,syncard)
	return c:IsTuner(syncard) and not s.advc or s.advc==c
end
function s.f4(c,syncard)
	return c:IsNotTuner(syncard)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.matfilter(c)
	return c:IsType(TYPE_TUNER) and not c:IsSpecialSummonableCard()
end
function s.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and g:IsContains(c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject()
	if chkc then return chkc:IsControler(tp) and s.spfilter(chkc,e,tp,lc:GetMaterial()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
function s.check(e,c)
	local g=c:GetMaterial():Filter(s.matfilter,nil)
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
end
