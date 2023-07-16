--忍瞬之圣沌 千手
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000175") end) then require("script/c20000175") end
function cm.initial_effect(c)
	fu_HC.glo(c)
	local e1 = fuef.B_A(c,c,",SP,,,,,",cm.tg1,cm.op1)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b = fu_HC.IsAct() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return fugf.GetFilter(tp,"D","IsCod/IsSet+(IsTyp+IsSSetable)/(CanSp+%)",{b,"20000175,5fd1,S/T,",{e,0,tp}},1) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local b = fu_HC.IsAct() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local g=fugf.SelectFilter(tp,"D","IsCod/IsSet+(IsTyp+IsSSetable)/(CanSp+%)",{b,"20000175,5fd1,S/T,",{e,0,tp}})
	if #g==0 then return end
	if fucf.IsTyp(g:GetFirst(),"S/T") then
		Duel.SSet(tp,g)
	else
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end