--守护神 什弥尼斯
function c62501651.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c62501651.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,62501651)
	e1:SetTarget(c62501651.thtg)
	e1:SetOperation(c62501651.thop)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,62501651)
	e2:SetCost(c62501651.cost)
	e2:SetTarget(c62501651.target)
	e2:SetOperation(c62501651.operation)
	c:RegisterEffect(e2)
end
c62501651.has_text_type=TYPE_SPIRIT
function c62501651.lcheck(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_SPIRIT)
end
function c62501651.thfilter(c,chk)
	return c:IsSetCard(0xea2) and c:IsAbleToHand() and c:IsFaceupEx() and (chk==0 or aux.NecroValleyFilter()(c))-- and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c62501651.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501651.thfilter,tp,LOCATION_DECK+0x30,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+0x30)
end
function c62501651.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501651.thfilter,tp,LOCATION_DECK+0x30,0,1,1,nil,1):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(62501651,2)) then return end
end
function c62501651.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	local c=e:GetHandler()
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(c)
		e1:SetCondition(c62501651.retcon)
		e1:SetOperation(c62501651.retop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c62501651.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function c62501651.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c62501651.rtfilter(c,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() and c:IsFaceup()
end
function c62501651.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c62501651.rtfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=true
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(62501651,1)},
		{b2,aux.Stringid(62501651,2)})
	e:SetLabel(op)
end
function c62501651.sumfilter(c,code)
	return c:IsType(TYPE_SPIRIT) and c:GetOriginalCodeRule()~=code and c:IsSummonable(true,nil)
end
function c62501651.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.SelectMatchingCard(tp,c62501651.rtfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if not tc then return end
		local code=tc:GetOriginalCodeRule()
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(c62501651.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,code) and Duel.SelectYesNo(tp,aux.Stringid(62501651,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c62501651.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,code)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		Duel.RegisterEffect(e2,tp)
	end
end
