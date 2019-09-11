--幽灵骑士Ghost·五右卫门魂
function c9980941.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),aux.NonTuner(Card.IsSetCard,0xcbc2),1)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.bdogcon)
	e2:SetTarget(c9980941.sptg)
	e2:SetOperation(c9980941.spop)
	c:RegisterEffect(e2)
	 --negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980941,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1)
	e3:SetTarget(c9980941.target)
	e3:SetOperation(c9980941.operation)
	c:RegisterEffect(e3)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c9980941.retreg)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980941.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980941.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980941,3))
end
function c9980941.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c9980941.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980941,4))
end
function c9980941.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(aux.SpiritReturnCondition)
	e1:SetTarget(c9980941.rettg)
	e1:SetOperation(c9980941.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c9980941.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcbc2) and c:IsAbleToHand()
end
function c9980941.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.IsExistingMatchingCard(c9980941.thfilter,tp,LOCATION_DECK,0,1,nil) end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9980941.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980941.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoExtraP(c,nil,REASON_EFFECT)~=0
		and g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980941.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c9980941.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and bc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.IsExistingMatchingCard(c9980941.ctfilter,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9980941,2),aux.Stringid(9980941,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9980941,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9980941,3))+1
	end
	if op==0 then
		Duel.SetTargetCard(bc)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
	else
		e:SetCategory(CATEGORY_CONTROL)
	end
	e:SetLabel(op)
end
function c9980941.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,c9980941.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.GetControl(tc,tp)
		end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980941,4))
end
