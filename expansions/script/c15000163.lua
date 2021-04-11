local m=15000163
local cm=_G["c"..m]
cm.name="红神的信徒·艾卡依璃"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000113)
	--BloDivinity is above
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>=2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,15000164,0,0x4011,100,100,1,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.filter(c)
	return aux.IsCodeListed(c,15000113) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,15000164,0,0x4011,100,100,1,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then return end
	local token=Duel.CreateToken(tp,15000164)
	local token2=Duel.CreateToken(tp,15000164)
	local ag=Group.FromCards(token,token2)
	if Duel.SpecialSummon(ag,0,tp,1-tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local ag=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if ag:GetCount()~=0 and Duel.SendtoHand(ag,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,ag)
		end
	end
end