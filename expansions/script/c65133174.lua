--幻叙支配者-水仙
local s,id,o=GetID()
local _IsCanBeSynchroMaterial=Card.IsCanBeSynchroMaterial
function Card.IsCanBeSynchroMaterial(c,...)
	local ext_params={...}
	if #ext_params==0 then return _IsCanBeSynchroMaterial(c,...) end
	local sc=ext_params[1]
	local tp=sc:GetControler()
	if c:IsLocation(LOCATION_MZONE) and not c:IsControler(tp) then
		local mg=Duel.GetSynchroMaterial(tp)
		return mg:IsContains(c) and _IsCanBeSynchroMaterial(c,sc,...)
	end
	return _IsCanBeSynchroMaterial(c,...)
end
--
function s.initial_effect(c)
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.SynMixCondition(s.matfilter,nil,nil,aux.NonTuner(Card.IsSetCard,0x838),1,99,gc))
	e0:SetTarget(s.SynMixTarget(s.matfilter,nil,nil,aux.NonTuner(Card.IsSetCard,0x838),1,99,gc))
	e0:SetOperation(aux.SynOperation(nil,aux.NonTuner(Card.IsSetCard,0x838),1,99))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetValue(s.hspval)
	c:RegisterEffect(e1)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.effop)
	c:RegisterEffect(e5)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(id)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
end
--synchro summon
function s.matfilter(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x838)
end
function s.SynMaterialFilter(c,syncard)
	return c:IsFaceup() and (c:IsCanBeSynchroMaterial(syncard) or c:GetSynchroLevel(syncard)==0)
end
function s.SynLimitFilter(c,f,e,syncard)
	return f and not f(e,c,syncard)
end
function s.GetSynchroLevelFlowerCardian(c)
	return 2
end
function s.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(s.SynMaterialFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return mg
end
function s.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)
	return  function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
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
				return mg:IsExists(s.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk)
			end
end
function s.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
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
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local c1=mg:FilterSelect(tp,s.SynMixFilter1,1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk):GetFirst()
				g:AddCard(c1)
				local g4=Group.CreateGroup()
				for i=0,maxc-1 do
					local mg2=mg:Clone()
					if f4 then
						mg2=mg2:Filter(f4,g,c)
					else
						mg2:Sub(g)
					end
					local cg=mg2:Filter(s.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,c1,gc,mgchk)
					if cg:GetCount()==0 then break end
					local minct=1
					if s.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,c1,gc,mgchk) then
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local tg=cg:Select(tp,minct,1,nil)
					if tg:GetCount()==0 then break end
					g4:Merge(tg)
				end
				g:Merge(g4)
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function s.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk)
	return (not f1 or f1(c,syncard)) and mg:IsExists(s.SynMixFilter4,1,c,f4,minc,maxc,syncard,mg,smat,c,gc,mgchk)
end
function s.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,gc,mgchk)
	if f4 and not f4(c,syncard,c1) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard)
	else
		mg:Sub(sg)
	end
	return s.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,c1,gc,mgchk)
end
function s.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,c1,gc,mgchk)
	local tp=syncard:GetControler()
	local sg=Group.CreateGroup()
	if minc<=0 and s.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,c1,gc,mgchk) then return true end
	if maxc==0 then return false end
	return mg:IsExists(s.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,c1,gc,mgchk)
end
function s.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,c1,gc,mgchk)
	sg:AddCard(c)
	ct=ct+1
	local res=s.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,c1,gc,mgchk)
		or (ct<maxc and mg:IsExists(s.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,c1,gc,mgchk))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function s.val(c,syncard,c1)
	if c:IsSetCard(0x838) then
		local lv=c:GetSynchroLevel(syncard)
		if lv~=0 then
			return (3<<16)+lv
		else
			return 3
		end
	else
		return c:GetSynchroLevel(syncard)
	end
end
function s.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,c1,gc,mgchk)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if not g:CheckWithSumEqual(s.val,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard,c1)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(s.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 and not mgchk then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(s.SynLimitFilter,1,c,hf,he,syncard) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(s.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
function s.hspval(e,c)
	return 0,0x4
end
function s.spcfilter(c)
	return c:IsSetCard(0x838) and not c:IsPublic()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,0x4)>0
		and Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_HAND,0,1,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spcfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
s.check={}
function s.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and not c:IsHasEffect(id)
end
function s.gfilter(c,g)
	if not g then return true end
	return s.copyfilter(c) and not g:IsContains(c)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)==0 then
		s.check[c]={}
		c:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,0,1)
	end
	s.check[c]=s.check[c] or {}
	local exg=Group.CreateGroup()
	for tc,cid in pairs(s.check[c]) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local dg=exg:Filter(s.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(s.check[c][tc],RESET_COPY)
		exg:RemoveCard(tc)
		s.check[c][tc]=nil
	end
	local cg=g:Filter(s.gfilter,nil,exg)
	for tc in aux.Next(cg) do
		local flag=true
		if #s.check[c]==0 then
			s.check[c][tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		end
		for ac,cid in pairs(s.check[c]) do
			if tc==ac then
				flag=false
			end
		end
		if flag==true then
			s.check[c][tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		end
	end
end