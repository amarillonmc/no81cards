--圣沌大忍者 空即是色
dofile("expansions/script/c20000175.lua")
local cm,m = fu_HC.M_initial()
--e1
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g = fugf.GetFilter(tp,"HG","IsSet+CanSp+GChk",{"5fd1",{e,0,tp}})
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not Duel.SelectYesNo(tp,1152) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end