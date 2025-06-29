--翼冠束·召来
function c11570019.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(c11570019.excost)
	e0:SetDescription(aux.Stringid(11570019,2))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11570019.target)
	e1:SetOperation(c11570019.activate)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,11570019)
	e2:SetCost(c11570019.efcost)
	e2:SetTarget(c11570019.eftg)
	e2:SetOperation(c11570019.efop)
	c:RegisterEffect(e2)
end
function c11570019.costfilter(c)
	return c:IsSetCard(0x810) and c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
end
function c11570019.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570019.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11570019.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11570019.spfilter(c,e,tp)
	return c:IsSetCard(0x810) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11570019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c11570019.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c11570019.chkfilter(c)
	return c:IsSetCard(0x3810) and c:IsFaceup()
end
function c11570019.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11570019.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
		if Duel.IsExistingMatchingCard(c11570019.chkfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,11570019)==0 then
			local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
			g:Merge(g2)
		end
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=g:Select(tp,1,1,nil)
		if tg:GetFirst():IsControler(1-tp) then Duel.RegisterFlagEffect(tp,11570019,RESET_PHASE+PHASE_END,0,1) end
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c11570019.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_REMOVED) end
	Duel.SendtoGrave(c,REASON_COST+REASON_RETURN)
end
function c11570019.effilter(c)
	return c:IsSetCard(0x810) and c:IsType(TYPE_MONSTER)
end
function c11570019.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c11570019.effilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c11570019.efop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or not Duel.IsExistingMatchingCard(c11570019.effilter,tp,LOCATION_GRAVE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11570019,0))
	local fc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11570019,1))
	local gc=Duel.SelectMatchingCard(tp,c11570019.effilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(fc,gc))
	local code=gc:GetOriginalCodeRule()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(code)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	fc:RegisterEffect(e1)
	fc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
end
