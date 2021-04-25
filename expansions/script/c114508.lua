--里械仪者·加速
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114508)
function cm.initial_effect(c)
	local e2 = rsef.I(c,"pos",{1,nil,3},"pos",nil,LOCATION_SZONE,nil,nil,rsop.target(cm.posfilter,"pos",LOCATION_MZONE),cm.posop) 
	local e3 = rsef.I(c,"sp",{1,nil,3},"sp",nil,LOCATION_SZONE,nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	local e4 = rsef.FV_UPDATE(c,"atk",cm.val,aux.TargetBoolFunction(Card.IsType,TYPE_FLIP),{LOCATION_MZONE,0})
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca1) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and rsop.SelectYesNo(tp,"th") then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.posfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition() and c:IsSetCard(0xca1)
end
function cm.posop(e,tp)
	local tc = rsop.SelectSolve(HINTMSG_POSCHANGE,tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil,{}):GetFirst()
	if tc then
		local pos = Duel.SelectPosition(tp,tc,POS_FACEUP)
		Duel.ChangePosition(tc,pos)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local ct,og = rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,{0,tp,tp,false,false,POS_FACEDOWN_DEFENSE },e,tp)
	if #og > 0 then
		Duel.ConfirmCards(1-tp,og)
	end
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(rscf.fufilter(Card.IsType,TYPE_FLIP),0,rsloc.mg,rsloc.mg,nil)*300
end