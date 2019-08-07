--冥魂龙王 墨该拉
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103014
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,cm.lfilter,2,2,cm.gf)
	c:EnableReviveLimit()
	local e1=rsef.I(c,{m,0},{1,m},"sp","tg",LOCATION_MZONE,nil,nil,rstg.target2(cm.fun,cm.mvfilter,nil,LOCATION_MZONE),cm.mvop)
	local e2=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"se,th","de",LOCATION_MZONE,nil,nil,cm.thtg,cm.thop)
end
function cm.cfilter(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:IsSetCard(0x337)
end
function cm.thfilter(c,g)
	return c:IsAbleToHand() and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local g=eg:Filter(cm.cfilter,nil,lg)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,g) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	rsof.SelectHint(tp,"th")
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,g)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.lfilter(c)
	return c:IsLinkRace(RACE_DRAGON) and c:IsAttackAbove(2000)
end
function cm.gf(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x337)
end
function cm.mvfilter(c,e,tp)
	local seq=c:GetSequence()
	return seq<=4 and ((Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) and seq>1) or (Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) and seq<4))
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function cm.mvop(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard()
	if not c or not c:IsControler(tp) or not tc or tc:GetSequence()>4 or not tc:IsControler(tp) then return false end
	local flag=0
	local seq=tc:GetSequence()
	if Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) and seq>0 then
		flag=bit.replace(flag,0x1,seq-1)
	end
	if Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) and seq<4 then
		flag=bit.replace(flag,0x1,seq+1)
	end
	flag=bit.bxor(flag,0xff)
	if flag<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	local linkzone=c:GetLinkedZone(tp)
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp,linkzone)
	if linkzone>0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		rsof.SelectHint(tp,"sp")
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,linkzone)
	end
end
function cm.spfilter(c,e,tp,zone)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end