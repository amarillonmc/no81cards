local m=189115
local cm=_G["c"..m]
cm.name="恒夜骑士-向曜之尼格蒂姆"
if not pcall(function() require("expansions/script/c189113") end) then require("script/c189113") end
function cm.initial_effect(c)
	ven.EnableSpiritReturn(c,function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(function(c)return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)end,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil) or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then Duel.Summon(tp,tc,true,nil) else Duel.MSet(tp,tc,true,nil) end
	end
	,CATEGORY_SUMMON,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.thfilter(c)
	return c:IsSetCard(0x1cae) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
