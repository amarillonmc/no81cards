--狂野伯吉斯异兽·马尔三叶形虫
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--特招
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.spcost)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	---不能盖放
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(0xff)
	e3:SetTargetRange(1,1)
	e3:SetTarget(s.atarget)
	c:RegisterEffect(e3)
	--手发
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
	--次数限制
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end

function s.atarget(e,c)
	return c==e:GetHandler()
end
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end

function s.tgfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,65811000,RESET_PHASE+PHASE_END,0,1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)+Duel.GetTurnCount()>Duel.GetFlagEffect(tp,65811000)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xd4,TYPES_NORMAL_TRAP_MONSTER,1200,0,2,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.linkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsLinkSummonable(nil)
end
function s.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil)
end
function s.synchrofilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil)
end
function s.filter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xd4,TYPES_NORMAL_TRAP_MONSTER,1200,0,2,RACE_AQUA,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(s.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local linkg=Duel.GetMatchingGroup(s.linkfilter,tp,LOCATION_EXTRA,0,nil)
		local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		local Synchrog=Duel.GetMatchingGroup(s.synchrofilter,tp,LOCATION_EXTRA,0,nil)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		local fusiong=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				fusiong=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
			end
		end
        local g114514=Group.CreateGroup()
        if linkg then g114514:Merge(linkg) end
        if xyzg then g114514:Merge(xyzg) end
        if Synchrog then g114514:Merge(Synchrog) end
        if fusiong then g114514:Merge(fusiong) end
        if g114514:GetCount()<=0 then return end
        if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g114514:Select(tp,0,1,nil):GetFirst()
		if tc then 
		local b1=tc:IsType(TYPE_FUSION)
		local b2=tc:IsType(TYPE_SYNCHRO)
		local b3=tc:IsType(TYPE_XYZ)
		local b4=tc:IsType(TYPE_LINK)
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(65811000,2)},
			{b2,aux.Stringid(65811000,3)},
			{b3,aux.Stringid(65811000,4)},
			{b4,aux.Stringid(65811000,5)},
			{true,aux.Stringid(65811000,6)})
		if op~=5 then Duel.BreakEffect() end
		if op==1 then
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
		elseif op==2 then
			Duel.SynchroSummon(tp,tc,nil)
		elseif op==3 then
			Duel.XyzSummon(tp,tc,nil)
		elseif op==4 then
			Duel.LinkSummon(tp,tc,nil)
		end
		end
	end
end
function s.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end
