--牛头人战曲
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,5053103)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.CheckReleaseGroup(tp,aux.TRUE,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.thfilter1(c)
	return (c:IsCode(5053103) or c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_BEASTWARRIOR) and c:IsLevel(4) and c:IsAttack(1700) and c:IsDefense(1000))
		and c:IsAbleToHand()
end
function s.thfilter2(c)
	return not c:IsCode(id) and aux.IsCodeListed(c,5053103) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local res=0
	if tc:GetOwner()==1-tp then res=1 end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end
	if res==1 and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local br=0
	if opval[op]==1 or opval[op]==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			br=1
		end
	end
	if opval[op]==2 or opval[op]==3 then
		if br==1 then
			Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end