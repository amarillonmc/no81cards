--花型异生兽 莱芙丽雅
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000035)
function cm.initial_effect(c)
	rssb.SummonCondition(c)  
	local e1=rsef.I(c,{m,0},{1,m},"rm,td,dr",nil,LOCATION_HAND,rssb.cfcon,nil,rsop.target({Card.IsAbleToDeck,"td",LOCATION_HAND,0,true,true,c},{nil,"dr",cm.fun},{rssb.rmfilter,"rm"}),cm.drop)
	local e2=rsef.FC(c,EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.addop)
end
function cm.fun(e,tp)
	return Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_HAND,0,e:GetHandler())
end
function cm.drop(e,tp)
	local c=aux.ExceptThisCard(e)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,c)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
		if Duel.Draw(tp,#og,REASON_EFFECT)>0 and c then
			Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function cm.addop(e,tp,eg)
	local c=e:GetHandler()
	if eg:IsContains(c) then return end
	for tc in aux.Next(eg) do
		tc:AddCounter(0x104f,1)
		local e1=rsef.SC({c,tc},EVENT_LEAVE_FIELD_P)
		e1:SetOperation(cm.lop)
	end
end
function cm.lop(e,tp)
	local c=e:GetHandler()
	if c:GetCounter(0x104f)>0 then
		Duel.Damage(c:GetControler(),500,REASON_EFFECT)
	end
end
