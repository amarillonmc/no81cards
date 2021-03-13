--圣书的履行者 
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006002)
function cm.initial_effect(c)
	local e1 = rsef.ACT(c,nil,nil,{1,m,1},"th","tg",nil,nil,rstg.target(cm.thfilter,"th",LOCATION_MZONE,LOCATION_MZONE),cm.act)
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function cm.act(e,tp)
	local tc = rscf.GetTargetCard()
	if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT) <= 0 or not tc:IsLocation(LOCATION_HAND) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,tc:GetCode()))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end