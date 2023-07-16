--圣沌忍者 曼怛罗
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000175") end) then require("script/c20000175") end
function cm.initial_effect(c)
	fu_HC.glo(c)
	local e1=fuef.FTO(c,c,"SP,SP",EVENT_CHAINING,"DE,H",m,cm.con1,"",cm.tg1,cm.op1)
	local e2=fuef.F(c,c,"",m,"PTG,M,1+0")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and fucf.CanSp(e:GetHandler(),e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and fugf.GetFilter(tp,"D","IsCod/(IsSet+IsTyp+%)+IsSSetable",{fu_HC.IsAct,"20000175,5fd1,S/T"},1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=fugf.SelectFilter(tp,"D","IsCod/(IsSet+IsTyp+%)+IsSSetable",{fu_HC.IsAct,"20000175,5fd1,S/T"})
	if #g==0 then return end
	Duel.SSet(tp,g)
end