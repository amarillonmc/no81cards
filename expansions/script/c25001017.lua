--自然控制机器 炎山
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001017)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(Card.IsAbleToDeckAsCost,"td",LOCATION_GRAVE,LOCATION_GRAVE,1,3),cm.sptg,cm.spop)
	local e3=rsef.QO(c,nil,{m,1},1,"tg",nil,LOCATION_MZONE,cm.tgcon,nil,rsop.target(Card.IsAbleToGrave,"tg",0,LOCATION_ONFIELD),cm.tgop)
	local e4=rsef.STO(c,EVENT_LEAVE_FIELD,{m,2},{1,m+100},nil,"de",cm.plcon,nil,nil,cm.plop)
	local e5=rsef.STO(c,EVENT_LEAVE_FIELD,{m,3},{1,m+200},"se,th","de",cm.thcon,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.thfilter(c)
	return c:IsCode(m+1,m-1) and c:IsAbleToHand()
end 
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.plcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function cm.thcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function cm.plop(e,tp)
	local c=rscf.GetSelf(e)
	if c then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil,{})
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x1021,1500,1500,3,RACE_MACHINE,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x1021,1500,1500,3,RACE_MACHINE,ATTRIBUTE_FIRE) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL+TYPE_TUNER)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_ATTACK)
end