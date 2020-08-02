--雪之圆舞曲
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000088)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},{3,m,1},"td,se,th,dr",nil,nil,nil,cm.tg,cm.act)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)	
	local e3=rsef.FC({c,0},EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetOperation(cm.chop)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetDecktopGroup(tp,8)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and dg:GetCount()==8 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.act(e,tp)
	local c=rscf.GetSelf(e)
	if not c or not aux.TRUE(c:CancelToGrave()) or Duel.SendtoDeck(c,nil,2,REASON_EFFECT)<=0 or not c:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(tp)
	Duel.ConfirmDecktop(tp,8)
	local g=Duel.GetDecktopGroup(tp,8)
	if #g<=0 then return end
	local ct=g:FilterCount(Card.IsCode,nil,m)
	Duel.BreakEffect()
	if ct==0 then
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	elseif ct==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif ct==2 then
		local g2=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		if #g2>=2 then
			local tc1=g2:GetMaxGroup(Card.GetSequence):GetFirst()
			local tc2=g2:GetMinGroup(Card.GetSequence):GetFirst()
			Duel.SendtoHand(rsgf.Mix2(tc1,tc2),nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,rsgf.Mix2(tc1,tc2))
		end
	elseif ct==3 then
		rsop.SelectToHand(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(m)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if ev<=1 then return end
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	if te:GetHandler()==e:GetHandler() then
		rshint.Card(m)
		Duel.ChangeTargetCard(ev,Group.CreateGroup())
		Duel.ChangeChainOperation(ev,cm.rep_op)
	end
end
function cm.rep_op(e,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end