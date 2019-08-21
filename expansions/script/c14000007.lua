--时穿剑·鸳鸯剑
local m=14000007
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--chrbeffects
	chrb.dire(c)
	chrb.ChronoDamageEffect(c,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,nil,nil,cm.atktg,cm.atkop)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==#g
end
function cm.sfilter(c,e,tp,tc)
	return chrb.CHRB(c) and c:IsAbleToHand() and not c:IsCode(tc:GetCode())
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	chrb.move(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp,tc) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end