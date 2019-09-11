--铃仙
function c11200074.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11200074.SynMixCondition(c11200074.SycFilter1,nil,nil,c11200074.SycFilter2,1,1,nil))
	e1:SetTarget(c11200074.SynMixTarget(c11200074.SycFilter1,nil,nil,c11200074.SycFilter2,1,1,nil))
	e1:SetOperation(c11200074.SynMixOperation(c11200074.SycFilter1,nil,nil,c11200074.SycFilter2,1,1,nil))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c11200074.tg2)
	e2:SetValue(700)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11200074,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c11200074.con3)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c11200074.tg3)
	e3:SetOperation(c11200074.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11200074,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c11200074.con4)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c11200074.tg3)
	e4:SetOperation(c11200074.op3)
	c:RegisterEffect(e4)
--
end
--
c11200074.xig_ihs_0x132=1
--
function c11200074.SycFilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c.xig_ihs_0x132
end
function c11200074.SycFilter2(c)
	return not c:IsSynchroType(TYPE_TUNER)
end
--
function c11200074.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)
	return  
	function(e,c,smat,mg1)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg
		if mg1 then mg=mg1
		else mg=c11200074.GetSynMaterials(tp,c) end
		if smat~=nil then mg:AddCard(smat) end
		return mg:IsExists(c11200074.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc)
	end
end
--
function c11200074.SynMaterialFilter(c,syncard)
	return c:IsFaceup() and (c:IsCanBeSynchroMaterial(syncard) or (c.xig_ihs_0x132 and c:IsType(TYPE_MONSTER)))
end
function c11200074.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(c11200074.SynMaterialFilter,tp,LOCATION_MZONE,0,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return mg
end
--
function c11200074.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc)
	return (not f1 or f1(c,syncard))
		and mg:IsExists(c11200074.SynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c,gc)
end
--
function c11200074.SynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1,gc)
	if f2 then
		return f2(c,syncard,c1)
			and mg:IsExists(c11200074.SynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c,gc)
	else
		return mg:IsExists(c11200074.SynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil,gc)
	end
end
--
function c11200074.SynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc)
	if f3 then
		return f3(c,syncard,c1,c2)
			and mg:IsExists(c11200074.SynMixFilter4,1,Group.FromCards(c1,c2,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc)
	else
		return mg:IsExists(c11200074.SynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil,gc)
	end
end
--
function c11200074.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,nil)
	end
	return c11200074.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc)
end
--
function c11200074.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc)
	local tp=syncard:GetControler()
	for c in aux.Next(sg1) do
		mg:RemoveCard(c)
	end
	local sg=Group.CreateGroup()
	if minc==0 and c11200074.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc) then return true end
	if maxc==0 then return false end
	return mg:IsExists(c11200074.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc)
end
--
function c11200074.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc)
	sg:AddCard(c)
	ct=ct+1
	local res=c11200074.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc)
		or (ct<maxc and mg:IsExists(c11200074.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c11200074.GetSynchroLevelCheck1(c,syncard,num,tc)
	return c:GetSynchroLevel(syncard)==num
end
function c11200074.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if g:GetCount()<1 then return false end
	local checknum=0
--
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
--
	if not g:IsExists(Card.IsSynchroType,1,nil,TYPE_TUNER) then
		if tc1.xig_ihs_0x132 and tc2 and tc2:GetSynchroLevel(syncard)==(syncard:GetLevel()-4) then checknum=1 end
		if tc2 and tc2.xig_ihs_0x132 and tc1:GetSynchroLevel(syncard)==(syncard:GetLevel()-4) then checknum=1 end
	end
--
	if g:IsExists(Card.IsSynchroType,1,nil,TYPE_TUNER) then
		if tc1.xig_ihs_0x132
			and tc1:IsSynchroType(TYPE_TUNER)
			and tc2 and ((tc2:GetSynchroLevel(syncard)==(syncard:GetLevel()-tc1:GetSynchroLevel(syncard))) or (tc2:GetSynchroLevel(syncard)==(syncard:GetLevel()-4))) then
			checknum=1
		end
		if tc1.xig_ihs_0x132
			and tc2 and tc2:IsSynchroType(TYPE_TUNER)
			and tc2:GetSynchroLevel(syncard)==(syncard:GetLevel()-tc1:GetSynchroLevel(syncard)) then
			checknum=1
		end
		if tc2 and tc2.xig_ihs_0x132
			and tc2:IsSynchroType(TYPE_TUNER)
			and ((tc1:GetSynchroLevel(syncard)==(syncard:GetLevel()-tc2:GetSynchroLevel(syncard))) or (tc1:GetSynchroLevel(syncard)==(syncard:GetLevel()-4))) then
			checknum=1
		end
		if tc2 and tc2.xig_ihs_0x132
			and tc1:IsSynchroType(TYPE_TUNER)
			and tc1:GetSynchroLevel(syncard)==(syncard:GetLevel()-tc1:GetSynchroLevel(syncard)) then
			checknum=1
		end
		if tc2 and not (tc1.xig_ihs_0x132 or tc2.xig_ihs_0x132)
			and (tc1:GetSynchroLevel(syncard)+tc2:GetSynchroLevel(syncard))==syncard:GetLevel() then
			checknum=1
		end
	end
--
	if checknum~=1 then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(aux.SynLimitFilter,1,c,hf,he) then return false end
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
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
--
function c11200074.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1)
		local g=Group.CreateGroup()
		local mg
		if mg1 then mg=mg1
		else mg=c11200074.GetSynMaterials(tp,c) end
		if smat~=nil then mg:AddCard(smat) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local c1=mg:FilterSelect(tp,c11200074.SynMixFilter1,1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc):GetFirst()
		g:AddCard(c1)
		if f2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local c2=mg:FilterSelect(tp,c11200074.SynMixFilter2,1,1,c1,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc):GetFirst()
			g:AddCard(c2)
			if f3 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local c3=mg:FilterSelect(tp,c11200074.SynMixFilter3,1,1,Group.FromCards(c1,c2),f3,f4,minc,maxc,c,mg,smat,c1,c2,gc):GetFirst()
				g:AddCard(c3)
			end
		end
		local g4=Group.CreateGroup()
		for i=0,maxc-1 do
			local mg2=mg:Clone()
			if f4 then
				mg2=mg2:Filter(f4,nil)
			end
			local cg=mg2:Filter(c11200074.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc)
			if cg:GetCount()==0 then break end
			local minct=1
			if c11200074.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc) then
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
--
function c11200074.SynMixOperation(f1,f2,f3,f4,minct,maxc,gc)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
		g:DeleteGroup()
	end
end
--
function c11200074.tg2(e,c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
--
function c11200074.con3(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsRace(RACE_BEAST) and ec:IsAttribute(ATTRIBUTE_LIGHT)
end
--
function c11200074.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
--
function c11200074.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then Duel.Destroy(g,REASON_EFFECT) end
end
--
function c11200074.tfilter4(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE)
end
function c11200074.con4(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c11200074.tfilter4,1,nil,tp) and Duel.IsChainNegatable(ev)
end

