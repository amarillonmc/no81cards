--冥界的摆渡人 伊索德
function c54363166.initial_effect(c)
	--link
	aux.AddLinkProcedure(c,c54363166.lkcheck,2)
	c:EnableReviveLimit()
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(22657402)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54363166,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,54363166)
	e2:SetTarget(c54363166.hsptg)
	e2:SetOperation(c54363166.hspop)
	c:RegisterEffect(e2)
end
function c54363166.lkcheck(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807)
end
function c54363166.hspfilter1(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function c54363166.hspfilter2(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and (c:GetAttack()==0 or c:IsDefenseBelow(0)) and c:IsAbleToHand()
end
function c54363166.hspfilter3(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_ZOMBIE) and (c:GetAttack()==0 or c:IsDefenseBelow(0)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c54363166.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c54363166.hspfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c54363166.hspfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(c54363166.hspfilter3,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 or b3 end
	local ops,opval,g={},{}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(54363166,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(54363166,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(54363166,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	end
end
function c54363166.hspop(e,tp,eg,ep,ev,re,r,rp)
	local sel,g=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c54363166.hspfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoGrave(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c54363166.hspfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c54363166.hspfilter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end