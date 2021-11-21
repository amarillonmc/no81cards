--D级人员
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102002,"SCP_J")
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"dr,th",nil,LOCATION_MZONE,nil,rscost.cost(Card.IsReleasable,"res",LOCATION_ONFIELD),rsop.target(1,"dr"),cm.drop)
	local e2=rsef.I(c,{m,1},nil,"sp",nil,LOCATION_HAND,cm.spcon,nil,rsop.target(rscf.spfilter2,"sp"),cm.spop)
end
function cm.drop(e,tp)
	if Duel.Draw(tp,1,REASON_EFFECT)<=0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:CheckSetCard("SCP") and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		rsop.SelectToHand(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil,{})
	end
	Duel.ShuffleHand(tp)
end
function cm.spcon(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.spop(e,tp)
	local c=e:GetHandler()
	local e1,e2=rsef.FV_LIMIT_PLAYER({c,tp},"sp,sum",nil,cm.ltg,{1,0},nil,rsreset.pend)
	if c:IsRelateToEffect(e) then
		rssf.SpecialSummon(c)
	end
end
function cm.ltg(e,c)
	return not c:CheckSetCard("SCP")
end