--采摘小青蛙
function c9320010.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9320010.efilter)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9320010,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9320010.tg)
	e2:SetOperation(c9320010.op)
	c:RegisterEffect(e2)
end
function c9320010.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsRace(RACE_PLANT)
end
function c9320010.filter(c,lv)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
		   and c:IsAbleToHand() and c:GetLevel()<lv
		   and bit.band(c:GetRace(),RACE_PLANT)~=0
end
function c9320010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(c9320010.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_ONFIELD)
end
function c9320010.op(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetHandler():GetLevel()
	local sg=Duel.GetMatchingGroup(c9320010.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,nil,lv)
	if sg:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=sg:Select(tp,1,1,nil)
	sg:RemoveCard(hg:GetFirst())
	sg=sg:Filter(Card.IsCode,nil,hg:GetFirst():GetCode())
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9320010,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=sg:Select(tp,1,1,nil)
		hg:Merge(tg)
	end
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)
end