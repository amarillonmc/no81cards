--创导龙裔的秘仪
dofile("expansions/script/c20000450.lua")
local cm, m = fusf.Initial(fu_GD)
--e1
cm.e1 = fuef.A():Cat("REL+RE+SP"):Func("tg1,op1")
local e1g1 = fugf.MakeFilter("HG", "IsTyp+IsRac+CanSp+AbleTo", "RI+M,DR,%1,*R")
local e1g2 = fugf.MakeFilter("H", "IsTyp+IsPublic", "M")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e1g1(tp, {e,"RI"}) > 0 and #e1g2(tp) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg = fugf.Select(tp, e1g1(tp, {e,"RI"}), "GChk")
	if Duel.Remove(rg, POS_FACEUP, REASON_EFFECT) == 0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg = fugf.Select(tp, e1g2(tp))
	if #sg == 0 then return end
	Duel.ConfirmCards(1 - tp, sg)
	local fid = rg:GetFirst():GetFieldID()
	fusf.RegFlag(rg + sg, m, "STD", "HINT", 1, fid)
	fuef.FC(e, "ADJ", tp):Func("op1con1,op1op1"):Lab(fid)
end
function cm.op1con1(e,tp,eg,ep,ev,re,r,rp)
	local fid = e:GetLabel()
	local rc = fugf.GetFilter(tp, "R", "IsFlagLab", {m, fid}):GetFirst()
	local sc = fugf.GetFilter(tp, "H", "IsFlagLab", {m, fid}):GetFirst()
	if not (rc and sc) then
		e:Reset()
		return false
	end
	return sc:IsCanBeRitualMaterial(rc) and sc:IsLevelAbove(rc:GetLevel())
		and (sc.mat_filter or aux.TRUE)(rc)
end
function cm.op1op1(e,tp,eg,ep,ev,re,r,rp)
	local fid = e:GetLabel()
	local rc = fugf.GetFilter(tp, "R", "IsFlagLab", {m, fid}):GetFirst()
	local sg = fugf.GetFilter(tp, "H", "IsFlagLab", {m, fid})
	if not rc or #sg ~= 1 then return end
	Duel.Hint(HINT_CARD, tp, m)
	fu_GD.Hint(tp, m, sg, rc)
	rc:SetMaterial(sg)
	Duel.ReleaseRitualMaterial(sg)
	Duel.SpecialSummon(rc, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP)
	rc:CompleteProcedure()
	e:Reset()
end
--e2
cm.e2 = fuef.FTO("LEA"):Cat("TD+DR+GA"):Pro("DE"):Ran("G"):Ctl(m):Func("DRM_leave_con,tg2,op2")
local e2g1 = fugf.MakeFilter("D", "IsTyp", "RI+S")
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp, 1) and e:GetHandler():IsAbleToDeck() and #e2g1(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local max = fu_GD.GetReCount(tp) - 1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g = fugf.Select(tp, "G", "AbleTo+Not+GChk", "D,%1", 1, max, e) + e:GetHandler()
	if Duel.SendtoDeck(g, nil, 2, REASON_EFFECT) == 0 then return end
	if not fu_GD.SetTop(e, tp, e2g1(tp)) then return end
	fu_GD.DrawReturn(tp, 1)
end