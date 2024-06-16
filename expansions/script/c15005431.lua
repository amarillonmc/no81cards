local m=15005431
local cm=_G["c"..m]
cm.name="泣声统治"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.indtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--fusion
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,15005431)
	e4:SetCondition(cm.spcon)
	e4:SetCost(cm.spcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local g=tc:GetMaterial()
		if g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and tc:IsSummonType(SUMMON_TYPE_FUSION) then
			tc:RegisterFlagEffect(15005431,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		tc=eg:GetNext()
	end
end
function cm.indtg(e,c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup() and c:GetFlagEffect(15005431)~=0
end
function cm.xfilter(c,e,tp,m,f,gc,chkf)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil)
	if mg2:GetCount()>0 then
		mg1:Merge(mg2)
	end
	aux.FCheckAdditional=cm.fcheck(c)
	local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,c,chkf)
		end
	end
	aux.FCheckAdditional=nil
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsCanBeEffectTarget(e) and res
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	return eg:IsExists(cm.xfilter,1,nil,e,tp,nil,nil,chkc,chkf)
end
function cm.tgxfilter(c,e,tp,m,f,gc,chkf,eg)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil)
	if mg2:GetCount()>0 then
		mg1:Merge(mg2)
	end
	aux.FCheckAdditional=cm.fcheck(c)
	local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,c,chkf)
		end
	end
	aux.FCheckAdditional=nil
	return res and eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function cm.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function cm.chkfilter(c,tp)
	return c:IsOnField() and c:IsControler(1-tp)
end
function cm.fcheck(c)
	return function(tp,sg,fc)
				return not sg:IsExists(cm.chkfilter,1,c,tp)
			end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local chkf=tp
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgxfilter(chkc,e,tp,nil,nil,chkc,chkf,eg) end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tgxfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,nil,nil,chkc,chkf,eg)
	end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,cm.tgxfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,nil,nil,chkc,chkf,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	local chkf=tp
	if Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)~=0 then return end
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(cm.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil):Filter(cm.filter1,nil,e)
	if mg2:GetCount()>0 then
		mg1:Merge(mg2)
	end
	aux.FCheckAdditional=cm.fcheck(c)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end