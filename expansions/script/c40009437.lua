--机械加工 蚊子
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009437)
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_INSECT),1)
	c:EnableReviveLimit()
	local e1 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"sp",{1,m},"sp","de",rscon.sumtype("syn"),nil,rsop.target(cm.spfilter,"sp",rsloc.hd),cm.spop)
	local e2 = rsef.I(c,"th",{1,m+100},"se,th","tg",LOCATION_MZONE,nil,nil,cm.thtg,cm.thop)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(4) and rscf.spfilter2()(c,e,tp)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,rsloc.hd,0,1,1,nil,{},e,tp)
end
function cm.tgfilter(c,lv)
	local lv2 = c:GetOriginalLevel()
	return c:IsAbleToGrave() and c:IsFaceup() and lv2>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,lv+lv2)
end 
function cm.thfilter(c,lv)
	return c:IsRace(RACE_INSECT) and c:IsAbleToHand() and c:IsLevelBelow(lv)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c = e:GetHandler()
	local lv = c:GetOriginalLevel()
	if chkc then return chkc ~= c and chkc:IsControler(tp) and cm.tgfilter(chkc,lv) end
	if chk == 0 then return c:IsAbleToGrave() and lv>0 and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,lv) end
	rshint.Select(tp,HINTMSG_SELF)
	local tc = Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,lv)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,rsgf.Mix2(c,tc),2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp)
	local c,tc = rscf.GetSelf(e), rscf.GetTargetCard()
	if not c or not tc then return end
	if Duel.SendtoGrave(rsgf.Mix2(c,tc),REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		rsop.SelectOC(nil,true)
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{},c:GetOriginalLevel() + tc:GetOriginalLevel())
	end
end