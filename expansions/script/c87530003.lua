--薇丝帕之虫惑魔
function c87530003.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c87530003.efilter)
	c:RegisterEffect(e1)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87530003,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,87530003)
	e2:SetCost(c87530003.spco)
	e2:SetTarget(c87530003.spta)
	e2:SetOperation(c87530003.spop)
	c:RegisterEffect(e2)
	--search trap
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(87530003,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,87531003)
	e3:SetCost(c87530003.cost)
	e3:SetTarget(c87530003.target)
	e3:SetOperation(c87530003.operation)
	c:RegisterEffect(e3)
end

function c87530003.efilter(e,te)
	local c=te:GetHandler()
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89))
end

function c87530003.spfilter(c)
	return (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and c:IsAbleToGraveAsCost()
end
function c87530003.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87530003.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c87530003.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,2,nil)
	local num=Duel.SendtoGrave(g,nil,0,REASON_COST)
	e:SetLabel(num)
end
function c87530003.spta(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c87530003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and e:GetLabel()==2 then
		if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(87530003,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()~=0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end

function c87530003.xfilter(c)
	return c:IsCode(87530003) and c:IsAbleToGraveAsCost()
end

function c87530003.cosfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGraveAsCost()
end

function c87530003.sfilter(c)
	return c:IsType(TYPE_TRAP) and (c:IsSetCard(0x4c) or c:IsSetCard(0x89)) and c:IsAbleToHand()
end

function c87530003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
--check if player can pay cost
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
--discard 1 or 2 card from hand
	local mx = Duel.GetMatchingGroup(c87530003.sfilter,tp,LOCATION_DECK,0,nil):GetCount()
	if mx>=2 then mx=2 end
	local g=Duel.GetMatchingGroup(c87530003.cosfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,0,mx-1,nil)
	sg:AddCard(c)

	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(sg:GetCount())
end

function c87530003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87530003.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,e:GetLabel(),tp,LOCATION_DECK)
end


function c87530003.operation(e,tp,eg,ep,ev,re,r,rp)
	local mx=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g3=Duel.SelectMatchingCard(tp,c87530003.sfilter,tp,LOCATION_DECK,0,mx,mx,nil)
	if g3:GetCount()>0 then
		Duel.SendtoHand(g3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g3)
	end
end