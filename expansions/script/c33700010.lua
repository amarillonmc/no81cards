--Protoform 黄金鸟
function c33700010.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33700010)
	e1:SetCost(c33700010.cost)
	e1:SetTarget(c33700010.target)
	e1:SetOperation(c33700010.operation)
	c:RegisterEffect(e1)
	--confrim
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c33700010.tg)
	e2:SetOperation(c33700010.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c33700010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c33700010.thfilter(c)
	return c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33700010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700010.thfilter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700010.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c33700010.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700010.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode())  and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700010.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6440) and not c:IsPublic()
end
function c33700010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 
		and Duel.IsExistingMatchingCard(c33700010.filter,tp,LOCATION_HAND,0,1,nil) end
end
function c33700010.sefilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x6440) or c:IsSetCard(0xa440)) and c:IsAbleToHand()
end
function c33700010.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if tg==0 then return end
	local g=Duel.SelectMatchingCard(tp,c33700010.filter,tp,LOCATION_HAND,0,1,tg,nil)
	if g:GetCount()>0 then
	Duel.ConfirmCards(1-tp,g)
	Duel.ConfirmDecktop(tp,g:GetCount())
	local dg=Duel.GetDecktopGroup(tp,g:GetCount())
	local cg=dg:Filter(c33700010.sefilter,nil)
	if cg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=cg:Select(tp,cg:GetCount(),cg:GetCount(),nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleHand(tp)
end
end