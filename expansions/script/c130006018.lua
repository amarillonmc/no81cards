--反转世界的幻灵 阿露比
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006018,"FanZhuanShiJie")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PSYCHO),2)
	local e2 = rsef.I(c,"th",1,"se,th",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3 = rsef.QO(c,nil,"sp",nil,"sp","tg",LOCATION_MZONE,nil,rscost.cost(cm.rfilter,"res"),rstg.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1) 
end
function cm.rfilter(c,e,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return not c:IsCode(m) and rsfz.IsSet(c) and rscf.spfilter()(c,e,tp)
end
function cm.spop(e,tp)
	local tc = rscf.GetTargetCard()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.thfilter(c)
	return rsfz.IsSetST(c) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and sumtype & SUMMON_TYPE_LINK == SUMMON_TYPE_LINK
end