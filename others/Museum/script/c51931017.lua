--魔棋的黑骑士
function c51931017.initial_effect(c)
	--activate cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(0xff)
	e0:SetTargetRange(1,1)
	e0:SetTarget(c51931017.actarget)
	e0:SetCost(c51931017.costchk)
	e0:SetOperation(c51931017.costop)
	c:RegisterEffect(e0)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51931017)
	e1:SetCost(c51931017.spcost)
	e1:SetTarget(c51931017.sptg)
	e1:SetOperation(c51931017.spop)
	c:RegisterEffect(e1)
	--spsummon-other
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,51931017)
	e2:SetTarget(c51931017.sptg2)
	e2:SetOperation(c51931017.spop2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(51931017,ACTIVITY_SPSUMMON,c51931017.counterfilter)
end
function c51931017.counterfilter(c)
	return not (c:IsLevelAbove(1) and c:IsSummonLocation(LOCATION_EXTRA))
end
function c51931017.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c51931017.costchk(e,te_or_c,tp)
	return Duel.GetCustomActivityCount(51931017,tp,ACTIVITY_SPSUMMON)==0
end
function c51931017.costop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51931017.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51931017.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(1) and c:IsLocation(LOCATION_EXTRA)
end
function c51931017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c51931017.costfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsSetCard(0x6258) and c:IsFaceup() and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c51931017.tgfilter,tp,LOCATION_DECK,0,1,nil,type1)
end
function c51931017.tgfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x6258) and c:IsAbleToGrave()
end
function c51931017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c51931017.costfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c51931017.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetType()&0x7)
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c51931017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local type1=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=Duel.SelectMatchingCard(tp,c51931017.tgfilter,tp,LOCATION_DECK,0,1,1,nil,type1):GetFirst()
	if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c51931017.spfilter(c,e,tp)
	return c:IsSetCard(0x6258) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c51931017.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c51931017.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c51931017.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c51931017.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
