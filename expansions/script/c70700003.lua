--叛变的湮灭骑兵 迪萨贝尔
function c70700003.initial_effect(c)
	 --indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c70700003.spcon)
	e3:SetTarget(c70700003.sptg)
	e3:SetOperation(c70700003.spop)
	c:RegisterEffect(e3)
	 if not c70700003.global_check then
		c70700003.table={}
		c70700003.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c70700003.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c70700003.checkop(e,tp,eg,ep,ev,re,r,rp)
	c70700003.table={}
end
function c70700003.spcon(e,tp,eg,ep,ev,re,r,rp)
	for i,v in ipairs(c70700003.table) do
		if v==re:GetHandler():GetCode() then return false end
	end
   return re:IsHasCategory(CATEGORY_DESTROY)
end
function c70700003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and (re:GetHandler():IsAbleToHand() and not re:GetHandler():IsLocation(LOCATION_DECK+LOCATION_HAND)) end
	table.insert(c70700003.table,re:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,re:GetHandler(),1,0,0)
end
function c70700003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and re:GetHandler():IsAbleToHand() and not re:GetHandler():IsLocation(LOCATION_DECK+LOCATION_HAND) then
		Duel.SendtoHand(re:GetHandler(),nil,REASON_EFFECT)
	end
end