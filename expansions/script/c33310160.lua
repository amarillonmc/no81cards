--临魔化羽
function c33310160.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.TRUE,6,2)
	--linmo
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c33310160.ltg)
	e1:SetOperation(c33310160.lop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,33310160)
	e2:SetCost(c33310160.efcost)
	e2:SetTarget(c33310160.eftg)
	e2:SetOperation(c33310160.efop)
	c:RegisterEffect(e2)
	c33310160[c]=e1
end

function c33310160.ltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
end
function c33310160.lop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
	if g then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c33310160.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c33310160.mfilter(c,e,tp)
	return c:IsSetCard(0x55b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33310160.sfilter(c)
	return c:GetOverlayCount()<=0
end
function c33310160.filter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsSetCard(0x55b) and ((c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c33310160.mfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(c33310160.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)))
end
function c33310160.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return og:IsExists(c33310160.filter,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	local tc=og:FilterSelect(tp,c33310160.filter,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	local op=99
	if tc:IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
		op=0
	elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		local g=Duel.GetMatchingGroup(c33310160.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
		op=1
	end
	e:SetLabel(op)
end
function c33310160.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 and Duel.GetMZoneCount(tp)>0 then
		local g=Duel.SelectMatchingCard(tp,c33310160.mfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==1 then
		local g=Duel.GetMatchingGroup(c33310160.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end