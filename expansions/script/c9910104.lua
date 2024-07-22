--战车道少女·五十铃华
dofile("expansions/script/c9910100.lua")
function c9910104.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,0,true,nil,true,nil,true,nil)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910104,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910104.poscon)
	e2:SetCost(c9910104.poscost)
	e2:SetTarget(c9910104.postg)
	e2:SetOperation(c9910104.posop)
	c:RegisterEffect(e2)
end
function c9910104.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end
function c9910104.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910104.posfilter(c)
	return c:IsCanTurnSet() or not c:IsPosition(POS_FACEUP_ATTACK)
end
function c9910104.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910104.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910104.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c9910104.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9910104.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	elseif tc:IsPosition(POS_FACEDOWN_DEFENSE) then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	elseif tc:IsCanTurnSet() then
		local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		Duel.ChangePosition(tc,pos)
	else
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	end
end
