--半魔的坚盾
function c17337426.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337426,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,17337426)
	e1:SetCondition(c17337426.spcon1)
	e1:SetTarget(c17337426.sptg)
	e1:SetOperation(c17337426.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(17337426,1))
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c17337426.spcon2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17337426,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,17337426+1)
	e3:SetTarget(c17337426.tdtg)
	e3:SetOperation(c17337426.tdop)
	c:RegisterEffect(e3)
end

function c17337426.tfilter(c,tp)
	return c:IsSetCard(0x3f50) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
end

function c17337426.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and c17337426.tfilter(tc,tp)
end

function c17337426.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	return c17337426.tfilter(g:GetFirst(),tp)
end

function c17337426.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c17337426.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 or c:IsDefensePos() then return end
	if e:GetCode()==EVENT_BE_BATTLE_TARGET then
		local g=Duel.GetAttacker():GetAttackableTarget()
		if g:IsContains(c) and Duel.SelectYesNo(tp,aux.Stringid(17337426,2)) and not Duel.GetAttacker():IsImmuneToEffect(e) then
			Duel.BreakEffect()
			Duel.ChangeAttackTarget(c)
		end
	else
		if Duel.CheckChainTarget(ev,c) and Duel.SelectYesNo(tp,aux.Stringid(17337426,2)) then
			Duel.BreakEffect()
			Duel.ChangeTargetCard(ev,Group.FromCards(c))
		end
	end
end

function c17337426.tdfilter(c,tp)
	return c:IsSetCard(0x3f50) and c:IsFaceupEx() and c:IsAbleToDeck()
end

function c17337426.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp) and c17337426.tdfilter(chkc,tp) and chkc~=c end
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(c17337426.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c17337426.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,c,tp)	
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c17337426.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if not tc or not tc:IsRelateToEffect(e) then return end	
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			if Duel.IsExistingMatchingCard(c17337426.cfilter,tp,LOCATION_MZONE,0,1,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(c:GetAttack()*2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e2:SetValue(c:GetDefense()*2)
				c:RegisterEffect(e2)
			end
		end
		Duel.SpecialSummonComplete()
	end
end