--奇机械兽 戴亚博里古
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001007)
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m+100},"tg,dr",nil,LOCATION_HAND,nil,rscost.cost(Card.IsAbleToGrave,"tg"),rsop.target(Card.IsAbleToGrave,"tg",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.tgop)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,1},{1,m+200},"tg,rm","de,dsp",nil,nil,rsop.target2(cm.fun,cm.tgfilter,"tg",LOCATION_DECK),cm.tgop2)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON_SUCCESS)
	local e4=rsef.RegisterClone(c,e2,"code",EVENT_FLIP_SUMMON_SUCCESS)
	local e5=rsef.STO(c,EVENT_BE_MATERIAL,{m,2},{1,m+300},nil,"de,dsp",cm.lcon,nil,nil,cm.lop)
end
function cm.lcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r & REASON_LINK ~=0 and c:GetReasonCard():IsRace(RACE_MACHINE)
end
function cm.lop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,ep,tp)
	return tp==ep
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,1,tp,LOCATION_DECK)
end
function cm.tgfilter(c)
	return (c:IsAbleToGrave() or c:IsAbleToRemove()) and c:IsComplexType(TYPE_SPELL,true,TYPE_CONTINUOUS,TYPE_FIELD)
end
function cm.tgop2(e,tp)
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,cm.sfun,tp)
end
function cm.sfun(g,tp)
	local tc=g:GetFirst()
	local b1=tc:IsAbleToGrave()
	local b2=tc:IsAbleToRemove()
	local op=rsop.SelectOption(tp,b1,{m,0},b2,{m,1})
	if op==1 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	return true
end 
function cm.tgop(e,tp)
	local ct,og,tc=rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
	if tc and tc:GetPreviousControler()==tp and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
