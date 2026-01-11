--追击之复转
function c67201628.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,67201628+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67201628.cost)
	e1:SetTarget(c67201628.target)
	e1:SetOperation(c67201628.activate)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetCondition(c67201628.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
end
function c67201628.condition(e)
	return e:GetHandler():IsSetCard(0x367f)
end
--
function c67201628.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local spct=0
	if Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(67201628,1)) then
		spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,1,REASON_COST)
	end
	e:SetLabel(spct)
end
function c67201628.filter(c)
	return c:IsCanOverlay() and c:IsFaceup()
end
function c67201628.xyzfilter2(c,mg)
	return c:IsType(TYPE_XYZ) and mg:CheckSubGroup(c67201628.gselect,1,#mg,c)
end
function c67201628.gselect(sg,c)
	return sg:IsExists(Card.IsSetCard,1,nil,0x367f) and c:IsXyzSummonable(sg,#sg,#sg)
end
function c67201628.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(c67201628.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201628.xyzfilter2,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c67201628.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c67201628.filter,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c67201628.xyzfilter2,tp,LOCATION_EXTRA,0,nil,mg)
	if exg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=exg:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=mg:SelectSubGroup(tp,c67201628.gselect,false,1,mg:GetCount(),tg:GetFirst())
		Duel.XyzSummon(tp,tg:GetFirst(),sg,#sg,#sg)
		--
		local spct=e:GetLabel()
		if spct>0 and c:IsRelateToEffect(e) and c:IsCanOverlay() 
			and Duel.SelectYesNo(tp,aux.Stringid(67201628,2)) then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end