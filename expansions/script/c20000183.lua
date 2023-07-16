--圣沌忍法 后门
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000175") end) then require("script/c20000175") end
function cm.initial_effect(c)
	fu_HC.glo(c)
	local e1=fuef.A(c)
	local e2=fuef.FC(c,c,",CH,,F,,",cm.op2)
	local e3=fuef.FTO(c,c,",SP+GA,CH,DE,F,m",cm.con3,"",cm.tg3,cm.op3)

end
--e2
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not (re:GetHandler():GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and ep==tp) then return end
	Duel.SetChainLimit(function(e,rp,tp)return tp==rp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)end)
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(20000175)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"HG","(IsSet+%+CanSp)/(IsTyp+IsSSetable)",{Duel.GetLocationCount(tp,LOCATION_MZONE)>0,"5fd1,,%,T",{e,0,tp}},1) end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=fugf.SelectFilter(tp,"HG","(IsSet+%+CanSp)/(IsTyp+IsSSetable)+GChk",{Duel.GetLocationCount(tp,LOCATION_MZONE)>0,"5fd1,,%,T",{e,0,tp}})
	if #g==0 then return end
	if fucf.IsTyp(g:GetFirst(),"T") then
		Duel.SSet(tp,g)
	else
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end