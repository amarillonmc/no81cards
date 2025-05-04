--曙龙勒功坛
function c9911405.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--protection
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9911405)
	e2:SetCost(c9911405.protcost)
	e2:SetOperation(c9911405.protop)
	c:RegisterEffect(e2)
	--search/fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911405,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9911406)
	e3:SetCondition(c9911405.thspcon)
	e3:SetTarget(c9911405.thsptg)
	e3:SetOperation(c9911405.thspop)
	c:RegisterEffect(e3)
end
c9911405.fusion_effect=true
function c9911405.protcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9911405.protop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c9911405.actop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(9911405,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function c9911405.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x6951) and ep==tp then
		Duel.SetChainLimit(c9911405.chainlm)
	end
end
function c9911405.chainlm(e,rp,tp)
	return tp==rp
end
function c9911405.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_DISCARD)
end
function c9911405.thspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911405.cfilter,1,nil,tp)
end
function c9911405.thfilter(c)
	return c:IsSetCard(0x6954,0xa958) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9911405.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c9911405.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c9911405.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9911405.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c9911405.fcheck(tp,sg,fc)
	return sg:GetCount()==2
end
function c9911405.thsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res1=Duel.IsExistingMatchingCard(c9911405.thfilter,tp,LOCATION_DECK,0,1,nil)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9911405.filter0,nil)
	local mg2=Duel.GetMatchingGroup(c9911405.filter3,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	aux.FGoalCheckAdditional=c9911405.fcheck
	local res2=Duel.IsExistingMatchingCard(c9911405.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res2 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res2=Duel.IsExistingMatchingCard(c9911405.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
		aux.FGoalCheckAdditional=nil
	if chk==0 then return res1 or res2 end
	local op=aux.SelectFromOptions(tp,
			{res1,aux.Stringid(9911405,2),1},
			{res2,aux.Stringid(9911405,3),2})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c9911405.thspop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9911405.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif e:GetLabel()==2 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c9911405.filter1,nil,e)
		local mg2=Duel.GetMatchingGroup(c9911405.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		aux.FGoalCheckAdditional=c9911405.fcheck
		local sg1=Duel.GetMatchingGroup(c9911405.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg3=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c9911405.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
end
