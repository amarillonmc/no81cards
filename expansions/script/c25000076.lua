--莫霍面地底文明 迪罗斯
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000076)
function cm.initial_effect(c)   
	aux.AddCodeList(c,25000073)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"se,th",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	local e2=rsef.QO(c,nil,{m,1},nil,nil,nil,LOCATILOCATION_SZONEON_MZONE,rscon.phmp,rscost.cost(cm.cfilter,"tg",LOCATION_ONFIELD),nil,cm.tfop)
	local e3=rsef.QO(c,nil,{m,2},nil,"sp",nil,LOCATION_SZONE,rscon.phmp,rscost.cost(cm.cfilter2,"tg",LOCATION_ONFIELD),nil,cm.spop)
	local e4=rsef.I(c,{m,3},1,"disd",nil,LOCATION_SZONE,nil,rscost.cost2(cm.regfun,Card.IsAbleToDeckOrExtraAsCost,"td",LOCATION_GRAVE,0,1,cm.ctfun),rsop.target(1,"disd",1,0),cm.disdop)
end
function cm.regfun(g,e)
	e:SetLabel(#g)
end
function cm.ctfun(e,tp)
	return math.min(8,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
end
function cm.disdop(e,tp)
	Duel.DiscardDeck(tp,e:GetLabel(),REASON_EFFECT)
end
function cm.cfilter2(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_SZONE,0,1,c,e,tp) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and c:GetOriginalType() & TYPE_MONSTER ~=0
end
function cm.spop(e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_SZONE,1,ft,nil,{ 0,tp,tp,true,false,POS_FACEUP },e,tp)
end
function cm.cfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_MZONE,0,1,c) and (c:IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.tffilter(c)
	return c:GetOriginalRace() & RACE_MACHINE ~=0 and c:IsFaceup()
end
function cm.tfop(e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local ct,og,tc=rsop.SelectMoveToField_Activate(tp,cm.tffilter,tp,LOCATION_MZONE,1,ft,nil,{ tp,tp,LOCATION_SZONE })
	for tc in aux.Next(og) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function cm.thfilter(c,e,tp)
	if not c:IsType(TYPE_TRAP) or not aux.IsCodeListed(c,25000073) then return false end
	return c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.act(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,cm.sfun,e,tp)
end
function cm.sfun(g,e,tp)
	local tc=g:GetFirst()
	local b1=tc:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local op=rsop.SelectOption(tp,b1,{m,0},b2,{m,1})
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	return true
end 