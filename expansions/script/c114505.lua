--里械仪者·炎斩
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114505)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.I(c,"sp",{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(cm.cfilter,"cf",LOCATION_HAND,0,2,2,c),rsop.target(cm.spfilter,"sp"),cm.spop)
	local e2 = rsef.QO(c,nil,"eq",{1,m+100},"pos,eq",nil,LOCATION_MZONE,nil,nil,rsop.target({Card.IsCanTurnSet,"pos"},{cm.eqfilter,"eq",LOCATION_ONFIELD,LOCATION_ONFIELD }),cm.eqop)
	local e3 = rsef.QO(c,EVENT_CHAINING,"pos",{1,m+200},"atk","sa",LOCATION_MZONE,nil,rscost.cost(cm.tfilter,{"pos",cm.fun}),nil,cm.atkop)
end
function cm.tfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.fun(g,e,tp)
	local pos = Duel.SelectPosition(tp,g:GetFirst(),POS_FACEUP)
	Duel.ChangePosition(g,pos)
end
function cm.atkop(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	if not c then return end
	local e1 = rscf.QuickBuff(c,"atk+",1000)
end
function cm.cfilter(c)
	return c:IsType(TYPE_FLIP) and not c:IsPublic()
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local c = rscf.GetSelf(e)
	if c and Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) > 0 then
		c:SetMaterial(Group.FromCards())
		c:CompleteProcedure()
	end
end
function cm.eqfilter2(c,ec)
	return c:IsFaceup() and not c:GetEquipGroup():IsContains(ec)
end
function cm.eqfilter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.eqfilter2,tp,LOCATION_MZONE,0,1,Group.FromCards(c,e:GetHandler()),c)
end
function cm.eqop(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	if not c or Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE) <= 0 then return end
	local ec = rsop.SelectSolve(HINTMSG_EQUIP,tp,cm.eqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{},e,tp):GetFirst()
	if not ec then return end
	local tc = rsop.SelectSolve(HINTMSG_SELF,tp,cm.eqfilter2,tp,LOCATION_MZONE,0,1,1,ec,{},ec):GetFirst()
	if rsop.Equip(e,ec,tc) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
	end
end