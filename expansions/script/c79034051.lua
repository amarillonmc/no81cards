--即使燃烧生命也要继续战斗！
function c79034051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79034051,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,79034051)
	e2:SetCost(c79034051.cost)
	e2:SetTarget(c79034051.tg)
	e2:SetOperation(c79034051.op)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)   
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,79034051999)
	e3:SetCost(c79034051.tgcost)
	e3:SetTarget(c79034051.tgtg)
	e3:SetOperation(c79034051.tgop)
	c:RegisterEffect(e3)
end
function c79034051.cofil(c)
	return c:IsAbleToGraveAsCost()
end
function c79034051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.IsExistingMatchingCard(c79034051.cofil,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79034051.cofil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.PayLPCost(tp,800)
end
function c79034051.filter1(c)
	return c:IsSetCard(0xa007) and c:IsAbleToHand()
end
function c79034051.filter2(c)
	return c:IsSetCard(0xa007) and c:IsSSetable() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c79034051.filter3(c,e,tp)
	return c:IsSetCard(0xa007) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79034051.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then
			return end
	end
	local b1=Duel.IsExistingMatchingCard(c79034051.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c79034051.filter2,tp,LOCATION_GRAVE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c79034051.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 or b3 end
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(79034051,0),aux.Stringid(79034051,1),aux.Stringid(79034051,2))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(79034051,0),aux.Stringid(79034051,1))
	elseif b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(79034051,1),aux.Stringid(79034051,2))+1
	elseif b1 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(79034051,0),aux.Stringid(79034051,2))
		if op==1 then
		op=2
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(79034051,0))  
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(79034051,1))+1  
	elseif b3 then
		op=Duel.SelectOption(tp,aux.Stringid(79034051,2))+2  
	end
	e:SetLabel(op)
	local tc=0
	if op==0 then
	tc=Duel.SelectMatchingCard(tp,c79034051.filter1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetTargetCard(tc)
	elseif op==1 then 
	tc=Duel.SelectMatchingCard(tp,c79034051.filter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.SetTargetCard(tc)
	else
	end
end
function c79034051.op(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c79034051.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	local tc1=Duel.GetFirstTarget()
	local op=e:GetLabel()
	if op==0 then
	Duel.SendtoHand(tc1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc1)
	elseif op==1 then
	Duel.SSet(tp,tc1)
	elseif op==2 then
	tc=Duel.SelectMatchingCard(tp,c79034051.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79034051.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c79034051.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_SZONE) end
end
function c79034051.filter4(c)
	return c:IsSetCard(0xa007) and c:IsAbleToGrave() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c79034051.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034051.filter4,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79034051.filter4,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,LOCATION_DECK)
end
function c79034051.tgop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end




