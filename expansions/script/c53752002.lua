if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
if Necrocean_Database then return end
Necrocean_Database=true
if Necrocean then return end
Necrocean=Necrocean or {}
function Necrocean.set(code,setcode,rkflag)
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	return code,_G["c"..code]
end
local id,s=Necrocean.set(53752002)
Necrocean=s
function Necrocean.AddSynchroMixProcedure(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.SynMixCondition)
	e1:SetTarget(s.SynMixTarget)
	e1:SetOperation(s.SynMixOperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetLabelObject(e1)
	e2:SetOperation(s.LilyLind)
	c:RegisterEffect(e2)
end
function s.LilyLind(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	se:SetLabel(0)
	c:RegisterFlagEffect(53752000,0,0,0)
	local re1={c:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re2={c:IsHasEffect(EFFECT_SPSUMMON_COST)}
	local re5={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT)}
	for _,te1 in pairs(re1) do
		local con=te1:GetCondition()
		if not con then con=aux.TRUE end
		te1:SetCondition(s.chcon(con))
		se:SetLabel(1)
	end
	for _,te2 in pairs(re2) do
		local cost=te2:GetCost()
		if cost and not cost(te2,c,tp) then
			if te2:GetType()==EFFECT_TYPE_SINGLE then
				local con=te2:GetCondition()
				if not con then con=aux.TRUE end
				te2:SetCondition(s.chcon(con))
				se:SetLabel(1)
			end
			if te2:GetType()==EFFECT_TYPE_FIELD then
				local tg=te2:GetTarget()
				if not tg then
					te2:SetTarget(s.chtg(aux.TRUE))
					se:SetLabel(1)
				elseif tg(te2,c,tp) then
					te2:SetTarget(s.chtg(tg))
					se:SetLabel(1)
				end
			end
		end
	end
	for _,te5 in pairs(re5) do
		local val=te5:GetValue()
		local _,a=te5:GetLabel()
		if a==0 then te5:SetLabel(0,val) end
		local sp=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
		local _,b=te5:GetLabel()
		if sp==0 then
			te5:SetLabel(1,b)
			te5:SetValue(b)
		end
		val=te5:GetValue()
		local l,_=te5:GetLabel()
		if l==0 then te5:SetLabel(sp+1,b) else
			local n=sp-l+1
			if n==val then
				te5:SetValue(val+1)
				local e1=te5:Clone()
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetReset(RESET_PHASE+PHASE_END)
				local loc=te5:GetRange()
				if loc~=0 then
					e1:SetLabelObject(te5)
					te5:GetHandler():RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_ADJUST)
					e2:SetLabel(loc,b)
					e2:SetLabelObject(e1)
					e2:SetOperation(s.reset1)
					Duel.RegisterEffect(e2,tp)
				else Duel.RegisterEffect(e1,te5:GetOwnerPlayer()) end
			end
		end
	end
	local re3={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re4={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
	for _,v in pairs(re4) do table.insert(re3,v) end
	for _,te3 in pairs(re3) do
		local tg=te3:GetTarget()
		if not tg then
			te3:SetTarget(s.chtg3(aux.TRUE))
			se:SetLabel(1)
		elseif tg(te3,c,tp,SUMMON_TYPE_SYNCHRO,POS_FACEUP,tp,se) then
			te3:SetTarget(s.chtg3(tg))
			se:SetLabel(1)
		end
	end
	c:ResetFlagEffect(53752000)
end
function s.chcon(_con)
	return function(e,...)
			   local x=e:GetHandler()
			   if x:IsHasEffect(53752000) and Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,x:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) and x:GetFlagEffect(53752000)<1 then return false end
			   return _con(e,...)
		   end
end
function s.reset1(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetLabelObject():GetHandler()
	local te=e:GetLabelObject():GetLabelObject()
	local loc,v=e:GetLabel()
	if x:GetLocation()&loc==0 then
		te:SetLabel(0,v)
		te:SetValue(v)
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function s.chtg3(_tg)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
			   if s.NecroceanSyn(c) and se:GetHandler()==c and Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,c:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) and c:GetFlagEffect(53752000)<1 then return false end
			   return _tg(e,c,sump,sumtype,sumpos,targetp,se)
		   end
end
function s.chtg(_tg)
	return function(e,c,...)
			   if c:IsHasEffect(53752000) and Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,c:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) and c:GetFlagEffect(53752000)<1 then return false end
			   return _tg(e,c,...)
		   end
end
function s.SMatCatch(tp,syncard)
	local g=aux.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(s.SMatCheck,tp,0x10,0x1c,g,syncard)
	return Group.__add(g,mg)
end
function s.SMatCheck(c,syncard)
	if not (c:IsCanBeSynchroMaterial(syncard) or c:IsLevel(0)) then return false end
	if c:IsStatus(STATUS_FORBIDDEN) then return false end
	if c:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) then return false end
	local tp=syncard:GetControler()
	local res=Duel.IsExistingMatchingCard(s.lindfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
	if c:IsLocation(LOCATION_GRAVE) then
		if c:GetControler()==tp and c:IsLevel(0) and syncard:GetOriginalCode()~=53752002 then return false end
		if Duel.IsExistingMatchingCard(function(c)return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)end,tp,LOCATION_GRAVE,0,1,nil) then return false end
		if not (c:IsAbleToRemove(tp,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO) or res) then return false end
	elseif c:IsLocation(LOCATION_ONFIELD) then
		if c:GetControler()==tp and c:IsFacedown() then return false end
		if c:GetControler()~=tp and not res then return false end
	else return false end
	return true
