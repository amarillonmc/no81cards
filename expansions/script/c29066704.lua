--方舟骑士团-远牙
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function cm.opf1(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x87af) and c:IsAbleToHand()
end
function cm.opf2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5):Filter(cm.opf1,nil)
	local g1=Duel.GetDecktopGroup(tp,5):Filter(cm.opf2,nil)  
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(12931061,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.BreakEffect()
			g=g:Select(tp,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
		end
		if #g1>=3 and Duel.IsExistingMatchingCard(cm.opf1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.BreakEffect()
			local g2=Duel.SelectMatchingCard(tp,cm.opf1,tp,LOCATION_DECK,0,1,1,nil)
			g2=g2:GetFirst()
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
		end
	if c:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) then
		if Duel.IsPlayerAffectedByEffect(tp,29080291) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29080291,2)) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
			Duel.ShuffleHand(tp)
		end
	end
end
