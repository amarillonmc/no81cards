--龙骑兵团骑士-圣枪龙骑士
function c34116023.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(Card.IsRace,RACE_WINDBEAST),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34116023,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCost(c34116023.cost)
	e1:SetCondition(c34116023.spcon)
	e1:SetOperation(c34116023.spop)
	e1:SetValue(c34116023.spval)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34116023,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c34116023.cost)
	e2:SetTarget(c34116023.target)
	e2:SetOperation(c34116023.operation)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(34116023,ACTIVITY_SPSUMMON,c34116023.counterfilter)
end
function c34116023.counterfilter(c)
	return c:IsRace(RACE_DRAGON) or c:GetSummonLocation()~=LOCATION_EXTRA
end
function c34116023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(34116023,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c34116023.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c34116023.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_DRAGON and c:IsLocation(LOCATION_EXTRA)
end
function c34116023.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_LINK)
end
function c34116023.cfilter2(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c34116023.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c34116023.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c34116023.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c34116023.checkzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingMatchingCard(c34116023.cfilter2,tp,LOCATION_HAND,0,1,nil) 
end
function c34116023.spval(e,c)
	local tp=c:GetControler()
	local zone=c34116023.checkzone(tp)
	return 0,zone
end
function c34116023.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c34116023.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c34116023.filter(c,e,tp)
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	return ct<=Duel.GetLocationCount(tp,LOCATION_MZONE) and c:IsRace(RACE_DRAGON) and ct>0 and Duel.GetFlagEffect(tp,c:GetOriginalCode())==0
		and mg:FilterCount(aux.NecroValleyFilter(c34116023.mgfilter),nil,e,tp,c)==ct
		and c:GetSummonLocation()==LOCATION_EXTRA and c:IsFaceup()
end
function c34116023.mgfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetReasonCard()==sync and c:IsSetCard(0x29)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c34116023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c34116023.filter(chkc)  end
	if chk==0 then return Duel.IsExistingTarget(c34116023.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c34116023.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc:GetMaterial(),2,0,0)
	Duel.RegisterFlagEffect(tp,tc:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
end
function c34116023.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	if tc:GetSummonLocation()==LOCATION_EXTRA
		and ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c34116023.mgfilter),nil,e,tp,tc)==ct then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP) 
	end
end


