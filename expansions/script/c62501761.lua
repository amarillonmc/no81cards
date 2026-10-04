--蚀痕无命 生负蚀印
function c62501761.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(62501761,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCost(c62501761.excost)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c62501761.target)
	e1:SetOperation(c62501761.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501761)
	e2:SetTarget(c62501761.rmtg)
	e2:SetOperation(c62501761.rmop)
	c:RegisterEffect(e2)
	c62501761.remove_event_effect=e2
end
function c62501761.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckAsCost()
end
function c62501761.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c62501761.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,3,3,nil)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c62501761.thfilter(c,chk)
	return c:IsSetCard(0xea4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))-- and c:IsFaceupEx() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c62501761.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=c62501761.fstg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetFlagEffect(tp,62501761)==0
	local b2=Duel.IsExistingMatchingCard(c62501761.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,0) and (Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 or not e:IsCostChecked()) and Duel.GetFlagEffect(tp,62501761+1)==0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(62501761,0)},
		{b2,aux.Stringid(62501761,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		Duel.RegisterFlagEffect(tp,62501761,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		if e:IsCostChecked() then
			Duel.DisableShuffleCheck()
			Duel.Remove(Duel.GetDecktopGroup(tp,3),POS_FACEDOWN,REASON_COST)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
		Duel.RegisterFlagEffect(tp,62501761+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function c62501761.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		c62501761.fsop(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c62501761.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,1):GetFirst()
		if not tc then return end
		--Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c62501761.filter1(c,tp,e)
	return (not e or not c:IsImmuneToEffect(e)) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c62501761.filter2(c,e,tp,m,f,chkf)
	return c:IsSetCard(0xea4) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c62501761.fexfilter(c,tp)
	return c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c62501761.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,0,10,nil)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c62501761.filter1,nil,tp)
		if check then
			local mg2=Duel.GetMatchingGroup(c62501761.fexfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
			end
		end
		local res=Duel.IsExistingMatchingCard(c62501761.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c62501761.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
end
function c62501761.fsop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,0,10,nil)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c62501761.filter1,nil,tp,e)
	if check then
		local mg2=Duel.GetMatchingGroup(c62501761.fexfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
		end
	end
	local sg1=Duel.GetMatchingGroup(c62501761.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c62501761.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.ConfirmCards(1-tp,mat1)
			Duel.Remove(mat1,POS_FACEDOWN,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
function c62501761.efilter(e)
	local ct=#c62501761.effect_list
	if e:GetCode()==EVENT_REMOVE and (e:GetType()&EFFECT_TYPE_SINGLE)==EFFECT_TYPE_SINGLE and e:IsActivated() then c62501761.effect_list[ct+1]=e end
	return false
end
function c62501761.rmfilter(c)
	--[[if not (c:IsSetCard(0xea4) and not c:IsCode(62501761) and c:IsAbleToRemove(tp,POS_FACEDOWN)) then return false end
	local te=c.remove_event_effect
	if not te then return false end
	local check=e:IsCostChecked()
	e:SetCostCheck(false)
	local tg=te:GetTarget()
	local res=not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
	--[[c62501761.effect_list={}
	c:IsOriginalEffectProperty(c62501761.efilter)
	for _,te in ipairs(c62501761.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end
	e:SetCostCheck(check)]]
	return c:IsSetCard(0xea4) and not c:IsCode(62501761) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c62501761.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501761.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c62501761.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c62501761.rmfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if rg:GetCount()>0 then Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c62501761.eccon)
	e1:SetOperation(c62501761.ecop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c62501761.eccon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c62501761.ecop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetDecktopGroup(0,1)+Duel.GetDecktopGroup(1,1)
	if rg:FilterCount(Card.IsAbleToRemove,nil,rp,POS_FACEDOWN)==2 and Duel.SelectYesNo(tp,aux.Stringid(62501761,3)) then
		Duel.Hint(HINT_CARD,0,62501761)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c62501761.repop)
		e:Reset()
	end
end
function c62501761.repop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetDecktopGroup(0,1)+Duel.GetDecktopGroup(1,1)
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
end
