--逾越铁壁的恋慕屋敷
function c9911071.initial_effect(c)
	aux.AddCodeList(c,9911056)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911071)
	e1:SetCost(c9911071.cost)
	e1:SetTarget(c9911071.target)
	e1:SetOperation(c9911071.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911088)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911071.settg)
	e2:SetOperation(c9911071.setop)
	c:RegisterEffect(e2)
end
function c9911071.spfilter(c,e,tp)
	return c:IsSetCard(0x8e) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911071.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>=g:GetCount() and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function c9911071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local sg=Duel.GetMatchingGroup(c9911071.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local maxc=math.min(ft,sg:GetClassCount(Card.GetCode),2)
	if chk==0 then return maxc>0 and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	local ct=Duel.RemoveOverlayCard(tp,1,0,1,maxc,REASON_COST)
	e:SetLabel(ct)
end
function c9911071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_DECK)
end
function c9911071.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=e:GetLabel()
	if ft<ct or ft<=0 then return end
	local g=Duel.GetMatchingGroup(c9911071.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911071.setfilter(c)
	return c:IsCode(9911056) and not c:IsForbidden()
end
function c9911071.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911071.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c9911071.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911071.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
