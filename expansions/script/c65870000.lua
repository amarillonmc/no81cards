--Protoss·探机
function c65870000.initial_effect(c)
	--special summon (self)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,65870000)
	e1:SetCondition(c65870000.damcon)
	e1:SetCost(c65870000.cost)
	e1:SetTarget(c65870000.sptg)
	e1:SetOperation(c65870000.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,65870000+1)
	e2:SetTarget(c65870000.sttg)
	e2:SetOperation(c65870000.stop)
	c:RegisterEffect(e2)
end

function c65870000.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c65870000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
end
function c65870000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65870000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c65870000.stfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3a37) and c:IsSSetable()
end
function c65870000.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870000.stfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c65870000.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65870000.stfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(65870000,0))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		end
	end
end