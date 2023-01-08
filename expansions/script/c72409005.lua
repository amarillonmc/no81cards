--神造遗物使 都
function c72409005.initial_effect(c)
	aux.AddCodeList(c,72409055)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,72409005)
	e1:SetTarget(c72409005.thtg)
	e1:SetOperation(c72409005.thop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72409005.atkcon)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)   
end
function c72409005.thfilter(c,e,tp)
	return c:IsSetCard(0xe729)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(72409005)
end
function c72409005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72409005.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72409005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72409005.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c72409005.atkfilter(c,e)
	return c:IsFaceup() and c:IsCode(72409055) and Card.GetEquipTarget(c)==e:GetHandler()
end
function c72409005.atkcon(e)
	local hc=e:GetHandler()
	return Duel.IsExistingMatchingCard(c72409005.atkfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e)
end
