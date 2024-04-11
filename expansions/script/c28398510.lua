--小偶像的恶作剧
function c28398510.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON)
	e1:SetCountLimit(1,28398510+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28398510.target)
	e1:SetOperation(c28398510.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,28398510)
	e2:SetTarget(c28398510.rmtg)
	e2:SetOperation(c28398510.rmop)
	c:RegisterEffect(e2)
end
function c28398510.sfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c28398510.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28398510.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c28398510.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c28398510.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c28398510.sfilter,tp,0,LOCATION_MZONE,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c28398510.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c28398510.sfilter,tp,0,LOCATION_MZONE,1,ct,nil)
end
function c28398510.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			if tc:IsPosition(POS_FACEDOWN_DEFENSE) and tc:IsControler(1-tp) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(0,1)
				e1:SetTarget(c28398510.sumlimit)
				e1:SetLabel(tc:GetOriginalCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				Duel.RegisterEffect(e2,tp)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CANNOT_ACTIVATE)
				e3:SetValue(c28398510.aclimit)
				Duel.RegisterEffect(e3,tp)
			end
		end
	end
end
function c28398510.sumlimit(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function c28398510.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function c28398510.rmfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c28398510.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28398510.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c28398510.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c28398510.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c28398510.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c28398510.splimit(e,c)
	return not c:IsSetCard(0x283)
end
