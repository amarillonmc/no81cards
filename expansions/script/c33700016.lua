--Protoform制造
function c33700016.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700016,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c33700016.condition)
	e1:SetTarget(c33700016.target)
	e1:SetOperation(c33700016.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700016,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33700016.condition)
	e2:SetTarget(c33700016.sptg)
	e2:SetOperation(c33700016.spop)
	c:RegisterEffect(e2)
end
function c33700016.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3440) or c:IsSetCard(0xa440))
end
function c33700016.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33700016.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c33700016.sefilter(c)
	return c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER) and c:GetAttack()>0 and c:IsAbleToHand()
end
function c33700016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700016.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c33700016.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700016.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and  Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
	Duel.ConfirmCards(1-tp,g)
	Duel.BreakEffect()
	Duel.Damage(tp,g:GetFirst():GetAttack(),REASON_EFFECT)
end
end
function c33700016.refilter(c)
	return c:IsSetCard(0x6440) and c:IsAbleToRemove()
end
function c33700016.refilter2(c,e,tp,cg)
	return c:IsSetCard(0x6440) and c:IsLevelBelow(cg) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c33700016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c33700016.refilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return  Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c33700016.refilter2,tp,LOCATION_HAND,0,1,nil,e,tp,cg:GetCount()) end
	 Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33700016.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.GetMatchingGroup(c33700016.refilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c33700016.refilter2,tp,LOCATION_HAND,0,nil,e,tp,cg:GetCount())
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33700016,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg1=Group.CreateGroup()
	if lv>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=cg:Select(tp,lv,lv,nil)
		rg1:Merge(rg2)
	end
	if Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)>0 and Duel.GetMZoneCount(tp)>0 then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700016.refilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end
end
end
   