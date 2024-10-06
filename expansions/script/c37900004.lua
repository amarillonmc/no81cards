--现世的神隐事件
function c37900004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCountLimit(1,37900004)
	e1:SetTarget(c37900004.tg)
	e1:SetOperation(c37900004.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,37900004)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c37900004.tg2)
	e2:SetOperation(c37900004.op2)
	c:RegisterEffect(e2)	
end
function c37900004.q(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsSetCard(0x389)
end
function c37900004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return Duel.IsExistingMatchingCard(c37900004.q,tp,LOCATION_HAND,0,1,nil,e,tp) and g:GetCount()==5 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c37900004.thfilter(c)
	return c:IsSetCard(0x389) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c37900004.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37900004.q,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
	local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()==5 then
		Duel.ConfirmDecktop(tp,5)
			if g:IsExists(c37900004.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(37900004,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c37900004.thfilter,1,1,nil)
				if Duel.SendtoHand(sg,nil,REASON_EFFECT) then
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
				end
			end
			Duel.SortDecktop(tp,tp,#g-1)
			for i=1,#g-1 do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
			end	
		end	
	end		
end
function c37900004.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsCode(37900004) and c:IsSetCard(0x389)
end
function c37900004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37900004.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c37900004.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c37900004.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
	 Duel.SSet(tp,g)
	end
end