--不朽之死堡垒
if not pcall(function() require("expansions/script/c30099990") end) then require("script/c30099990") end
local m,cm=rscf.DefineCard(30000315)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	e1:SetCondition(cm.con)
	local e2=rsef.I(c,{m,0},1,"sp",nil,LOCATION_SZONE,cm.con,rscost.reglabel(100),cm.sptg,cm.spop)
	local e3=rsef.RegisterOPTurn(c,e2,cm.qcon)
	local e4=rsef.I(c,{m,1},{99,m},nil,nil,LOCATION_GRAVE,cm.con,rscost.cost(cm.tdfilter,"td",LOCATION_REMOVED,LOCATION_REMOVED),rsop.target(Card.IsSSetable,nil),cm.setop)
end
function cm.con(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,rsloc.mg,rsloc.mg,nil,TYPE_MONSTER)
	return #g>0 and g:FilterCount(cm.cfilter,nil)==#g
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function cm.rmfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function cm.spfilter(c,e,tp)
	return rscf.spfilter2(Card.IsRace,RACE_ZOMBIE)(c,e,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()==100 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		rsop.SelectRemove(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,{POS_FACEUP,REASON_COST },e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end
function cm.qcon(e,tp)
	return not e:GetHandler():IsDisabled() and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,3,nil,30000300)
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToDeckAsCost()
end 
function cm.setop(e,tp)
	local c=rscf.GetSelf(e)
	if c then Duel.SSet(tp,c) end
end