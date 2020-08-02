--白面鸮
function c9910615.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910615,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910615)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910615.settg)
	e1:SetOperation(c9910615.setop)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910615,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910616)
	e2:SetTarget(c9910615.postg)
	e2:SetOperation(c9910615.posop)
	c:RegisterEffect(e2)
end
function c9910615.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9910615.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910615.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910615.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c9910615.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9910615.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c9910615.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
		local p=tc:GetControler()
		local g=Duel.GetMatchingGroup(c9910615.spfilter,p,LOCATION_HAND,0,nil,e,p)
		if g:GetCount()>0 and Duel.GetLocationCount(p,LOCATION_MZONE)>0
			and Duel.SelectYesNo(p,aux.Stringid(9910615,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local sg=g:Select(p,1,1,nil)
			Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-p,sg)
		end
	end
end
function c9910615.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
end
function c9910615.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	Duel.ShuffleSetCard(g)
	Duel.BreakEffect()
	local sg=g:Select(1-tp,1,1,nil)
	Duel.HintSelection(sg)
	Duel.ChangePosition(sg,POS_FACEUP_ATTACK)
end
