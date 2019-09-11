--巴卡兹监狱的改造试炼
function c9950036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950036)
	e1:SetTarget(c9950036.target)
	e1:SetOperation(c9950036.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9950036.sptg)
	e1:SetOperation(c9950036.spop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950036,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,9950036)
	e2:SetCost(c9950036.thcost)
	e2:SetTarget(c9950036.thtg)
	e2:SetOperation(c9950036.thop)
	c:RegisterEffect(e2)
end
function c9950036.desfilter(c)
	return c:IsFaceup() and (c:IsLevelBelow(8) or c:IsRankBelow(8) or c:IsLinkBelow(2))
end
function c9950036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950036.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c9950036.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9950036.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9950036.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9950036.cfilter(c,e,tp)
	return c:IsCode(9950037,9950038)
end
function c9950036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c9950036.cfilter,e,tp,mg1,nil,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9950036.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c9950036.cfilter,e,tp,mg1,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(9950036,RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_STANDBY,2,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY,2)
		e1:SetProperty(EFFECT_IMMUNE_EFFECT)
		e1:SetCondition(c9950036.econ)
		e1:SetValue(c9950036.efilter)
		e1:SetReset(EVENT_PHASE+PHASE_STANDBY,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9950036.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9950036.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9950036.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9950036.filter(c)
	return c:IsCode(9950039) and c:IsAbleToHand()
end
function c9950036.filter2(c)
	return c:IsCode(9950037,9950038) and c:IsAbleToHand()
end
function c9950036.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950036.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9950036.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950036.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9950036.filter2),tp,LOCATION_GRAVE,0,nil)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9950036,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
