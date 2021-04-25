--与陷阵营的交锋
function c9330017.initial_effect(c)
	aux.AddCodeList(c,9330001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9330017+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9330017.target)
	e1:SetOperation(c9330017.activate)
	c:RegisterEffect(e1)
	--untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c9330017.condition)
	e2:SetTarget(c9330017.etarget)
	e2:SetValue(c9330017.imfilter)
	c:RegisterEffect(e2)
	--attack limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c9330017.condition)
	e3:SetTarget(c9330017.attg)
	e3:SetValue(c9330017.atlimit)
	c:RegisterEffect(e3)
	--set/to hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(aux.exccon)
	e4:SetCountLimit(1,9330117+EFFECT_COUNT_CODE_DUEL)
	e4:SetCost(c9330017.thcost)
	e4:SetTarget(c9330017.settg)
	e4:SetOperation(c9330017.setop)
	c:RegisterEffect(e4)
end
function c9330017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,9330017,0xf9c,0x21,2200,600,6,RACE_WARRIOR,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9330017.filter(c)
	return c:IsFaceup() and c:IsCode(9330001)
end
function c9330017.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c9330017.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c9330017.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9330017.filter3(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c9330017.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0xf9c)
end
function c9330017.activate(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,9330017,0xf9c,0x21,2200,600,6,RACE_WARRIOR,ATTRIBUTE_WATER) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_ATTACK)~=0
		and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		and Duel.IsExistingMatchingCard(c9330017.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9330017,0)) then
		Duel.BreakEffect()
			local chkf=tp
			local mg1=Duel.GetFusionMaterial(tp):Filter(c9330017.filter3,nil,e)
			aux.FCheckAdditional=c9330017.fcheck
			local mg2=Duel.GetMatchingGroup(c9330017.filter1,tp,0,LOCATION_MZONE,nil,e)
			mg1:Merge(mg2)
			local sg1=Duel.GetMatchingGroup(c9330017.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
			local mg3=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(c9330017.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
				aux.FCheckAdditional=nil
		end
	end
end
function c9330017.condition(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c9330017.etarget(e,c)
	return c:IsFaceup() and c:IsSetCard(0xf9c) and c:IsType(TYPE_MONSTER)
end
function c9330017.imfilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
			and not e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end
function c9330017.attg(e,c)
	local cg=c:GetColumnGroup()
	e:SetLabelObject(c)
	return true
end
function c9330017.atlimit(e,c)
	local lc=e:GetLabelObject()
	return c:IsFaceup() and c:IsSetCard(0xf9c) and not lc:GetColumnGroup():IsContains(c)
end
function c9330017.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9330017.setfilter(c)
	if not (c:IsSetCard(0xf9c) and c:IsType(TYPE_TRAP+TYPE_SPELL) and not c:IsCode(9330017)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c9330017.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9330017.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9330017.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9330017.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end













