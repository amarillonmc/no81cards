--恶路程式 头脑
function c40008590.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008590,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c40008590.cost)
	e1:SetCondition(c40008590.spcon)
	e1:SetTarget(c40008590.copytg)
	e1:SetOperation(c40008590.copyop)
	c:RegisterEffect(e1)
	if not c40008590.global_check then
		c40008590.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(40008590)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(40008590)
		Duel.RegisterEffect(ge2,0)
	end
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008590,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,40008590)
	e5:SetCondition(c40008590.spcon2)
	e5:SetTarget(c40008590.sptg)
	e5:SetOperation(c40008590.spop)
	c:RegisterEffect(e5)	 
end
function c40008590.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(40008590)>0
end
function c40008590.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c40008590.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008590.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40008590.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c40008590.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c40008590.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE)  and c40008590.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008590.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40008590.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,e:GetHandler())
end
function c40008590.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
	end
end
function c40008590.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c40008590.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP_DEFENSE)
end
function c40008590.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40008590.spfilter,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,nil,e,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c40008590.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g1=Duel.GetMatchingGroup(c40008590.spfilter,tp,0,LOCATION_HAND,nil,e,1-tp)
	local g2=Duel.GetMatchingGroup(c40008590.spfilter,tp,0,LOCATION_DECK,nil,e,1-tp)
	local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40008590.spfilter),tp,0,LOCATION_GRAVE,nil,e,1-tp)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(1-tp,aux.Stringid(40008590,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(1-tp,1,1,nil)
		sg:Merge(sg1)
		g2:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		g3:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		ft=ft-1
	end
	if g2:GetCount()>0 and ft>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(1-tp,aux.Stringid(40008590,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(1-tp,1,1,nil)
		sg:Merge(sg2)
		g3:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		ft=ft-1
	end
	if g3:GetCount()>0 and ft>0 and (sg:GetCount()==0 or Duel.SelectYesNo(1-tp,aux.Stringid(40008590,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=g3:Select(1-tp,1,1,nil)
		sg:Merge(sg3)
	end
	if Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP_DEFENSE)>0 then
		 Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40008590.ttfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
   end
end
function c40008590.ttfilter(c)
	return c:IsAbleToHand()
end


