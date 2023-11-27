--「星光歌剧」台本-舞台少女心得
if not pcall(function() require("expansions/script/c64839999") end) then require("script/c64839999") end
local m,cm=rscf.DefineCard(64832037)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.I(c,{m,0},{1,m},nil,nil,LOCATION_SZONE,nil,rscost.cost(cm.tgfilter,"tg",rsloc.hd),nil,cm.limitop)
	local e3=rsef.FV_INDESTRUCTABLE(c,"ct",nil,aux.TargetBoolFunction(Card.IsSummonType,SUMMON_TYPE_ADVANCE),{LOCATION_MZONE,0},nil,nil,"sa")
	local e4=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,1},{1,m+1},nil,"tg",LOCATION_SZONE,nil,nil,rstg.target(cm.setfilter,nil,LOCATION_GRAVE),cm.setop)
end
function cm.setfilter(c)
	return c:IsSetCard(0x6410) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.setop(e,tp)
	local c=rscf.GetSelf(e)
	local tc=rscf.GetTargetCard()
	if not c or not tc or Duel.SSet(tp,tc)<=0 then return end   
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	tc:RegisterEffect(e1)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x6410) and c:IsAbleToGraveAsCost()
end
function cm.limitop(e,tp)
	if not rscf.GetSelf(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.sumsuc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if not eg:GetFirst():IsSummonType(SUMMON_TYPE_ADVANCE) then return end
	Duel.SetChainLimitTillChainEnd(cm.limit)
end
function cm.limit(e,ep,tp)
	return ep==tp
end