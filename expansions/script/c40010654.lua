--兽神鏖战
local m=40010654
local cm=_G["c"..m]
cm.named_with_BeastDeity=1
function cm.BeastDeity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BeastDeity
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)  
end
function cm.thfilter1(c)
	return not c:IsCode(m) and cm.BeastDeity(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.cfilter(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup())  and c:IsAbleToGraveAsCost()
		and cm.BeastDeity(c)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.valcon)
		token:RegisterEffect(e1,true)
	end
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end