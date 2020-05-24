--混沌的轮回 循环
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30000220)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"td,dr",nil,nil,nil,cm.tg,cm.act)
	local e2=rsef.I(c,{m,0},nil,"td,dr","tg",LOCATION_GRAVE,aux.exccon,nil,rstg.target({cm.tdfilter,"td",LOCATION_GRAVE+LOCATION_REMOVED,0,2 },rsop.list(Card.IsAbleToDeck,"td"),rsop.list(nil,"dr",1)),cm.drop)
	if cm.actct then return end
	cm.actct=0
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_NEGATED)
	ge1:SetOperation(cm.regop)
	Duel.RegisterEffect(ge1,tp)
end
function cm.checkfun(att)
	return function(c)
		return (c:IsType(TYPE_MONSTER) and c:IsAttribute(att)) or ((c:IsComplexType(TYPE_SPELL+TYPE_PENDULUM) and c:GetAttribute()&att>0))
	end
end
cm.hnchecks={cm.checkfun(ATTRIBUTE_LIGHT),cm.checkfun(ATTRIBUTE_DARK)}
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(m) then
		cm.actct=math.max(cm.actct-1,0)
	end
end
function cm.cfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToDeck()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroupEach(cm.hnchecks,aux.TRUE) and Duel.IsPlayerCanDraw(tp,cm.actct+3) end
	cm.actct=cm.actct+1
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.act(e,tp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if not g:CheckSubGroupEach(cm.hnchecks,aux.TRUE) then return end
	local tg=g:SelectSubGroupEach(tp,cm.hnchecks,false,aux.TRUE)
	local hg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg>0 then
		Duel.ConfirmCards(1-tp,hg)
	end
	Duel.HintSelection(tg-hg)
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 then
		Duel.Draw(tp,cm.actct+2,REASON_EFFECT)
	end
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsAbleToDeck()
end
function cm.drop(e,tp)
	local tg=rsgf.GetTargetGroup()
	local c=aux.ExceptThisCard(e)
	if not c or #tg<=0 then return end
	tg:AddCard(c)
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end


