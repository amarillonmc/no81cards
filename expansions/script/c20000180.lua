--圣沌忍者 曼怛罗
dofile("expansions/script/c20000175.lua")
local cm,m = fu_HC.M_initial()
--e1
function cm.e1(c)
	fuef.QO(c):CAT("SP"):RAN("HG"):CTL(m):Func("cos1,M_SP_tg1,op1")
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"MS","IsTyp+AbleTo","T,*G",1) end
	local tc = fugf.SelectFilter(tp,"MS","IsTyp+AbleTo","T,*G"):GetFirst()
	if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	Duel.SendtoGrave(tc,REASON_COST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g = fugf.GetFilter(tp,"D","IsCod/(HasCode+IsTyp)+IsSSetable","175,175,T")
	if #g==0 or not Duel.SelectYesNo(tp,1153) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	Duel.SSet(tp,g:Select(tp,1,1,nil))
end