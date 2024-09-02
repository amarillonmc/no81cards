--圣沌大忍者 波罗羯谛
dofile("expansions/script/c20000175.lua")
local cm,m = fu_HC.M_initial()
--e1
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g = fugf.GetFilter(tp,"+M","IsPos","D")
	if #g>0 and Duel.SelectYesNo(tp,1111) then
		Duel.BreakEffect()
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
	fuef.F(e,EFFECT_MUST_ATTACK,tp):TRAN("+M"):RES("PH/ED")
end