local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.eqcon)
	e1:SetCost(s.eqcost)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.eqcon2)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(s.spccon)
	e4:SetTarget(s.spctg)
	e4:SetOperation(s.spcop)
	c:RegisterEffect(e4)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function s.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp)
end
function s.eqfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER==0
end
function s.eqcon2(e)
	return e:GetHandler():GetEquipGroup():IsExists(s.eqfilter,1,nil)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and g:FilterCount(s.cfilter,nil)==g:GetCount()
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER) and c:IsSetCard(0x30) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then Duel.SendtoGrave(c,REASON_EFFECT) end
end
function s.rfilter(c,tp,sc)
	return c:IsFaceup() and c:IsSetCard(0x30) and c:IsType(TYPE_TUNER) and c:IsLevelBelow(4) and c:IsAbleToGraveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.spccon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(s.rfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetControler(),c)
end
function s.spctg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_MZONE,0,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.spcop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
