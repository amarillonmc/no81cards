--联协指令 武装出动
function c62501551.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62501551)
	e1:SetTarget(c62501551.target)
	e1:SetOperation(c62501551.activate)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,62501551+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c62501551.ovtg)
	e2:SetOperation(c62501551.ovop)
	c:RegisterEffect(e2)
end
function c62501551.spfilter(c,e,tp)
	return c:IsSetCard(0xea3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62501551.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c62501551.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
	end
end
function c62501551.eqfilter(c,tp,sc)
	return c:IsSetCard(0xea3) and c:IsType(TYPE_EQUIP) and aux.NecroValleyFilter()(c) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(sc)
end
function c62501551.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c62501551.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c62501551.spfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c62501551.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,sc) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(62501551,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c62501551.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,sc):GetFirst()
		Duel.Equip(tp,ec,sc)
	end
end
function c62501551.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c62501551.xfilter(c)
	return c:IsSetCard(0xea3) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c62501551.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0x30,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c62501551.xfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c62501551.ovop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c62501551.xfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsCanOverlay),tp,0x30,0,1,1,nil)
	if not g or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local xc=Duel.SelectMatchingCard(tp,c62501551.xfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(xc))
	Duel.Overlay(xc,g)
end
