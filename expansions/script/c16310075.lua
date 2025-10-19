--Legend-Arms 剑盾共战
function c16310075.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--equip
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,16310075,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS})
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16310075,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(custom_code)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16310075)
	e1:SetTarget(c16310075.eqtg)
	e1:SetOperation(c16310075.eqop)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16310075,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,16310075+1)
	e2:SetTarget(c16310075.target)
	e2:SetOperation(c16310075.activate)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16310075,2))
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,16310075+2)
	e3:SetTarget(c16310075.target2)
	e3:SetOperation(c16310075.activate2)
	c:RegisterEffect(e3)
end
function c16310075.tgfilter(c,e,tp,chk)
	return c:IsSetCard(0x3dc6) and c:IsType(TYPE_UNION)
		and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
		and (chk or Duel.IsExistingMatchingCard(c16310075.cfilter,tp,LOCATION_DECK,0,1,nil,c,tp))
end
function c16310075.cfilter(c,ec,tp)
	return c:IsSetCard(0x3dc6) and c:IsType(TYPE_UNION) and not c:IsCode(ec:GetCode())
		and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function c16310075.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c16310075.tgfilter(chkc,e,tp,true) end
	local g=eg:Filter(c16310075.tgfilter,nil,e,tp,false)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end
end
function c16310075.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,c16310075.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		local ec=sg:GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ec:RegisterEffect(e1)
		end
	end
end
function c16310075.filter0(c)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c16310075.filter1(c,e)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
		and not c:IsImmuneToEffect(e)
end
function c16310075.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3dc6) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c16310075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c16310075.filter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(c16310075.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c16310075.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c16310075.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c16310075.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c16310075.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c16310075.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			Duel.HintSelection(mat)
			Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c16310075.filter(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x3dc6) and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(c16310075.mgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp,c)
end
function c16310075.mgfilter(c,e,tp,fc)
	return c:IsFaceupEx() and c:IsSetCard(0x3dc6) and c:IsAbleToHand() and c:IsType(0x1)
		and (c:GetAttack()==fc:GetAttack() or c:GetDefense()==fc:GetDefense())
end
function c16310075.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c16310075.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16310075.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c16310075.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c16310075.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c16310075.mgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,tc,e,tp,tc)
	if Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and #g>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,2,nil)
		Duel.SendtoHand(sg,nil,0x40)
	end
end