end
function s.SLevelCal(c,sc)
	local lv=c:GetSynchroLevel(sc)
	local tp=sc:GetControler()
	local b1=c:IsLocation(LOCATION_GRAVE) and c:IsLevel(0) and (c:GetControler()~=tp or sc:GetOriginalCode()==53752002)
	local b2=Duel.IsExistingMatchingCard(s.lindfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) and c:IsLocation(LOCATION_ONFIELD) and c:GetControler()~=tp and (c:IsFacedown() or c:IsLevel(0))
	if s.NecroceanSyn(sc) and (b1 or b2) then return 1 else return lv end
end
function s.NecroceanSyn(c)
	local code=c:GetOriginalCode()-53752000
	return (code>=7 and code<=14) or code==2
end
function s.lindfilter(c)
	return c:IsFaceupEx() and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()
end
function s.lvs(c,syncard)
	if not c then return 0 end
	local lv=s.SLevelCal(c,syncard)
	local lv2=lv>>16
	lv=lv&0xffff
	if lv2>0 then return lv,lv2 else return lv end
end
function s.lvplus(group,sc)
	local results = {}
	local function calculateRecursive(cards, index, sum)
		if index > #cards then
			table.insert(results, sum)
			return
		end
		local card = cards[index]
		local level1, level2 = s.lvs(card,sc)
		if not level2 then
			calculateRecursive(cards, index + 1, sum + level1)
		else
			calculateRecursive(cards, index + 1, sum + level1)
			calculateRecursive(cards, index + 1, sum + level2)
		end
	end
	local cards = {}
	local card = group:GetFirst()
	while card do
		table.insert(cards, card)
		card = group:GetNext()
	end
	calculateRecursive(cards, 1, 0)
	return results
end
function s.TunerCheck(c,sc)
	local p,sp=c:GetControler(),sc:GetControler()
	return c:IsTuner(sc) and (c:IsFaceup() or p==sp or not c:IsOnField())
end
function s.NotTunerCheck(c,sc)
	local p,sp=c:GetControler(),sc:GetControler()
	return c:IsNotTuner(sc) or (c:IsFacedown() and p~=sp and c:IsOnField())
end
function s.slfilter(c,tc,sc)
	local lv1_1,lv1_2=s.lvs(c,sc)
	local lv2_1,lv2_2=s.lvs(tc,sc)
	if (lv1_2 and not lv2_2) or (not lv1_2 and lv2_2) then return false end
	local res1=(lv1_1==lv2_1)
	if lv1_2 and lv2_2 then res1=(((lv1_1==lv2_1) and (lv1_2==lv2_2)) or ((lv1_1==lv2_2) and (lv1_2==lv2_1))) end
	if not res1 then return false end
	local function botht(card,syncard)
		return s.TunerCheck(card,syncard) and s.NotTunerCheck(card,syncard)
	end
	if botht(c,sc) and botht(tc,sc) then return true
	elseif botht(c,sc) and not botht(tc,sc) then return false
	elseif not botht(c,sc) and botht(tc,sc) then return false else
		if (s.TunerCheck(c,sc) and s.TunerCheck(tc,sc)) or (s.NotTunerCheck(c,sc) and s.NotTunerCheck(tc,sc)) then return true end
	end
	return false
end
function s.gcheck(sc)
	return  function(sg)
				return math.min(table.unpack(s.lvplus(sg,sc)))<=sc:GetLevel()
			end
