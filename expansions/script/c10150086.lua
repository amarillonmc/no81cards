--光与暗的降生
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150086)
function cm.initial_effect(c)
	aux.AddCodeList(c,47297616)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"se,th",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(m)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	local e3=rsef.I(c,{m,0},1,"sum",nil,LOCATION_SZONE,nil,nil,rsop.target(cm.sumfilter,"sum",LOCATION_HAND),cm.sumop)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetCondition(cm.otcon)
	e4:SetTarget(cm.ottg)
	e4:SetOperation(cm.otop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
	e3:SetLabelObject(e4)
	e4:SetLabelObject(e5)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(47297616)
end
function cm.act(e,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.sumfilter(c,e,tp)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function cm.sumop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	rshint.Select(tp,"sum")
	local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
	cm.switchcheck=false
end
function cm.rmfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost() and (c:IsControler(tp) or c:IsHasEffect(m)) and c:IsLevelAbove(5)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,rsloc.mg,rsloc.mg,nil,tp)
	return minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK)
end
function cm.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2 and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,rsloc.mg,rsloc.mg,nil,tp)
	rshint.Select(tp,"rm")
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK)
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_SUMMON+REASON_COST+REASON_MATERIAL)
end