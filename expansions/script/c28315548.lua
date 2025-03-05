--闪耀的一等星 樱木真乃
function c28315548.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--illumination spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315548,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315548)
	e1:SetTarget(c28315548.sptg)
	e1:SetOperation(c28315548.spop)
	c:RegisterEffect(e1)
	--lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315548,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c28315548.lvtg)
	e2:SetOperation(c28315548.lvop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c28315548.atkcon)
	e3:SetValue(c28315548.atkval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c28315548.atkcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c28315548.tdfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c28315548.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x30) and chkc:IsControler(tp) and c28315548.tdfilter(chkc) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c28315548.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c28315548.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c28315548.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if Duel.GetMZoneCount(tp)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if g:IsExists(Card.IsCode,1,nil,28335405) then ct=ct+1 end
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_LEVEL)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e0:SetValue(ct)
		c:RegisterEffect(e0)
	end
end
function c28315548.lvfilter(c,lv)
	return c:IsRace(RACE_FAIRY) and c:IsFaceup() and not c:IsLevel(lv) and c:IsLevelAbove(1)
end
function c28315548.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315548.lvfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetLevel()) and e:GetHandler():IsLevelAbove(1) end
end
function c28315548.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c28315548.lvfilter,tp,LOCATION_MZONE,0,nil,c:GetLevel())
	if #g==0 then return end
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.HintSelection(Group.FromCards(tc))
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetValue(tc:GetLevel())
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e0)
	if Duel.SelectYesNo(tp,aux.Stringid(28315548,2)) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		tc:RegisterEffect(e2)
	end
end
function c28315548.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x284)
end
function c28315548.atkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c28315548.atkfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c28315548.atkval(e,c)
	return c:GetLevel()*100
end
