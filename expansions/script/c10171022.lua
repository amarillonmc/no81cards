--分担诅咒的薪王
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171022)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,cm.sumval)
	aux.AddFusionProcCodeFun(c,10171002,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa335),1,false,false)
	local e1=aux.AddContactFusionProcedure(c,cm.resfilter,LOCATION_ONFIELD,0,Duel.Release,REASON_COST+REASON_MATERIAL+REASON_FUSION)
	e1:SetValue(SUMMON_VALUE_SELF)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"se,th","de,dsp",cm.thcon,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,1},1,"atk,des",nil,LOCATION_MZONE,nil,nil,cm.atktg,cm.atkop)
end
function cm.resfilter(c)
	return c:IsReleasable() and (c:IsFusionCode(10171002) or c:IsFusionSetCard(0xa335) and c:IsType(TYPE_MONSTER))
end
function cm.sumval(e,se)
	return se and se:GetHandler():IsCode(m+1)
end
function cm.thcon(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function cm.thfilter(c)
	return c:IsCode(m+1) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD)
end
function cm.eqfilter(c)
	return c:IsCode(m+1) and c:IsFaceup()
end
function cm.atkop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local e1,e2=rscf.QuickBuff(c,"atk+,def+",500)
	if not c:IsImmuneToEffect(e1) and c:GetEquipGroup():FilterCount(cm.eqfilter,nil)>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		rsop.SelectDestroy(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil,{})
	end
end