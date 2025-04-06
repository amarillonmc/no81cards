--回烙印
local m=11561070
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--toh
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,11561070)
	e2:SetCondition(c11561070.spcon)
	e2:SetTarget(c11561070.sptg)
	e2:SetOperation(c11561070.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0xff,0)
	e5:SetTarget(c11561070.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	if not c11561070.global_check then
		c11561070.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BE_MATERIAL)
		ge1:SetOperation(c11561070.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c11561070.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and (r==REASON_FUSION or tc:GetReasonCard():IsType(TYPE_FUSION)) and tc:IsFaceupEx() then
		tc:RegisterFlagEffect(11561070,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11561070,2)) end
		tc=eg:GetNext()
	end
end
function c11561070.eftg(e,c)
	return c:IsCode(68468459)
end
function c11561070.thfilter(c)
	return c:IsFaceupEx() and c:GetFlagEffect(11561070)>0 and c:IsAbleToHand()
end
function c11561070.tgfilter(c)
	return (c:IsCode(68468459) or aux.IsCodeListed(c,68468459)) and c:IsAbleToGrave()
end
function c11561070.cnfilter(c)
	return aux.TRUE -- c:IsFaceup() and ((c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c11561070.tgfilter,tp,LOCATION_DECK,0,1,nil)) or (not c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c11561070.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)))
end
function c11561070.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11561070.cnfilter,1,nil,tp) and eg:GetCount()==1
end
function c11561070.ttfilter1(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c11561070.ttfilter2(c)
	return not c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c11561070.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return (Duel.IsExistingMatchingCard(c11561070.ttfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c11561070.tgfilter,tp,LOCATION_DECK,0,1,nil)) or (Duel.IsExistingMatchingCard(c11561070.ttfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c11561070.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,0,0)
   -- if not tc:IsType(TYPE_FUSION) then
   --   e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
   --   Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,0,0)
   -- elseif tc:IsType(TYPE_FUSION) then
   --   e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
   --   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,0,0)
   -- end
end
function c11561070.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c11561070.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11561070.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local aaa=0
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c11561070.ttfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c11561070.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(11561070,3)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c11561070.ttfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c11561070.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		ops[off]=aux.Stringid(11561070,4)
		opval[off-1]=2
		off=off+1
	end
	Debug.Message(1)
	if off==1 then return end
	Debug.Message(2)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	Debug.Message(opval[op])
	if opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local ttc=Duel.SelectMatchingCard(tp,c11561070.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
		if ttc and Duel.SendtoHand(ttc,nil,REASON_EFFECT)~=0 then
			aaa=1
		end
	elseif opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local ttc=Duel.SelectMatchingCard(tp,c11561070.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if ttc and Duel.SendtoGrave(ttc,REASON_EFFECT)~=0 then
			aaa=1
		end
	end
	if aaa==1 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c11561070.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11561070.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		if res and Duel.SelectYesNo(tp,aux.Stringid(11561070,1)) then

		Duel.BreakEffect()

	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c11561070.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c11561070.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c11561070.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
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



		end
	end



end
--end














