--幻兽机 金雕白矛隼
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.SynMixCondition(s.matfilter,nil,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WIND),1,99,gc))
	e1:SetTarget(s.SynMixTarget(s.matfilter,nil,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WIND),1,99,gc))
	e1:SetOperation(s.SynMixOperation(s.matfilter,nil,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WIND),1,99,gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	c:EnableReviveLimit()
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.lvcon)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(s.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsPlayerCanSpecialSummonMonster(tp,7472629,0x101b,TYPES_TOKEN_MONSTER,0,0,1,RACE_MACHINE,ATTRIBUTE_WIND) or Duel.IsPlayerCanSpecialSummonMonster(tp,7472629,0x101b,TYPES_TOKEN_MONSTER,0,0,2,RACE_MACHINE,ATTRIBUTE_WIND) or Duel.IsPlayerCanSpecialSummonMonster(tp,7472629,0x101b,TYPES_TOKEN_MONSTER,0,0,3,RACE_MACHINE,ATTRIBUTE_WIND)) end
	local lvt={}
	local pc=1
	for i=1,3 do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,7472629,0x101b,TYPES_TOKEN_MONSTER,0,0,i,RACE_MACHINE,ATTRIBUTE_WIND) then lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	e:SetLabel(lv)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,0x101b)))
	e1:SetValue(s.fuslimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(s.sumlimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e4,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,7472629,0x101b,TYPES_TOKEN_MONSTER,0,0,lv,RACE_MACHINE,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,7472629)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		token:RegisterEffect(e1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.fuslimit(e,c,sumtype)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer()) and sumtype==SUMMON_TYPE_FUSION
end
function s.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
	--synchro summon
function s.matfilter(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x101b)
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
function s.SynMixOperation(f1,f2,f3,f4,minct,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
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
	if c==c1 and c:IsSetCard(0x101b) then
		local lv=c:GetSynchroLevel(syncard)
		if lv~=0 and c:IsType(TYPE_TUNER) then
			return (2<<16)+lv
		else
			return 2
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
