--虚构素体 C001
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=fuef.SC(c,nil,EVENT_BE_MATERIAL,EFFECT_FLAG_EVENT_PLAYER,nil,fu_cim.BM_con,fu_cim.BM_op,c)
	local e2=fuef.FTO(c,"SP","SP",EVENT_SPSUMMON_SUCCESS,"DE","HG",m,cm.con2,nil,cm.tg2,cm.op2,c)
end
--Add
function cm.Add(c,rc)
	local e1=fuef.I(c,0,CATEGORY_DRAW,"HINT","M",1,nil,fu_cim.RemoveXyz,cm.Add_tg1,cm.Add_op1,{rc,1},RESET_EVENT+RESETS_STANDARD)
end
function cm.Add_tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsPlayerCanDraw(tp,1) and c:IsRankAbove(4) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.Add_op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsRankAbove(4) then return end
	local e1=fuef.S(c,nil,EFFECT_UPDATE_RANK,nil,nil,-3,nil,nil,nil,c,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return fugf.Filter(eg,{Card.IsControler,Card.IsType,Card.IsFaceup},{tp,TYPE_XYZ},nil,1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.opf2(c)
	return c:IsXyzSummonable(nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0) then return end
	local g=fugf.Get(tp,"E"):Filter(Card.IsXyzSummonable,nil,nil)
	if not (#g>0 and Duel.SelectYesNo(tp,1165)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.BreakEffect()
	g=g:Select(tp,1,1,nil)
	Duel.XyzSummon(tp,g:GetFirst(),nil)
end