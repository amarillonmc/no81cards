local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCost(s.nscost)
	e1:SetTarget(s.nstg)
	e1:SetOperation(s.nsop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsSetCard(0x28) and c:IsType(TYPE_MONSTER) and c:IsAttack(0) and c:IsAbleToGraveAsCost()
end
function s.cfilter2(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function s.nscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and g:IsExists(s.cfilter2,1,nil,g) end
	local sg=g:Filter(s.cfilter2,nil,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local hg1=sg:Select(tp,1,1,nil)
	local hg2=sg:FilterSelect(tp,Card.IsCode,1,2,hg1,hg1:GetFirst():GetCode())
	Duel.SendtoGrave(Group.__add(e:GetHandler(),Group.__add(hg1,hg2)),REASON_COST)
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSummonable(true,nil)
end
function s.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then Duel.Summon(tp,tc,true,nil) end
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER)
end
function s.fselect(g)
	return g:GetClassCount(Card.GetCode)==1
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(s.fselect,2,#g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,#g)
	Duel.SetTargetCard(sg)
	e:SetLabel(sg:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.adfilter(c)
	return c:GetAttack()~=c:GetDefense()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetLabel(e:GetLabel())
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,e:GetLabel()))
	e1:SetValue(s.effval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 or not c:IsLocation(LOCATION_HAND) then return end
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()<=0 or not g:IsExists(s.adfilter,1,nil) or not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local sg=g:FilterSelect(tp,s.adfilter,1,#g,nil)
	for tc in aux.Next(sg) do
		local num=tc:GetAttack()-tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		if num>0 then e1:SetCode(EFFECT_UPDATE_DEFENSE) else e1:SetCode(EFFECT_UPDATE_ATTACK) end
		e1:SetValue(math.abs(num))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.effval(e,re,rp)
	return re:GetHandler()==e:GetHandler()
end
