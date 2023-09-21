--氕素龙
function c98920430.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,22587018,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND) 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920430,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,98920430)
	e1:SetCost(c98920430.cost)
	e1:SetTarget(c98920430.target)
	e1:SetOperation(c98920430.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	if not c98920430.global_check then
		c98920430.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c98920430.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98920430.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,0xff,0xff,nil,0x100)
	local tc=g:GetFirst()
	while tc do
		if tc:IsCode(6890729) then
			aux.AddCodeList(tc,43017476,22587018,58071123,6022371,85066822)
		elseif tc:IsCode(45898858) then
			aux.AddCodeList(tc,85066822,22587018,58071123)
		elseif tc:IsCode(79402185) then
			aux.AddCodeList(tc,43017476,58071123,85066822,6022371)
		elseif tc:IsCode(10150072) then
			aux.AddCodeList(tc,10150071,15981690,58071123)
		end
		tc=g:GetNext()
	end
end
function c98920430.cfilter(c,e,tp)
	return c:IsSetCard(0x100) and Duel.IsExistingMatchingCard(c98920430.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c,e,tp) and c:IsAbleToGraveAsCost()
end
function c98920430.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c98920430.filter2(c,mc,e,tp)
	return aux.IsCodeListed(mc,c:GetCode()) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or (c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.IsExistingMatchingCard(c98920430.ccfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)))
end
function c98920430.ccfilter(c)
	return c:IsFaceup() and c:IsCode(58071123)
end
function c98920430.target(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c98920430.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end	
	local g=Duel.SelectMatchingCard(tp,c98920430.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c98920430.operation(e,tp,eg,ep,ev,re,r,rp)
	local cc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920430.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,cc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g:GetFirst(),0,tp,tp,true,false,POS_FACEUP)
	end
end