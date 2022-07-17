--时间潜行者·指针调拨员
function c33202000.initial_effect(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33202000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33202000)
	e1:SetCondition(c33202000.spcon)
	e1:SetTarget(c33202000.sptg)
	e1:SetOperation(c33202000.spop)
	c:RegisterEffect(e1)
	--XYZ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33202000,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33212000)
	e2:SetCondition(c33202000.matcon)
	e2:SetTarget(c33202000.mattg)
	e2:SetOperation(c33202000.matop)
	c:RegisterEffect(e2)
end

--e1
function c33202000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x126) and re:IsActiveType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ep==tp and not re:GetHandler():IsCode(33202000) 
end
function c33202000.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0x126)
end
function c33202000.xyzfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x126)
end
function c33202000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33202000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
		local g=Duel.GetMatchingGroup(c33202000.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33202000,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end
end

--e2
function c33202000.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c33202000.matfilter(c)
	return c:IsSetCard(0x126) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c33202000.matfilter2(c)
	return c:IsCanOverlay() and c:IsFaceup()
end
function c33202000.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c33202000.matfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c33202000.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c33202000.matfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c33202000.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33202000.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c33202000.matfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
		local sc=g:GetFirst()
		local og=sc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(sc))
	end
end