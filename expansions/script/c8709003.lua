--端午节的兔丸
function c8709003.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8709003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,8709003)
	e1:SetCost(c8709003.thcost)
	e1:SetTarget(c8709003.target)
	e1:SetOperation(c8709003.activate)
	c:RegisterEffect(e1)
	--reflect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetTarget(c8709003.reftg)
	e2:SetValue(1)
	c:RegisterEffect(e2)



end
function c8709003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c8709003.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xafa) and c:GetSequence()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8709003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c8709003.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c8709003.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c8709003.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c8709003.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c8709003.reftg(e,c)
	return c:IsSetCard(0xafa)
end












