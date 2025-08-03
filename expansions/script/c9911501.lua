--觅迹人 赫莉蒂琪
function c9911501.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9911501.sprcon)
	e1:SetOperation(c9911501.sprop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911501,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9911501)
	e2:SetCondition(c9911501.spcon)
	e2:SetTarget(c9911501.sptg)
	e2:SetOperation(c9911501.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911502)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9911503)
	c:RegisterEffect(e4)
	--flag
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(c9911501.checkcon1)
	e5:SetOperation(c9911501.checkop1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(aux.TRUE)
	e6:SetOperation(c9911501.checkop2)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c9911501.checkcon3)
	e7:SetOperation(c9911501.checkop3)
	c:RegisterEffect(e7)
	--recycle
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9911501,4))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetCountLimit(1)
	e8:SetTarget(c9911501.thtg)
	e8:SetOperation(c9911501.thop)
	c:RegisterEffect(e8)
end
function c9911501.costfilter(c)
	return c:IsSetCard(0x5952) and c:IsAbleToGraveAsCost()
end
function c9911501.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount()
end
function c9911501.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9911501.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:CheckSubGroup(c9911501.fselect,2,2)
end
function c9911501.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9911501.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c9911501.fselect,false,2,2)
	Duel.SendtoGrave(sg,REASON_SPSUMMON)
end
function c9911501.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9911501)>0
end
function c9911501.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSpecialSummonable(0)
end
function c9911501.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911501.spfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9911501.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911501.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	Duel.SpecialSummonRule(tp,tc,0)
end
function c9911501.checkcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c9911501.checkop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(9911501,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911501,0))
end
function c9911501.checkop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(9911501,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911501,1))
end
function c9911501.checkcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE)
end
function c9911501.checkop3(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(9911501,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911501,2))
end
function c9911501.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x5952) and c:IsAbleToHand() and not c:IsCode(9911501)
end
function c9911501.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911501.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9911501.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911501.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
