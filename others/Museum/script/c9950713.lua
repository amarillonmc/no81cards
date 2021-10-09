--N 蠢动的黑暗
function c9950713.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950713+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9950713.cost)
	e1:SetTarget(c9950713.target)
	e1:SetOperation(c9950713.activate)
	c:RegisterEffect(e1)
 --atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950713,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,5177986)
	e2:SetTarget(c9950713.atktg)
	e2:SetOperation(c9950713.atkop)
	c:RegisterEffect(e2)
end
function c9950713.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9bd1)
end
function c9950713.fgoal(sg,e,tp)
	return sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)==1
		and Duel.IsExistingMatchingCard(c9950713.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,sg,e,tp)
end
function c9950713.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(7) and c:IsSetCard(0x9bd1) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950713.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(c9950713.spcostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,exc)
	if chk==0 then return rg:CheckSubGroup(c9950713.fgoal,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectSubGroup(tp,c9950713.fgoal,false,2,2,e,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c9950713.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950713.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c9950713.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950713.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c9950713.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1)
end
function c9950713.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9950713.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950713.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9950713.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9950713.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end