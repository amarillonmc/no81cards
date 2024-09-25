--切匣弹丸龙
function c21194002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21194002,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21194002)
	e1:SetCost(c21194002.cost)
	e1:SetTarget(c21194002.tg)
	e1:SetOperation(c21194002.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21194002,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,21194003)
	e2:SetTarget(c21194002.tg2)
	e2:SetOperation(c21194002.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c21194002.op3)
	c:RegisterEffect(e3)
end
function c21194002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c21194002.q(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 and not c:IsCode(21194002)
end
function c21194002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21194002.q,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21194002.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21194002.q,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21194002.r(c,tp)
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function c21194002.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c21194002.r,tp,12,12,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,12,12,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c21194002.w(c,tp)
	return c:IsSetCard(0x10f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and Duel.GetLocationCount(tp,8)>0
end
function c21194002.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local x=0
	if tc:IsSetCard(0x102) then x=1 end
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and x==1 and Duel.IsExistingMatchingCard(c21194002.w,tp,1,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(21194002,0)) then
	Duel.Hint(tp,3,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c21194002.w,tp,1,0,1,1,nil,tp)
	Duel.SSet(tp,g:GetFirst())	
	end
end
function c21194002.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21194002,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,21194004)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c21194002.tg0)
	e1:SetOperation(c21194002.op0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	end
end
function c21194002.e(c,e,tp)
	return c:IsSetCard(0x102) and not c:IsCode(21194002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21194002.tg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and Duel.IsExistingMatchingCard(c21194002.e,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21194002.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,4)<=0 then return end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21194002.e,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end