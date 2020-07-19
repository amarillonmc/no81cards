--冥界的新咕代机械核心 无星死欲虫
function c54363184.initial_effect(c)
	--link
	aux.AddLinkProcedure(c,c54363184.lkcheck,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54363184,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,54363184)
	e1:SetCost(c54363184.spcost)
	e1:SetCondition(c54363184.hspcon)
	e1:SetTarget(c54363184.hsptg)
	e1:SetOperation(c54363184.hspop)
	c:RegisterEffect(e1)
	--grave spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54363184,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c54363184.sumcost)
	e2:SetTarget(c54363184.sumtg)
	e2:SetOperation(c54363184.sumop)
	c:RegisterEffect(e2)
end
function c54363184.lkcheck(c)
	return (c:IsRace(RACE_ZOMBIE) or c:IsRace(RACE_MACHINE) or c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807)) and c:IsLevelAbove(8)
end
function c54363184.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c54363184.hspfilter1(c,e,tp)
	return (c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813))  and c:IsAbleToGrave()
end
function c54363184.hspfilter2(c,e,tp)
	return (c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813)) and c:IsAbleToHand()
end
function c54363184.filter(c,e,tp)
	return (c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813))  and c:IsAbleToDeckOrExtraAsCost() and not c:IsCode(54363184)
end
function c54363184.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c54363184.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c54363184.hspfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c54363184.hspfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local ops,opval,g={},{}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(54363184,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(54363184,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c54363184.hspop(e,tp,eg,ep,ev,re,r,rp)
	local sel,g=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c54363184.hspfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoGrave(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c54363184.hspfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c54363184.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54363184.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c54363184.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c54363184.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c54363184.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end