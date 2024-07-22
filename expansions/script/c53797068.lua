if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
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
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	s.tsg=g
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.setcon2)
	e3:SetTarget(s.settg2)
	e3:SetOperation(s.setop2)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		if not c45045866 then
			Duel.DisableActionCheck(true)
			Duel.CreateToken(0,45045866)
			Duel.DisableActionCheck(false)
		end
		if c45045866.card_code_list==nil then
			c45045866.card_code_list={}
			for _,code in ipairs{18828179,81434470} do
				c45045866.card_code_list[code]=true
			end
		else
			for _,code in ipairs{18828179,81434470} do
				c45045866.card_code_list[code]=true
			end
		end
	end
end
function s.synfilter(c,syncard,g)
	local res
	for tc in aux.Next(g) do if aux.IsCodeListed(tc,c:GetCode()) then res=true end end
	return c:IsCanBeSynchroMaterial(syncard,c) and res
end
function s.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(aux.SynMaterialFilter,nil,syncard)
	local t={}
	local ng=mg:Filter(aux.NonTuner,nil,nil)
	if #ng>0 then
		ng:KeepAlive()
		local mg3=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_DECK,0,nil,syncard,ng)
		local mg4=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_HAND,0,nil,syncard,ng)
		ng:DeleteGroup()
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
		local tsg=s.tsg
		tsg:Clear()
		tsg:Merge(g4:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK))
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
	if aux.NonTuner(c1) then
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
	if aux.NonTuner(c1) then
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
function s.f4(c,syncard,c1,c2,c3)
	return c:IsTuner(syncard) or (c1 and aux.IsCodeListed(c1,c:GetCode()))
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	for tc in aux.Next(s.tsg) do table.insert(t,tc:GetOriginalCode()) end
	local tsg=s.tsg
	tsg:Clear()
	if #t<1 then return false end
	e:SetLabel(table.unpack(t))
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.setfilter(c,e,tp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	return (ft>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE)) or c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(1-tp,s.setfilter,1-tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		local op=aux.SelectFromOptions(1-tp,{(ft>0 and sc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE)),aux.Stringid(id,1)},{sc:IsSSetable(),aux.Stringid(id,2)})
		if op==1 then
			Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(tp,sc)
		elseif op==2 then Duel.SSet(1-tp,sc) end
	end
	if e:GetHandler():IsRelateToEffect(e) then for _,v in ipairs({e:GetLabel()}) do e:GetHandler():CopyEffect(v,RESET_EVENT+RESETS_STANDARD) end end
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousControler(1-tp)
end
function s.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local g2=g:Filter(aux.NOT(Card.IsPublic),nil)
		local g1=Group.__sub(g,g2):Filter(s.setfilter,nil,e,tp)
		return #g1>0 or (#g2>0 and ((Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(1-tp)) or Duel.IsPlayerCanSSet(1-tp)))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.setop2(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	local sc=g:FilterSelect(1-tp,s.setfilter,1,1,nil,e,tp):GetFirst()
	if sc then
		local res=0
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		local op=aux.SelectFromOptions(1-tp,{(ft>0 and sc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE)),aux.Stringid(id,1)},{sc:IsSSetable(),aux.Stringid(id,2)})
		if op==1 then
			res=Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(tp,sc)
		elseif op==2 then res=Duel.SSet(1-tp,sc) end
		local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
		if res>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local rg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(rg)
			Duel.BreakEffect()
			Duel.SendtoHand(rg,nil,REASON_EFFECT)
		end
	end
end
