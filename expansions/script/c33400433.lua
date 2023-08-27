--AST 对敌准备
local m=33400433
local cm=_G["c"..m]
function cm.initial_effect(c)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)   
end
function cm.filter(c)
	return c:IsSetCard(0x9343)  and c:IsAbleToHand() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)  end	   Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)   
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
   if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x341,0x4011,0,0,4,RACE_AQUA,ATTRIBUTE_WATER)  then 
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then			
			local token=Duel.CreateToken(tp,m+1)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()
		end
	end
   if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341)  and  (Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341)   
		or (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
			(Duel.IsExistingMatchingCard(cm.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
			Duel.IsExistingMatchingCard(cm.cccfilter2,tp,LOCATION_MZONE,0,1,nil))) )
   then
		if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and   Duel.SelectYesNo(tp,aux.Stringid(m,2))then
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				 local g2=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				 if #g2>0 then
					 Duel.SendtoHand(g2,nil,REASON_EFFECT)
					 Duel.ConfirmCards(1-tp,g2)
				 end 
		end
   end
end
function cm.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function cm.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.thfilter(c)
	return c:IsSetCard(0x6343)  and c:IsAbleToHand()
end
