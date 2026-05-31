--方舟骑士团-幽灵鲨
function c29072102.initial_effect(c)
	--to hand/set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29072102,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c29072102.thtg)
	e1:SetOperation(c29072102.thop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29072102,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCountLimit(1,29072102)
	e3:SetCondition(c29072102.spcon)
	e3:SetTarget(c29072102.sptg)
	e3:SetOperation(c29072102.spop)
	c:RegisterEffect(e3)
end
--sp
function c29072102.spcon(e,tp,eg,ep,ev,re,r,rp)
	local attr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE)
	local b1=re:IsActiveType(TYPE_MONSTER) and attr&ATTRIBUTE_WATER>0 and ep~=tp
	local b2=re:GetHandler():IsSetCard(0x87af) and re:IsActiveType(TYPE_MONSTER) and ep==tp
	local b3=e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b4=e:GetHandler():IsLocation(LOCATION_MZONE) and Duel.IsChainDisablable(ev)
	return (b1 or b2) and (b3 or b4) 
end
function c29072102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) or e:GetHandler():IsLocation(LOCATION_MZONE) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29072102.spop(e,tp,eg,ep,ev,re,r,rp,op)
	local c=e:GetHandler()
	if op==nil then
		local chk=c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		op=aux.SelectFromOptions(tp,
			{chk,aux.Stringid(29072102,1)},
			{true,aux.Stringid(29072102,2)},
			{chk,aux.Stringid(29072102,3)})
	end
	if op&1>0 then
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		if op==3 then Duel.BreakEffect() end
	end
	if op&2>0 then
		Duel.NegateEffect(ev)
	end
end
--to hand/set
function c29072102.thfilter(c)
	if not (c:IsSetCard(0x67af) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c29072102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29072102.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c29072102.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c29072102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end












