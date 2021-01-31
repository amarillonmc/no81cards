--宇宙机器人 黑金古桥
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001002)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	local e1=rsef.FC(c,EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_EXTRA)
	rsef.RegisterSolve(e1,cm.thcon,nil,nil,cm.thop)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_REMOVE)
	local e3=rsef.I(c,{m,1},{1,m},"te",nil,LOCATION_GRAVE,nil,rscost.cost(cm.tgfilter,"tg",rsloc.ho),rsop.target(Card.IsAbleToExtra,"te"),cm.teop)
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,2},{1,m+100},"sp,disd","de,dsp",rscon.sumtype("link"),nil,rsop.target(cm.spfilter,"sp",rsloc.hg),cm.spop)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local ct,og,tc=rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,rsloc.hg,0,1,1,nil,{},e,tp)
	if tc and tc:IsType(TYPE_LINK) then
		local dct=tc:GetLink()
		if Duel.IsPlayerCanDiscardDeck(tp,dct) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.DiscardDeck(tp,dct,REASON_EFFECT)
		end
	end
end
function cm.tgfilter(c)
	if not c:IsAbleToGraveAsCost() then return false end
	return (c:IsType(TYPE_SPELL+TYPE_TRAP)) or (c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()))
end
function cm.teop(e,tp)
	local c=rscf.GetSelf(e) 
	if c then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function cm.cfilter(c,tp,re)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_COST) and re and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_MACHINE) and c:GetPreviousControler()==tp
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)==0 and eg:IsExists(cm.cfilter,1,nil,tp,re) and e:GetHandler():IsAbleToGrave()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then return end
	rshint.Card(m)  
	Duel.RegisterFlagEffect(tp,m,rsreset.pend,0,1)
	if Duel.SendtoGrave(c,REASON_EFFECT)>0 then
		local tg=eg:Filter(cm.cfilter,nil,tp,re)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end