--悸动之幽寂 塔丝亚维尔
local s,id,o=GetID()


--Bug repair
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



function s.initial_effect(c)
	aux.AddCodeList(c,65807000)
	c:EnableReviveLimit()
	
	-- 同调召唤条件
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.SynMixCondition(s.matfilter,nil,nil,s.matfilter1,1,99,gc))
	e0:SetTarget(s.SynMixTarget(s.matfilter,nil,nil,s.matfilter1,1,99,gc))
	e0:SetOperation(s.SynMixOperation(s.matfilter,nil,nil,s.matfilter1,1,99,gc))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_DECK)
	e3:SetCondition(s.spcon)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id+2+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(s.tscon)
	e4:SetCost(s.spcost)
	e4:SetTarget(s.tstg)
	e4:SetOperation(s.tsop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	
	--add type & attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(s.tnop)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(3)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end





function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.eqfilter(c,e,tp)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsType(TYPE_MONSTER)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,c,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),2)
	if ft<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or Duel.GetMatchingGroupCount(s.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,c,e,tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,ft,c,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,false,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.EquipComplete()
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end


function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA) and not eg:IsContains(e:GetHandler())
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,65807000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler(),tp)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.tscon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rp==tp and r&REASON_COST>0 and aux.IsCodeListed(rc,65807000)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function s.splimit(e,c)
	return not (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT))
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end







--同调
	--synchro summon
function s.matfilter(c)
	return (c:IsSynchroType(TYPE_TUNER) or c:IsSummonLocation(LOCATION_EXTRA)) and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.matfilter1(c)
	return aux.IsCodeListed(c,65807000) and aux.NonTuner(nil)
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
	if c==c1 and c:IsSummonLocation(LOCATION_EXTRA) then
		local lv=c:GetSynchroLevel(syncard)
		if lv~=0 and c:IsType(TYPE_TUNER) then
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