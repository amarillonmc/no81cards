--龙血师团-†龙血铁气†-
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009481)
function cm.initial_effect(c)
	local e1 = rsef.ACT(c,nil,nil,nil,"se,th,sum",nil,cm.con,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	local e2 = rsef.I(c,"rec",nil,"rec","tg",LOCATION_GRAVE,nil,aux.bfgcost,rstg.target2(cm.fun,cm.cfilter,nil,LOCATION_MZONE),cm.recop)
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.thfilter(c)
	return c:IsSetCard(0x3f1b) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.act(e,tp)
	local c = e:GetHandler()
	local ct,og,tc = rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if not tc or not tc:IsLocation(LOCATION_HAND) or tc:IsLevelBelow(4) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.ntcon)
	e1:SetOperation(cm.ntop)
	e1:SetReset(rsreset.est_pend)
	e1:SetValue(SUMMON_TYPE_NORMAL)
	tc:RegisterEffect(e1,true)
	if tc:IsSummonable(true,e1) and rsop.SelectYesNo(tp,{m,0}) then
		Duel.BreakEffect()
		Duel.Summon(tp,tc,true,e1)
	end
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.CheckTribute(c,0)
end
function cm.ntop(e)
	e:Reset()
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f1b) and c:IsAttackAbove(1)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function cm.recop(e,tp)
	local tc = rscf.GetTargetCard(Card.IsFaceup)
	if not tc or tc:IsAttackBelow(0) then return end
	Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
end