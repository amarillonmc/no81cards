--溯轮杀
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000032)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil):RandomSelect(tp,1)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function cm.filter(c)
	return c:IsCode(60000032) and c:IsAbleToGraveAsCost()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,100)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,100,REASON_EFFECT)~=0 then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetOperation(cm.reop)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,2000,REASON_EFFECT)
	e:Reset()
end
function cm.drfilter(c,e)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cm.drfilter,tp,LOCATION_REMOVED,0,e:GetHandler(),e)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and g:GetClassCount(Card.GetCode)>4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,5,5)
	aux.GCheckAdditional=nil
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end












