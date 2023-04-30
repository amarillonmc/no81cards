--虚构素体 A001
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=fuef.SC(c,nil,EVENT_BE_MATERIAL,EFFECT_FLAG_EVENT_PLAYER,nil,fu_cim.BM_con,fu_cim.BM_op,c)
	local e2=fuef.QO(c,"SP","SP",nil,"TG","M",m,nil,nil,cm.tg2,cm.op2,c)
end
--Add
function cm.Add(c,rc)
	local e1=fuef.I(c,0,"TG","HINT","M",1,nil,fu_cim.RemoveXyz,cm.Add_tg1,cm.Add_op1,{rc,1},RESET_EVENT+RESETS_STANDARD)
end
function cm.Add_tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"E",Card.IsAbleToGrave,nil,nil,1) and e:GetHandler():IsRankAbove(4) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.Add_op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsRankAbove(4) then return end
	local e1=fuef.S(c,nil,EFFECT_UPDATE_RANK,nil,nil,-3,nil,nil,nil,c,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=fugf.SelectFilter(tp,"E",Card.IsAbleToGrave,nil,nil,1):GetFirst()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
--e2
function cm.tgf2(c,e,tp,mc)
	local g=Group.FromCards(c,mc)
	return c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_XMATERIAL)
		and fugf.GetFilter(tp,"E",{Card.IsSetCard,Card.IsXyzSummonable},{0xcfd1,g},nil,1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tgf2(chkc,e,tp,c) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and fugf.GetFilter(tp,"G",{Card.IsCanBeEffectTarget,cm.tgf2},{e,{e,tp,c}},nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=fugf.SelectTg(tp,"G",{Card.IsCanBeEffectTarget,cm.tgf2},{e,{e,tp,c}},nil,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_EXTRA)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and e:GetHandler():IsRelateToEffect(e)) then return end
	Duel.AdjustAll()
	local g=Group.FromCards(e:GetHandler(),tc)
	if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	tc=fugf.SelectFilter(tp,"E",{Card.IsSetCard,Card.IsXyzSummonable},{0xcfd1,g},nil,1):GetFirst()
	if not tc then return end
	Duel.XyzSummon(tp,tc,g)
end