end
function s.SynMixCondition(e,c,smat,mg1,min,max)
	if c==nil then return true end
	local minc=0
	local maxc=99
	if min then
		local exct=1
		if min-exct>minc then minc=min-exct end
		if max-exct<maxc then maxc=max-exct end
		if minc>maxc then return false end
	end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,8173184) then
		Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
	end
	if smat and not s.SMatCheck(smat,c) then
		Duel.ResetFlagEffect(tp,8173184+1)
		return false
	end
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1:Filter(s.SMatCheck,nil,c)
		mgchk=true
	else
		mg=s.SMatCatch(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	Auxiliary.SubGroupCaptured=Group.CreateGroup()
	SNNM.SubGroupParams={s.slfilter,s.SLevelCal,nil,true,true,{c},{c}}
	aux.GCheckAdditional=s.gcheck(c)
	local res=SNNM.SelectSubGroup(mg,tp,s.syngoal,Duel.IsSummonCancelable(),2,#mg,c,smat,tp,mgchk)
	aux.GCheckAdditional=nil
	SNNM.SubGroupParams={}
	Duel.ResetFlagEffect(tp,8173184+1)
	return res and mg:IsExists(s.ntfilter,1,nil,c,mg)
end
function s.ntfilter(c,sc,mg)
	return s.TunerCheck(c,sc) and mg:IsExists(s.NotTunerCheck,1,c,sc)
end
function s.syngoal(g,sc,smat,tp,mgchk)
	if Duel.GetLocationCountFromEx(tp,tp,g,sc)<=0 then return false end
	if not g:IsExists(s.ntfilter,1,nil,sc,g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if Duel.IsPlayerAffectedByEffect(tp,8173184)
		and not g:IsExists(aux.Tuner(Card.IsSetCard,0x2),1,nil,sc) then return false end
	if not SNNM.IsInTable(sc:GetLevel(),s.lvplus(g,sc))
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or (#g)*2~=sc:GetLevel())
		then return false end
	if not (mgchk or aux.SynMixHandCheck(g,tp,sc)) then return false end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le,sc) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
function s.SynMixTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local minc=0
	local maxc=99
	local gc=nil
	if min then
		local exct=1
		if min-exct>minc then minc=min-exct end
		if max-exct<maxc then maxc=max-exct end
		if minc>maxc then return false end
	end
	if Duel.IsPlayerAffectedByEffect(tp,8173184) then
		Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
	end
	local g=Group.CreateGroup()
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1:Filter(s.SMatCheck,nil,c)
		mgchk=true
	else
		mg=s.SMatCatch(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	SNNM.SubGroupParams={s.slfilter,s.SLevelCal,nil,true,false,{c},{c}}
	aux.GCheckAdditional=s.gcheck(c)
	local sg=SNNM.SelectSubGroup(mg,tp,s.syngoal,Duel.IsSummonCancelable(),2,#mg,c,smat,tp,mgchk)
	aux.GCheckAdditional=nil
	SNNM.SubGroupParams={}
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.SynMixOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local rg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local res
	local mrg=rg:Filter(aux.NOT(Card.IsAbleToRemove),nil,tp,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	if #mrg>0 then res=true end
	local et={}
	s[0]={} s[1]={}
	for tc in aux.Next(mrg) do
		local le1={tc:IsHasEffect(EFFECT_CANNOT_REMOVE)}
		for _,v in pairs(le1) do
			table.insert(et,v)
			local con=v:GetCondition() or aux.TRUE
			s[0][v]=con
			s[1][v]=0
			v:SetCondition(aux.FALSE)
		end
		local le2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_REMOVE)}
		for _,v in pairs(le2) do
			table.insert(et,v)
			local tg=v:GetTarget() or aux.TRUE
			if tg(v,tc,tp,REASON_MATERIAL+REASON_SYNCHRO,e) then
				s[0][v]=tg
				s[1][v]=1
				v:SetTarget(s.chtg(tg,tc))
			end
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	for _,v in pairs(et) do
		local ch=s[0][v]
		if s[1][v]==0 then v:SetCondition(ch) else v:SetTarget(ch) end
	end
	s[0]={} s[1]={}
	local fg=Group.__sub(g,rg)
	if fg:IsExists(s.afffilter,1,nil,c,tp) then res=true end
	Duel.SendtoGrave(fg,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
	if res then
		local g=Duel.SelectMatchingCard(tp,s.lindfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
		if #g>0 then Duel.SendtoGrave(g,REASON_RULE) end
	end
end
function s.afffilter(c,syncard,tp)
	if c:IsControler(tp) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_SYNCHRO_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		if aux.GetValueType(tf)=="function" then
			if tf(te,syncard) then return false end
		else
			if tf~=0 then return false end
		end
	end
	return true
end
function s.chtg(tg,tc)
	return  function(e,c,rp,r,re)
				return not tc and tg(e,c,rp,r,re)
	end
end
if not s then return end
function s.initial_effect(c)
	Necrocean.AddSynchroMixProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)end)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsOriginalCodeRule(22702055) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_FZONE)
		e1:SetCode(EFFECT_SELF_DESTROY)
		e1:SetCondition(s.sdcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function s.sdcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
