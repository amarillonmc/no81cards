--忍瞬之圣沌 千手
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.T_initial()
--e1
cm.e1 = fuef.A():CAT("SP"):Func("tg1,op1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b = fu_HC.chk[tp+1]>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return fugf.GetFilter(tp,"D","IsCode/IsSet+(IsTyp+IsSSetable)/(CanSp+%1)","175,5fd1,S/T,,(%2,0)",1,b,e) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local b = fu_HC.chk[tp+1]>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local g = fugf.Select(tp,"D","IsCode/IsSet+(IsTyp+IsSSetable)/(CanSp+%1)","175,5fd1,S/T,,(%2,0)",1,1,b,e)
	if #g==0 then return end
	local oper = fucf.IsTyp(g:GetFirst(),"S/T") and {"SSet",{tp,g}} or {"SpecialSummon",{g,0,tp,tp,false,false,POS_FACEUP}}
	Duel[oper[1] ](table.unpack(oper[2]))
end