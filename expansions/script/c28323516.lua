--魔魅魔幻魔女
function c28323516.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28323516.target)
	e1:SetOperation(c28323516.activate)
	c:RegisterEffect(e1)
	--Magical Mystic Monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(c28323516.mmmcon)
	e2:SetOperation(c28323516.mmmop)
	c:RegisterEffect(e2)
end
function c28323516.mfilter(c,e)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_DECK) or c:IsFacedown()) and c:IsAbleToGrave() and c:IsCanBeFusionMaterial() and (not e or not c:IsImmuneToEffect(e))
end
function c28323516.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:CheckFusionMaterial(m,nil,chkf) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c28323516.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsOnField,nil)==1 and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1 and sg:GetClassCount(Card.GetFusionCode)==1
end
function c28323516.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c28323516.mfilter,tp,LOCATION_MZONE+LOCATION_DECK,0,nil)
		aux.FGoalCheckAdditional=c28323516.fcheck
		local res=Duel.IsExistingMatchingCard(c28323516.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c28323516.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FGoalCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c28323516.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c28323516.mfilter,tp,LOCATION_MZONE+LOCATION_DECK,0,nil,e)
	aux.FGoalCheckAdditional=c28323516.fcheck
	local sg1=Duel.GetMatchingGroup(c28323516.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c28323516.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FGoalCheckAdditional=nil
end
function c28323516.mmmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
end
function c28323516.mmmop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetLabelObject(e1)
	e0:SetOperation(c28323516.regop)
	Duel.RegisterEffect(e0,tp)
end
function c28323516.regop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then te:Reset() end
	e:Reset()
end
