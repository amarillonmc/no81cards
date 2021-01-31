--机械兽 侦查巴萨库
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000074)
function cm.initial_effect(c)   
	aux.AddCodeList(c,25000073)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(cm.tgfilter,"tg",LOCATION_DECK),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.FV_LIMIT_PLAYER(c,"sp",nil,aux.TargetBoolFunction(Card.IsLocation,LOCATION_EXTRA),{0,1},cm.limitcon)
	local e3=rsef.STO(c,EVENT_TO_GRAVE,{m,1},{1,m+100},nil,"de,dsp",cm.lkcon,nil,nil,cm.lkop)
end
function cm.tgfilter(c)
	return (c:IsCode(m-1) or (aux.IsCodeListed(c,m-1) and c:IsType(TYPE_SPELL+TYPE_TRAP))) and c:IsAbleToGraveAsCost()
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.cfilter(c)
	return c:GetSummonLocation() & LOCATION_EXTRA ~=0
end
function cm.limitcon(e)
	return not Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function cm.lkcon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.setfilter(c)
	return not c:IsOnField() or c:IsFacedown()
end
function cm.lkop(e,tp)
	local g=Duel.GetMatchingGroup(cm.setfilter,tp,0,LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_DECK,nil)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleDeck(1-tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(0,LOCATION_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end 