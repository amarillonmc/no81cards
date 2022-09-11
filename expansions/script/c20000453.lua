--渊异术士 刻蚀龙
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000450") end) then require("script/c20000450") end
function cm.initial_effect(c)
	cm.Hand_Be_Open = fu_Abyss.Hand_Be_Open(c,m,cm.tg1,cm.op1,CATEGORY_TOHAND)
	local e1,e2 = fu_Abyss.Hand_Open(c,cm.op2)
end
--e1
function cm.tgf1(c)
	return c:IsAbleToHand() and c:GetType()&0x82==0x82
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local v=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not v then return end
	Duel.SendtoHand(v,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,v)
end
--e2
function cm.opf2(c,e)
	return c:GetType()&0x81==0x81 and c:IsRace(RACE_DRAGON) and (not e or (not c:IsImmuneToEffect(e) and c:IsFaceup()))
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(24,0,aux.Stringid(m,0))
	local g=Duel.GetMatchingGroup(cm.opf2,tp,LOCATION_MZONE,0,nil,e)
	local v=Duel.GetMatchingGroup(cm.opf2,tp,LOCATION_GRAVE,0,nil):GetMaxGroup(Card.GetBaseDefense)
	if #g==0 or not v then return end
	v=v:GetFirst():GetBaseDefense()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(v)
		tc:RegisterEffect(e1)
	end
end