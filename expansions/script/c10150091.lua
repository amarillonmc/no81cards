--二元栗子
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150091)
function cm.initial_effect(c)
	local e1=rsef.SV_ADD(c,"att",ATTRIBUTE_LIGHT)
	e1:SetRange(LOCATION_MZONE)
	local e2=rsef.SV_INDESTRUCTABLE(c,"ct")
	e2:SetCountLimit(2)
	local e3=rsef.FTO(c,EVENT_BATTLE_CONFIRM,{m,0},nil,"sp,des,rm",nil,LOCATION_HAND,nil,nil,cm.sptg,cm.spop)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if bc and bc:IsControler(tp) then
		ac,bc=bc,ac
	end
	if chk==0 then return ac and bc and ac:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and bc:IsAbleToRemove() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	e:SetLabelObject(ac)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ac,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,0,0,0)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)   
	if not c or rssf.SpecialSummon(c)<=0 then return end
	local ac=e:GetLabelObject()
	local bc=ac:GetBattleTarget()
	if ac:IsRelateToBattle() and Duel.Destroy(ac,REASON_EFFECT)>0 and bc:IsRelateToBattle() then
		Duel.BreakEffect()
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end