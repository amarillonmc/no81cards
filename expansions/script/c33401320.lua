--D.A.L 故事的起点
local m=33401320
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsSetCard(0x341,0x340)  and c:IsAbleToHand() 
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xc342)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)   end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)   
end
function cm.ckfilter(c,e,tp)
	return c:IsLevel(4) and  c:IsSetCard(0x341) and ((c:IsType(TYPE_RITUAL) and  c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)) or c:IsCanBeSpecialSummoned(e,0,tp,false,false) )
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	if  Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,cm.ckfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc2=g2:GetFirst()
		if tc2:IsType(TYPE_RITUAL) then Duel.SpecialSummon(tc2,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		else
		 Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
		end 
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x341)
end
