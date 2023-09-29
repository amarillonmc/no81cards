local m=53705020
local cm=_G["c"..m]
cm.name="幻海袭 幽魂"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.SeadowRover(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.pubfilter(c)
	return not c:IsPublic()
end
function cm.thfilter(c,tp)
	return c:IsAbleToHand() and (c:IsControler(1-tp) and c:IsOnField() and c:IsType(TYPE_SPELL+TYPE_TRAP)
		or c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x3534))
end
function cm.gselect(g,e)
	return g:IsExists(Card.IsSetCard,1,nil,0x3534) and not g:IsContains(e:GetHandler())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.pubfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_ONFIELD,1,nil,tp)
		and not c:IsPublic()
		and #g>1 and g:IsExists(Card.IsSetCard,1,c,0x3534) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local hg=g:SelectSubGroup(tp,cm.gselect,false,1,2,e)
	Duel.ConfirmCards(1-tp,hg)
	SNNM.SetPublic(c,4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	for tc in aux.Next(hg) do SNNM.SetPublic(tc,4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,LOCATION_ONFIELD,1,1,nil,tp)
	local g2=Duel.GetMatchingGroup(function(c)return c:IsPublic() and c:IsAbleToDeck()end,tp,LOCATION_HAND,0,nil)
	if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 and g2:GetCount()>0 then
		Duel.BreakEffect()
		local sg=g2:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
