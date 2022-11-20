--二元王牌-万丈目闪电
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150090)
function cm.initial_effect(c)
	aux.AddCodeList(c,47297616)
	local e1=rsef.ACT(c,nil,nil,nil,"atk,def","dsp,tg",aux.dscon,nil,rstg.target2(cm.fun,rscf.fufilter(Card.IsAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK),nil,LOCATION_MZONE),cm.atkop)
	local e2=rsef.STO(c,EVENT_DESTROYED,{m,0},{1,m},"th,sp","tg",cm.thcon,nil,rstg.target2(cm.fun2,cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
end
function cm.fun(g,e,tp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.atkop(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if tc then
		local e1,e2=rscf.QuickBuff({c,tc},"atk+,def+",1000)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.thcon(e,tp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.fun2(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,LOCATION_GRAVE)
end
function cm.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsCode(47297616) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
	end
end
