--更近我主（未完成）
function c21040006.initial_effect(c)
	aux.AddCodeList(c,82204252)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21040006.target)
	e1:SetOperation(c21040006.activate)
	c:RegisterEffect(e1)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(c21040006.condition)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsCode,82204252))
	e5:SetValue(c21040006.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(aux.indoval)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_EXTRA_ATTACK)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function c21040006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c21040006.filter(c,e,sp)
	return c:IsCode(82204252) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c21040006.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(c21040006.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(82204252,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c21040006.cfilter(c)
	return c:IsFaceup() and c:IsCode(82204252)
end
function c21040006.condition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c21040006.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c21040006.skipcon(e)
	return c21040006.condition(e) and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c21040006.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end



