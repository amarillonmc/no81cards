--我內心的吶喊
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89431001)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND|CATEGORY_FUSION_SUMMON+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter1(c)
	return c:IsCode(89431001) and c:IsAbleToHand()
end
function s.filter21(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
		and (c:IsControler(c:GetOwner()) or c:IsAbleToChangeControler()) and not c:IsImmuneToEffect(e)
		and not c:IsForbidden() and c:CheckUniqueOnField(c:GetOwner())
end
function s.filter22(c,tp)
	return c:GetControler()==tp
end
function s.check(g,tp)
	return g:FilterCount(s.filter22,nil,0)<=Duel.GetLocationCount(0,LOCATION_SZONE)
		and g:FilterCount(s.filter22,nil,1)<=Duel.GetLocationCount(1,LOCATION_SZONE)
		and g:FilterCount(Card.IsType,nil,TYPE_FUSION)>0
end
function s.filter31(c)
	return c:IsSetCard(0xa709) and c:IsType(TYPE_MONSTER)
		and c:IsFaceupEx() and c:IsAbleToDeck() and c:IsCanBeFusionMaterial()
end
function s.filter32(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.filter21,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil,e)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(s.filter31,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local res=Duel.IsExistingMatchingCard(s.filter32,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(s.filter32,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
		end
	end
	local b1=(Duel.GetFlagEffect(tp,id)==0 or not e:IsCostChecked())
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=(Duel.GetFlagEffect(tp,id+o)==0 or not e:IsCostChecked()) and g:CheckSubGroup(s.check,2,2,tp)
	local b3=(Duel.GetFlagEffect(tp,id+o*2)==0 or not e:IsCostChecked()) and res
	if chk==0 then return (b1 or b2 or b3) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(aux.NOT(Card.IsRace),RACE_AQUA))
	Duel.RegisterEffect(e1,tp)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2},
		{b3,aux.Stringid(id,3),3})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(0)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:SelectSubGroup(tp,s.check,false,2,2,tp)
		Duel.SetTargetCard(sg)
	elseif op==3 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
		local g0=Group.CreateGroup()
		for p in aux.TurnPlayers() do
			local sg=g:Filter(s.filter22,nil,p)
			local ct=Duel.GetLocationCount(p,LOCATION_SZONE)
			if #sg<=ct then
				g0:Merge(sg)
			elseif ct>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sg0=sg:Select(tp,ct,ct,nil)
				g0:Merge(sg0)
			end
		end
		for tc in aux.Next(g0) do
			Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
		g:Sub(g0)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_RULE)
		end
	elseif op==3 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(s.filter31,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
		local sg1=Duel.GetMatchingGroup(s.filter32,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(s.filter32,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if #sg1>0 or (sg2~=nil and #sg2>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.HintSelection(mat1)
				Duel.SendtoDeck(mat1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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