--璀璨夺目的韶光
function c9910455.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910455+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910455.target)
	e1:SetOperation(c9910455.activate)
	c:RegisterEffect(e1)
end
function c9910455.filter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c9910455.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9910455.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local res=Duel.IsExistingMatchingCard(c9910455.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9910455.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910455.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9910455.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c9910455.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9910455.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
		if tc:IsSetCard(0x9950) and c:IsFaceup() and c:IsRelateToEffect(e)
			and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			c:CancelToGrave()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(9910455,0))
			e1:SetCategory(CATEGORY_COUNTER)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_CHAINING)
			e1:SetRange(LOCATION_SZONE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetCountLimit(1)
			e1:SetTarget(c9910455.cttg)
			e1:SetOperation(c9910455.ctop)
			c:RegisterEffect(e1)
		end
	end
end
function c9910455.cfilter1(c,tp,col)
	return c:IsSetCard(0x9950) and c:IsFaceup() and aux.GetColumn(c,tp)==col
end
function c9910455.cfilter2(c,tp,col)
	return c:IsCanAddCounter(0x1950,1) and aux.GetColumn(c,tp)==col
end
function c9910455.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag=true
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	local col=0
	if loc&LOCATION_MZONE~=0 then
		col=aux.MZoneSequence(seq)
	elseif loc&LOCATION_SZONE~=0 then
		if seq>4 then flag=false end
		col=aux.SZoneSequence(seq)
	else
		flag=false
	end
	if flag and p==1-tp then col=4-col end
	if chk==0 then return flag
		and Duel.IsExistingMatchingCard(c9910455.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,col)
		and Duel.IsExistingMatchingCard(c9910455.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,col) end
	e:SetLabel(col+1)
end
function c9910455.ctop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if not label or label==0 then return end
	local g=Duel.GetMatchingGroup(c9910455.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,label-1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1950,1)
		tc=g:GetNext()
	end
end
