--俯瞰苍界之鸦
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
fu_kurusu = fu_kurusu or {}
local FK=fu_kurusu
function FK.Effect(c,code,cat,tg,op)
	aux.AddCodeList(c,20000001)
	local e1=fucg.ef.A(c,{code,0},cat+CATEGORY_TOHAND+CATEGORY_SEARCH,nil,EFFECT_FLAG_CARD_TARGET,code,nil,FK.A_con,nil,tg,op,c)
	local e2=fucg.ef.QO(c,{m,1},CATEGORY_SPECIAL_SUMMON,EVENT_CHAINING,nil,"H",code+100,nil,FK.QO_con,FK.QO_cos,FK.QO_tg,FK.QO_op,c)
	return e1,e2
end
function FK.A_exf(c)
	return c:IsAbleToHand() and aux.IsCodeListed(c,20000001)
end
function FK.A_ex(tp,chk)
	local g=Duel.GetMatchingGroup(FK.A_exf,tp,LOCATION_DECK,0,nil)
	if chk=="chk" then return #g>0 end
	if chk=="tg" then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
	if chk=="op" then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=g:Select(tp,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function FK.A_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0):Filter(Card.IsFaceup,nil):FilterCount(Card.IsCode,nil,20000001)>0
end
function FK.QO_con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function FK.QO_cosf(c)
	return c:IsDiscardable() and c:IsType(TYPE_SPELL)
end
function FK.QO_cos(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(FK.QO_cosf,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,FK.QO_cosf,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function FK.QO_tgf(c,e,tp)
	return c:IsCode(20000001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function FK.QO_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(FK.QO_tgf,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function FK.QO_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,FK.QO_tgf,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
if not cm then return end
function cm.initial_effect(c)
	local e1,e2=FK.Effect(c,m,CATEGORY_TOHAND,cm.tg,cm.op)
end
--e1
function cm.tgf(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and cm.tgf(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and FK.A_ex(tp,"chk") end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tgf,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	FK.A_ex(tp,"tg")
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		FK.A_ex(tp,"op")
	end
end