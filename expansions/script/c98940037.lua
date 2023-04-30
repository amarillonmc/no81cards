--正义盟军 探路者
function c98940037.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,2)
	--ATTRIBUTE
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e3)
	   --battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)	
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)	
	e2:SetCondition(c98940037.spcon)
	e2:SetTarget(c98940037.indtg)
	e2:SetValue(c98940037.indes)
	c:RegisterEffect(e2) 
	 --immune
	local e1=e2:Clone()
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c98940037.efilter)
	c:RegisterEffect(e1)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98940037,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c98940037.cost)
	e4:SetTarget(c98940037.target)
	e4:SetOperation(c98940037.activate)
	c:RegisterEffect(e4)
end
function c98940037.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsRace(RACE_PLANT)
end
function c98940037.indtg(e,c)
	return c:IsSetCard(0x1) and c~=e:GetHandler()
end
function c98940037.indes(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98940037.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_MACHINE)
end
function c98940037.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c98940037.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98940037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98940037.filter(c,e,tp)
	return c:IsSetCard(0x1) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98940037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c98940037.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingTarget(c98940037.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98940037.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98940037.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end