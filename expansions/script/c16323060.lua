--王·破坏死光
function c16323060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16323060)
	e1:SetCondition(aux.bpcon)
	e1:SetOperation(c16323060.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16323060)
	e2:SetCondition(c16323060.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16323060.destg)
	e2:SetOperation(c16323060.desop)
	c:RegisterEffect(e2)
end
function c16323060.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsSetCard,Card.IsFaceup),tp,LOCATION_MZONE,0,1,nil,0x3dcf)
end
function c16323060.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16323060.spfilter(c,e,tp)
	return c:IsRace(0x20) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
		and Duel.GetMZoneCount(tp)>0
end
function c16323060.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)<1 then
			if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c16323060.spfilter),tp,0x30,0,1,nil,e,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(16323060,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16323060.spfilter),tp,0x30,0,1,1,nil,e,tp)
				Duel.HintSelection(sg)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c16323060.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(DOUBLE_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end