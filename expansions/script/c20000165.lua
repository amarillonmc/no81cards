--虚构素体 D001
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=fuef.SC(c,nil,EVENT_BE_MATERIAL,EFFECT_FLAG_EVENT_PLAYER,nil,fu_cim.BM_con,fu_cim.BM_op,c)
	local e2=fuef.I(c,"SP","SP",nil,"G",m,nil,cm.cos2,cm.tg2,cm.op2,c)
end
--Add
function cm.Add(c,rc)
	local e1=fuef.I(c,0,"SP","HINT","M",1,nil,fu_cim.RemoveXyz,cm.Add_tg1,cm.Add_op1,{rc,1},RESET_EVENT+RESETS_STANDARD)
end
function cm.Add_tgf1(c,e,tp)
	return c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.Add_tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():IsRankAbove(4) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and fugf.GetFilter(tp,"HG",cm.Add_tgf1,{e,tp},nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.Add_op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsRankAbove(4) then return end
	local e1=fuef.S(c,nil,EFFECT_UPDATE_RANK,nil,nil,-3,nil,nil,nil,c,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=fugf.SelectFilter(tp,"HG",cm.Add_tgf1,{e,tp},nil,1)
	if #g==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--e2
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=fugf.GetFilter(tp,"E",{Card.IsSetCard,Card.IsType,Card.IsAbleToGraveAsCost},{0xcfd1,TYPE_XYZ})
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	g=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
