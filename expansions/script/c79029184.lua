--罗德岛·行动-医疗研究
function c79029184.initial_effect(c)
   --recycle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62560742,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029184)
	e1:SetTarget(c79029184.target)
	e1:SetOperation(c79029184.operation)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(95286165,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029184)
	e1:SetTarget(c79029184.target1)
	e1:SetOperation(c79029184.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79029184)
	e2:SetTarget(c79029184.sptg)
	e2:SetOperation(c79029184.spop)
	c:RegisterEffect(e2)
end
function c79029184.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_SYNCHRO)
end
function c79029184.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029184.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029184.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c79029184.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c79029184.mgfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c79029184.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	local sumtype=tc:GetSummonType()
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and sumtype==SUMMON_TYPE_SYNCHRO
		and ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c79029184.mgfilter),nil,e,tp,tc)==ct
		and Duel.SelectYesNo(tp,aux.Stringid(62560742,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c79029184.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0xa900)
end
function c79029184.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029184.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029184.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c79029184.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c79029184.mgfilter1(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and fusc:CheckFusionMaterial(mg,c)
end
function c79029184.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	local sumtype=tc:GetSummonType()
	if Duel.SendtoGrave(tc,nil,0,REASON_EFFECT)~=0 and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
		and ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c79029184.mgfilter1),nil,e,tp,tc,mg)==ct
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.SelectYesNo(tp,aux.Stringid(95286165,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c79029184.fil(c)
	return c:IsSetCard(0xa902) and c:IsFaceup()
end
function c79029184.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029184.fil,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
	local g=Duel.GetMatchingGroup(c79029184.fil,tp,LOCATION_EXTRA,0,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c79029184.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_RULE)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029184.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c79029184.splimit(e,c)
	return not c:IsSetCard(0xa900) and c:IsLocation(LOCATION_EXTRA)
end








