--创导龙裔·觉醒者
dofile("expansions/script/c20000000.lua")
fu_GD = fu_GD or { }
-------------------
function fu_GD.NInitial(cat, loc, f, v)
	local cm, m = fusf.Initial(fu_GD)
	cat = table.concat({"TD+DR", cat}, "+")
	local pgf = fugf.MakeFilter(loc, f, v)
	local insert = function(c)
		cm.public = fuef.I(c):Cat(cat):Ran("H"):Ctl(m):Func("Pcos,Ptg(%1),Pop(%1)", pgf)
	end
	fusf.InsertInitial(insert)
	cm.pe1 = fuef.FC("DR"):Ran("H"):Func("SelfDraw_con,NPop1")
	return cm, m
end
function fu_GD.RInitial(glo)
	local cm, m = fusf.Initial(fu_GD, glo)
	fusf.AddCode(455)
	fusf.ReviveLimit()
	cm.pe1 = fuef.F(m):Pro("PTG"):Ran("M"):Tran(1, 0):Con("RPcon1")
	cm.pe2 = fuef.SC("SP"):Func("RPcon1,RPop2")
	return cm, m
end
-------------------
-- 龙族仪式怪兽从场上离开的场合
function fu_GD.DRM_leave_con(e,tp,eg,ep,ev,re,r,rp)
	return fugf.Filter(eg,"IsTyp+IsRac+IsPLoc","RI+M,DR,M",1)
end
local rm_g = fugf.MakeFilter("M", "IsTyp", "RI+M")
-- 获取回卡组的最大数量
function fu_GD.GetReCount(tp)
	if not Duel.IsPlayerAffectedByEffect(tp, 20000457) then return 2 end
	return math.max(2, #rm_g(tp) + 1)
end
-- 获取置顶的最大数量
function fu_GD.GetSetCount(tp)
	if not Duel.IsPlayerAffectedByEffect(tp, 20000458) then return 1 end
	return #rm_g(tp) + 1
end
-- 召唤词
function fu_GD.Hint(tp, m, mg, rc)
	if not rc:IsSetCard(0x3fd4) then return end
	mg = fugf.Filter(mg, "IsSet", "bfd4")
	if #mg ~= 1 then return end
	local mcode = mg:GetFirst():GetCode()
	Duel.Hint(24, tp, aux.Stringid(mcode, 0))
	Duel.Hint(24, tp, aux.Stringid(m, 0))
end
-------------------
local return_g = fugf.MakeFilter("H", "AbleTo+Not", "D,%1")
function fu_GD.ReDraw_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and #return_g(tp, e) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
-- 这张卡以外的自己手卡最多2张回到卡组洗切
function fu_GD.ToDeck(e, tp)
	local max = fu_GD.GetReCount(tp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = fugf.Select(tp, return_g(tp, e), 1, max)
	if #g > 2 then Duel.Hint(HINT_CARD, 1 - tp, 20000457) end
	return Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
end
-- 在卡组最上面放置
function fu_GD.SetTop(e, tp, g)
	local max = fu_GD.GetSetCount(tp)
	Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(20000450, 1))
	g = fugf.Select(tp, g, "GChk", nil, 1, max)
	if #g == 0 then return false end
	local gg = fugf.Filter(g, "IsLoc", "G")
	if #gg > 0 then Duel.SendtoDeck(gg, nil, 0, REASON_EFFECT) end
	Duel.ShuffleDeck(tp) 
	for c in aux.Next(g) do
		Duel.MoveSequence(c, SEQ_DECKTOP)
	end
	if #g > 1 then
		Duel.Hint(HINT_CARD, 1 - tp, 20000458)
		Duel.SortDecktop(tp, tp, #g)
	end
	Duel.ConfirmDecktop(tp, #g)
	return true
end
-- 那之后，自己抽出回去的数量
function fu_GD.DrawReturn(tp, ct)
	if Duel.IsPlayerAffectedByEffect(tp, 20000459) and Duel.SelectYesNo(tp, aux.Stringid(20000459, 2)) then 
		Duel.Hint(HINT_CARD, 1 - tp, 20000459)
		ct = ct + 1 
	end
	Duel.BreakEffect()
	Duel.Draw(tp, ct, REASON_EFFECT)
end
------------------- public
function fu_GD.Pcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	fuef.S(e,EFFECT_PUBLIC):Des("PUB"):Pro("HINT"):Res("STD+ED+OPPO")
end
function fu_GD.Ptg(gf)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return fu_GD.ReDraw_tg(e,tp,eg,ep,ev,re,r,rp,chk) and #gf(tp, eg) > 0 end
		fu_GD.ReDraw_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function fu_GD.Pop(gf)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local ct = fu_GD.ToDeck(e, tp)
		if ct == 0 then return end
		if not fu_GD.SetTop(e, tp, gf(tp, eg)) then return end
		fu_GD.DrawReturn(tp, ct)
	end
end
-------------------
function fu_GD.SelfDraw_con(e,tp,eg,ep,ev,re,r,rp)
	return not fusf.IsPhase("DP") and rp == tp
end
function fu_GD.NPop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsPublic() then return end
	local e1 = fuef.S(e,EFFECT_UPDATE_LEVEL):Val(ev)
	fuef.FC(e,"ADJ",tp):Op("NPop1op1"):Obj(e1.e)
end
function fu_GD.NPop1op1(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetLabelObject():GetHandler()
	if fucf.Filter(c, "~(IsLoc+IsPublic)", "H") then 
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
-------------------
function fu_GD.RPcon1(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function fu_GD.RPop2(e,tp)
	local m = e:GetHandler():GetCode()
	Duel.Hint(24, tp, aux.Stringid(m, 0))
	Duel.Hint(24, tp, aux.Stringid(m, 1))
end
if self_code ~= 20000450 then return end
-----------------------------------------------------------------------------------
fu_GD.NInitial("GA", "DG", "IsTyp+IsRac+IsLoc/AbleTo", "RI+M,DR,D,D")