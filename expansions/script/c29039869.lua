--方舟骑士-鞭刃
local cm,m,o=GetID()
cm.named_with_Arknight=1
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsDefenseAbove,2000))
	e2:SetValue(600)
	c:RegisterEffect(e2)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.BreakEffect()
	if tc:IsType(TYPE_MONSTER) and (tc:IsSetCard(0x87af) or (_G["c"..tc:GetCode()] and  _G["c"..tc:GetCode()].named_with_Arknight)) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(6459419,1)) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	return
	end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if not tc then return end
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	
end