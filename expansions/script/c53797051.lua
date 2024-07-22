if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,80280737)
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
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,80280737))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.copycost)
	e3:SetOperation(s.copyop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local sg=Group.CreateGroup()
		sg:KeepAlive()
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetLabelObject(sg)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		s.AcAe={}
		local f1=Card.RegisterEffect
		Card.RegisterEffect=function(tc,te,bool)
			if te:GetCode()==EFFECT_TRAP_ACT_IN_SET_TURN and te:GetRange()&LOCATION_MZONE~=0 then table.insert(s.AcAe,te:Clone()) end
			return f1(tc,te,bool)
		end
		local f2=Duel.RegisterEffect
		Duel.RegisterEffect=function(te,p)
			if te:GetCode()==EFFECT_TRAP_ACT_IN_SET_TURN and te:GetOwner() and te:GetOwner():IsLocation(LOCATION_MZONE) then table.insert(s.AcAe,te:Clone()) end
			return f2(te,p)
		end
	end
end
function s.chkfilter(c,syncard)
	return c:GetFlagEffect(id)>0 and c:IsLocation(LOCATION_MZONE)
end
function s.synfilter(c,syncard)
	return c:IsCanBeSynchroMaterial(syncard,c) and aux.IsCodeListed(c,80280737) and c:IsType(TYPE_TUNER)
end
function s.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(aux.SynMaterialFilter,nil,syncard)
	local t={}
	if mg:IsExists(s.chkfilter,1,nil) then
		local mg3=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_DECK,0,nil,syncard)
		local mg4=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_HAND,0,nil,syncard)
		for tc in aux.Next(mg4) do
			local e1=Effect.CreateEffect(syncard)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_HAND)
			e1:SetValue(s.matval)
			tc:RegisterEffect(e1,true)
			table.insert(t,e1)
		end
		if mg3:GetCount()>0 then mg:Merge(mg3) end
	end
	mg:Merge(Duel.GetSynchroMaterial(tp):Filter(aux.SynMaterialFilter,nil,syncard))
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
	local minc=1
	local maxc=1
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
	local minc=1
	local maxc=1
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
function s.matval(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function s.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk)
	if f1 and not f1(c,syncard) then return false end
	local res=mg:IsExists(s.SynMixFilter4,1,c,f4,minc,maxc,syncard,mg,smat,c,nil,nil,gc,mgchk)
	return res
end
function s.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local e1
	if s.chkfilter(c1) then
		e1=Effect.CreateEffect(syncard)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_HAND)
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
	if c:IsLocation(LOCATION_HAND) and hg:IsContains(c) then
		local clv=aux.GetCappedLevel(c)
		lv=(1<<16)+clv
	elseif c:IsLocation(LOCATION_DECK) then lv=1 end
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
	if g:IsExists(s.chkfilter,1,nil) then
		hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
		for tc in aux.Next(hg) do
			local e1=Effect.CreateEffect(syncard)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_HAND)
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
	return c:IsNotTuner(syncard)
end
function s.f4(c,syncard)
	return c:IsTuner(syncard)
end
function s.acfilter(c,tp)
	local te=c:GetActivateEffect()
	return c:IsCode(80280737) and te and te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tp) and c:IsLocation(te:GetRange())
end
function s.acfilter2(c,e,tp,code)
	local te=c:GetActivateEffect()
	if not te then return false end
	if not c:IsCode(80280737) then return false end
	if c:IsLocation(LOCATION_HAND) and not c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND) then return false end
	if c:IsLocation(LOCATION_SZONE) and (c:IsFaceup() or (c:IsStatus(STATUS_SET_TURN) and not c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))) then return false end
	local check=true
	if c:IsHasEffect(EFFECT_CANNOT_TRIGGER) then check=false end
	local le1={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	for _,v in pairs(le1) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,tp) then check=false end
	end
	local le2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_ACTIVATE_COST)}
	for _,v in pairs(le2) do
		local cost=v:GetCost()
		if cost and not cost(v,te,tp) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,tp) then check=false end
		end
	end
	if not check then return false end
	return c:IsLocation(te:GetRange()) and te:GetCode()==EVENT_FREE_CHAIN and e:GetHandler():IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code)
end
function s.spfilter(c,e,tp,tcode)
	return c:IsSetCard(0x104f) and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_ASSAULT_MODE,tp,false,true,POS_FACEUP_ATTACK) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function s.costfilter(c,e,tp)
	if not (c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost() and not c:IsCode(e:GetHandler():GetCode())) then return false end
	local g=Duel.GetMatchingGroup(s.acfilter,tp,0xff,0,nil,tp)
	if #g>0 then return true end
	return Duel.IsExistingMatchingCard(s.acfilter2,tp,0xff,0,1,nil,e,tp,c:GetCode())
end
function s.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=Duel.SelectMatchingCard(tp,s.acfilter,tp,0xff,0,1,1,nil,tp):GetFirst()
	local le={tc:GetActivateEffect()}
	for _,v in pairs(le) do
		if v:GetCode()==EVENT_FREE_CHAIN then
			local e1=v:Clone()
			e1:SetType(EFFECT_TYPE_QUICK_F)
			e1:SetCode(EVENT_CUSTOM+id)
			e1:SetRange(v:GetRange())
			local pro1,pro2=v:GetProperty()
			e1:SetProperty(pro1|EFFECT_FLAG_SET_AVAILABLE,pro2)
			local con=v:GetCondition() or aux.TRUE
			e1:SetCondition(s.con(con))
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1,e1:GetFieldID())
			local e1_1,e2,e3,e2_1=SNNM.ActivatedAsSpellorTrap(tc,tc:GetOriginalType(),v:GetRange(),true,e1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		end
	end
	Duel.AdjustAll()
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,e,0,tp,tp,0)
	tc:ResetFlagEffect(id)
end
function s.con(con)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local t={e:GetHandler():GetFlagEffectLabel(id+500)}
				return SNNM.IsInTable(e:GetFieldID(),t) and con(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,sg)
	if #g==0 then return end
	sg:Merge(g)
	s.AcAe={}
	local f1=Card.IsType
	local f2=Card.GetType
	local f3=Card.IsCode
	local f4=Card.GetCode
	local f5=Card.IsSetCard
	Card.IsType=function(...)return true end
	Card.GetType=function(...)return 0x4 end
	Card.IsCode=function(c,...)
		local t={...}
		if SNNM.IsInTable(80280737,t) then return true else return false end
	end
	Card.GetCode=function(c)return 80280737 end
	Card.IsSetCard=function(...)return false end
	for tc in aux.Next(g) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		for _,v in pairs(s.AcAe) do
			local tg=v:GetTarget() or aux.TRUE
			if tg(v,tc) then tc:RegisterFlagEffect(id,0,0,0) end
		end
		s.AcAe={}
	end
	Card.IsType=f1
	Card.GetType=f2
	Card.IsCode=f3
	Card.GetCode=f4
	Card.IsSetCard=f5
end
