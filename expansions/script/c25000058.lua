--音击龙 舞甲响鬼
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000058)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR+RACE_ZOMBIE),1,1,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE))
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	local e2=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m},"neg,pos","dsp,dcal",LOCATION_MZONE,rscon.negcon(2,true),nil,rstg.negtg("nil"),cm.negop)
	local e3=rsef.STO(c,EVENT_PRE_DAMAGE_CALCULATE,{m,2},{1,m+100},"rm,dis",nil,cm.rmcon,nil,cm.rmtg,cm.rmop)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and rc:IsType(TYPE_MONSTER) and rc:IsCanChangePosition() and not rc:IsPosition(POS_FACEUP_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.ChangePosition(rc,POS_FACEUP_DEFENSE)
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	local bc=e:GetHandler():GetBattleTarget()
	return bc~=nil and (bc:IsDefenseAbove(atk) or bc:IsAttackAbove(atk))
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsAbleToRemove() and aux.disfilter1(bc) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function cm.rmop(e,tp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		local e1,e2=rscf.QuickBuff({e:GetHandler(),bc},"dis,dise")
		Duel.NegateRelatedChain(bc,RESET_TURN_SET)
		if not bc:IsImmuneToEffect(e1) then
			Duel.BreakEffect()
			Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
		end
	end
end