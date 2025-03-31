--狱影军-天业云
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130001243)
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.FC(c,EVENT_TO_DECK,nil,nil,"de",LOCATION_PZONE,cm.tgcon1,cm.tgop1)
	local e2=rsef.FC(c,EVENT_TO_DECK,nil,nil,nil,LOCATION_PZONE,cm.regcon,cm.regop)
	local e3=rsef.FC(c,EVENT_CHAIN_SOLVED,nil,nil,nil,LOCATION_PZONE,cm.tgcon2,cm.tgop2)
	local e4=rsef.QO(c,nil,{m,1},{1,m},nil,nil,LOCATION_HAND,nil,cm.tecost,rsop.target(cm.tffilter,nil,LOCATION_DECK),cm.tfop)
	local e5=rsef.QO(c,EVENT_CHAINING,{m,2},{1,m+100},"neg,sp","dsp,dcal",LOCATION_REMOVED,rscon.negcon(cm.negfilter),nil,cm.negtg,cm.negop)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)
end
function cm.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and (not re or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		rsgf.SelectToGrave(g,tp,aux.TRUE,1,1,nil,{})
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
		and re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,m)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		rsgf.SelectToGrave(g,tp,aux.TRUE,1,n,nil,{})
	end  
	Duel.ResetFlagEffect(tp,m)
end
function cm.tecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_PENDULUM) end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function cm.tffilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and (c:IsSetCard(0x853) or (c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WARRIOR)))
end
function cm.tfop(e,tp)
	rsop.SelectSolve(HINTMSG_TOFIELD,tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,cm.tffun,tp)
end
function cm.tffun(g,tp)
	Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	return true
end
function cm.negfilter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.negfilter(e,tp,re,rp,tg)
	return rp~=tp and tg and tg:IsExists(cm.negfilter2,1,nil,tp)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if Duel.NegateActivation(ev) and c then
		rssf.SpecialSummon(c)
	end
end