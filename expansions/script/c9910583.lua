--混合咖啡的节庆特典
function c9910583.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910583+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910583.target)
	e1:SetOperation(c9910583.activate)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910583,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c9910583.condition1)
	e2:SetTarget(c9910583.postg)
	e2:SetOperation(c9910583.posop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9910583.condition2)
	c:RegisterEffect(e3)
	--spsummon
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(9910583,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetTarget(c9910583.sptg)
	e4:SetOperation(c9910583.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(c9910583.condition2)
	c:RegisterEffect(e5)
end
function c9910583.thfilter(c)
	return c:IsSetCard(0xc951) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910583.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910583.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910583.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910583.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9910583.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910583.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and not rc:IsSummonableCard()
end
function c9910583.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,3,nil)
end
function c9910583.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,3,nil)
end
function c9910583.posfilter(c)
	return c:IsFacedown() and c:IsSetCard(0xc951)
end
function c9910583.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910583.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c9910583.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc951)
end
function c9910583.posop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c9910583.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	if Duel.ChangePosition(g:GetFirst(),POS_FACEUP_ATTACK)==0 then return end
	local tg=Duel.GetMatchingGroup(c9910583.atkfilter,tp,LOCATION_MZONE,0,nil)
	if tg:GetCount()>0 then
		local sc=tg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1200)
			sc:RegisterEffect(e1)
			sc=tg:GetNext()
		end
	end
end
function c9910583.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c9910583.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910583.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910583.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9910583.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local spos=0
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then spos=spos+POS_FACEUP_DEFENSE end
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
	if spos~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,spos)
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
