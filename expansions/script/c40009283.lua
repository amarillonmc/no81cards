--机械加工 星火独角仙
if not pcall(function() dofile("expansions/script/c40008000") end) then dofile("script/c40008000") end
local m,cm=rscf.DefineCard(40009283)
local m=40009283
local cm=_G["c"..m]
cm.named_with_Machining=1
function cm.Machining(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Machining
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2,2)
	local e1=rsef.STF(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,nil,nil,rscon.sumtype("link"),nil,nil,cm.sumop)
	local e2=rsef.I(c,"sp",{1,m},"sp,pos","tg",LOCATION_MZONE,nil,nil,rstg.target({ cm.posfilter,"pos",LOCATION_MZONE },{"opc",cm.spfilter,"sp",LOCATION_DECK }),cm.spop)
end
function cm.posfilter(c)
	return c:IsCanChangePosition() and not c:IsPosition(POS_FACEUP_DEFENSE)
end
function cm.spfilter(c,e,tp)
	return cm.Machining(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or tc:IsPosition(POS_FACEUP_DEFENSE) or Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)<=0 then return end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.sumop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
