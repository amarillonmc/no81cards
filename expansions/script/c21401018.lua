--圣女消防战车！！！
function c21401018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetTarget(c21401018.target)
	e1:SetOperation(c21401018.activate)
	c:RegisterEffect(e1)
end

function c21401018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
	local b1=ct>0
	--local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
	--if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,b1,b2) end
	
	local cc1 = Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,25789292) 
	local cc2 = Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,27243130)
	local cc3 = Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,54773234)
	local cc4 = Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,96864811)
	if chk==0 then return 
		b1 and (cc1 or cc2 or cc3 or cc4)
	end
end


function c21401018.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	--if ft>=4 then ft=4 end
	--if not (
	--	Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,25789292) 
	--	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,27243130)
	--	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,54773234)
	--	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,96864811)
	--	) then
	--	return
	--end
	local g1,g2,g3,g4
	if ft>0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,25789292) and Duel.SelectYesNo(tp,aux.Stringid(21401018,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g1=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,25789292)
		ft=ft-1
	end
	
	if ft>0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,27243130) and Duel.SelectYesNo(tp,aux.Stringid(21401018,2))   then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g2=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,27243130)
		ft=ft-1
	end

	if ft>0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,54773234) and Duel.SelectYesNo(tp,aux.Stringid(21401018,3))  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g3=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,54773234)
		ft=ft-1
	end
	
	if ft>0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,96864811) and Duel.SelectYesNo(tp,aux.Stringid(21401018,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g4=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,96864811)
		ft=ft-1
	end
	
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	
	if #g1>0 then
		Duel.SSet(tp,g1)
	end

end