--极光战姬 丽莎特皮克
function c40009613.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xbf1b),3,2)
	c:EnableReviveLimit()   
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009613,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009613)
	e1:SetCondition(c40009613.xccon1)
	e1:SetTarget(c40009613.xctg)
	e1:SetOperation(c40009613.xcop)
	c:RegisterEffect(e1) 
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c40009613.xccon2)
	c:RegisterEffect(e3)
	if not c40009613.global_check then
		c40009613.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(40009613)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009613,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,40009614)
	e4:SetCondition(c40009613.spcon1)
	e4:SetCost(c40009613.spcost)
	e4:SetTarget(c40009613.sptg)
	e4:SetOperation(c40009613.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(c40009613.spcon2)
	c:RegisterEffect(e5) 
end
function c40009613.xccon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(40009613)>0 and not Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009613.xccon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(40009613)>0 and Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009613.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009613.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009613.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function c40009613.xctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsExistingMatchingCard(c40009613.xctgfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c40009613.xcop(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(c40009613.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g0:GetCount()>0 and g1:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,c40009613.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		local sg=g1:RandomSelect(1-tp,1)
		local tc=g2:GetFirst()
		Duel.Overlay(tc,sg)
	end
end
function c40009613.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009613.spfilter(c,e,tp)
	return c:IsSetCard(0xbf1b) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009613.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40009613.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009613.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40009613.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40009613.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end
