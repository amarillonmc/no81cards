--小灰人
function c98921052.initial_effect(c)
	--code
	aux.EnableChangeCode(c,64382839,LOCATION_MZONE+LOCATION_GRAVE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921052,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,98921052)
	e1:SetCost(c98921052.spcost)
	e1:SetTarget(c98921052.sptg)
	e1:SetOperation(c98921052.spop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921052,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c98921052.spcon1)
	e2:SetTarget(c98921052.sptg1)
	e2:SetOperation(c98921052.spop1)
	c:RegisterEffect(e2)
end
function c98921052.costfilter(c)
	return c:IsCode(64382839) or (aux.IsCodeListed(c,64382839) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToGraveAsCost()
end
function c98921052.kfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c98921052.fselect(g,tp)
	local sg=g:Clone()
	local res=true
	for c in aux.Next(sg) do
		res=res
	end
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and res and g:FilterCount(Card.IsType,nil,TYPE_MONSTER)==1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)==1
end
function c98921052.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98921052.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(c98921052.fselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c98921052.fselect,false,2,2,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c98921052.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98921052.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c98921052.cfilter1(c,tp)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN)
end
function c98921052.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98921052.cfilter1,1,nil,tp)
end
function c98921052.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98921052.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end