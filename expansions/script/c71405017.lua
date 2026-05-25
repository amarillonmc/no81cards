--七色折射的万花筒-棱镜世界
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.prism) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71405000,0)
		yume.import_flag=false
	end
	yume.prism.addCounter()
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--banish from Deck, then increase Level/Rank
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--special summon 2+ Synchro/Xyz monsters from Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100000)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.filterc1(c)
	return c:IsSetCard(0x716) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(0)
		and c:IsAbleToRemoveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return yume.prism.checkCounter(tp)
		and Duel.IsExistingMatchingCard(s.filterc1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filterc1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.prism.regCostLimit(e,tp)
end
function s.filter1(c)
	return c:IsFaceup() and (c:IsLevelAbove(0) or c:IsRankAbove(0))
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc) end
	if chk==0 then return e:IsCostChecked()
		and Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToChain() and tc:IsFaceup()) then return end
	local lv=tc:GetLevel()
	if tc:IsLevelAbove(0) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	if tc:IsRankAbove(0) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_RANK)
		e2:SetValue(lv)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function s.val(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank() end
	return c:GetLevel()
end
function s.checksp(lv,e,tp,rc)
	local ft=math.min(Duel.GetLocationCountFromEx(tp,tp,rc,TYPE_SYNCHRO),Duel.GetLocationCountFromEx(tp,tp,rc,TYPE_XYZ))
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft<2 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp)
	return g:CheckSubGroup(s.sgcheck,2,math.min(ft,g:GetCount()),tp,lv)
end
function s.filterc2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x716) and c:IsRace(RACE_CYBERSE)
		and c:IsType(TYPE_MONSTER) and (c:IsLevelAbove(0) or c:IsRankAbove(0))
		and c:IsAbleToRemoveAsCost() and s.checksp(s.val(c),e,tp,c)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return yume.prism.checkCounter(tp)
		and Duel.IsExistingMatchingCard(s.filterc2,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filterc2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabel(s.val(tc))
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	yume.prism.regCostLimit(e,tp)
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0x716) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ))
		and s.val(c)>0
		and ((c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false))
			or (c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)))
end
function s.sgcheck(g,tp,lv)
	local sum=0
	local has_syn=false
	local has_xyz=false
	for tc in aux.Next(g) do
		sum=sum+s.val(tc)
		if tc:IsType(TYPE_SYNCHRO) then has_syn=true end
		if tc:IsType(TYPE_XYZ) then has_xyz=true end
	end
	return sum<=lv and (not has_syn or aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL))
		and (not has_xyz or aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL))
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lv=e:GetLabel()
		local ft=math.min(Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_SYNCHRO),Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ))
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if not e:IsCostChecked() or ft<2 then return false end
		local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp)
		return g:CheckSubGroup(s.sgcheck,2,math.min(ft,g:GetCount()),tp,lv)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local ft=math.min(Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_SYNCHRO),Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ))
	if ft<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp)
	local max=math.min(ft,g:GetCount())
	if max<2 or not g:CheckSubGroup(s.sgcheck,2,max,tp,lv) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,s.sgcheck,false,2,max,tp,lv)
	if not sg or sg:GetCount()<2 then return end
	local syng=sg:Filter(Card.IsType,nil,TYPE_SYNCHRO)
	local xyzg=sg:Filter(Card.IsType,nil,TYPE_XYZ)
	if syng:GetCount()>0 then
		for tc in aux.Next(syng) do
			tc:SetMaterial(nil)
			if Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
				tc:CompleteProcedure()
			end
		end
		Duel.SpecialSummonComplete()
	end
	if xyzg:GetCount()>0 then
		if syng:GetCount()>0 then Duel.BreakEffect() end
		for tc in aux.Next(xyzg) do
			tc:SetMaterial(nil)
			if Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
				tc:CompleteProcedure()
			end
		end
	end
	Duel.SpecialSummonComplete()
end
