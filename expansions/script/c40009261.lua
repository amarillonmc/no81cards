--光影交织之刻
local m=40009261
local cm=_G["c"..m]
function cm.BLASTER(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTER
end
function cm.BLASTERBlade(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTERBlade
end
function cm.BLASTERdark(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTERdark
end
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.disrmcon)
	e1:SetTarget(cm.efftg)
	e1:SetOperation(cm.effop)
	c:RegisterEffect(e1)  
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+2)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)  
end
function cm.ccfilter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and cm.BLASTER(c)
end
function cm.ccfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and cm.BLASTER(c)
end
function cm.cfilter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and cm.BLASTER(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.ccfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cfilter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and cm.BLASTER(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.ccfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function cm.disrmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.ccfilter1,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(cm.ccfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
		local b1=Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,m)==0
		local b2=Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,m+1)==0
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
		local b1=Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,m)==0
		local b2=Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,m+1)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.exconfilter(c)
	return (cm.BLASTERBlade(c) or cm.BLASTERdark(c)) and c:IsFaceup()
end
function cm.excon(tp)
	return Duel.IsExistingMatchingCard(cm.exconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fexfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.frcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function cm.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		if cm.excon(tp) then
			local mg2=Duel.GetMatchingGroup(cm.fexfilter,tp,LOCATION_DECK,0,nil)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				aux.FCheckAdditional=cm.frcheck
				aux.GCheckAdditional=cm.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
	local exmat=false
	if cm.excon(tp) then
		local mg2=Duel.GetMatchingGroup(cm.fexfilter,tp,LOCATION_DECK,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=cm.frcheck
		aux.GCheckAdditional=cm.gcheck
	end
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=cm.fcheck
				aux.GCheckAdditional=cm.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
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
end









