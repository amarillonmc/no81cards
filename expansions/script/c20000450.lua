--创导龙裔·觉醒者
dofile("expansions/script/c20000000.lua")
fu_GD = fu_GD or { }
--
function fu_GD.SelfDraw_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and rp==tp
end
function fu_GD.DRM_leave_con(e,tp,eg,ep,ev,re,r,rp)
	return fugf.Filter(eg,"IsTyp+IsRac+IsPLoc","RI+M,DR,M",1)
end
function fu_GD.CanReturnDraw_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and fugf.GetFilter(tp,"H","AbleTo+Not",{"D",e},1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
--Normal initial
function fu_GD.N_initial(add_cat, f1_loc, f1_func, f1_val)
	local func = fugf.GetNoP(f1_loc, f1_func, f1_val)
	local pe = fuef.I():CAT("TD+DR"..(add_cat and "+"..add_cat or "")):RAN("H"):CTL("m"):Func("N_cos1,N_tg1(%1),N_op1(%1)", func)
	local cm, m = fuef.initial(fu_GD, _glo, "public_effect", pe)
	cm.pe1 = fuef.FC("DR"):RAN("H"):Func("SelfDraw_con,N_op2")
	return cm, m
end
function fu_GD.N_cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	fuef.S(e,EFFECT_PUBLIC):DES("PUB"):PRO("HINT"):RES("STD+PH/ED+OPPO")
end
function fu_GD.N_tg1(func)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return fu_GD.CanReturnDraw_tg(e,tp,eg,ep,ev,re,r,rp,chk) and #func(tp)>0 end
		fu_GD.CanReturnDraw_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function fu_GD.ReturnDeck(e, tp)
	-- 这张卡以外的自己手卡最多2张回到卡组洗切
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local max, maxn = 2, #fugf.GetFilter(tp, "M", "IsTyp", "RI+M") + 1
	if Duel.IsPlayerAffectedByEffect(tp, 20000457) and maxn > max then max = maxn end
	local g = fugf.Select(tp, "H", "AbleTo+Not", {"D", e}, 1, max)
	return Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
end
function fu_GD.SetDeckTop(e, tp, func)
	-- 在卡组最上面放置
	local max = Duel.IsPlayerAffectedByEffect(tp, 20000458) and (#fugf.GetFilter(tp, "M", "IsTyp", "RI+M") + 1) or 1
	Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(20000450, 1))
	local g = fugf.Select(tp, func(tp), "GChk", nil, 1, max)
	if #g == 0 then return false end
	local gg = fugf.Filter(g, "IsLoc", "G")
	if #gg > 0 then Duel.SendtoDeck(gg, nil, 0, REASON_EFFECT) end
	Duel.ShuffleDeck(tp) 
	for c in aux.Next(g) do
		Duel.MoveSequence(c, SEQ_DECKTOP)
	end
	if #g > 1 then Duel.SortDecktop(tp, tp, #g) end
	Duel.ConfirmDecktop(tp, #g)
	return true
end
function fu_GD.DrawReturn(tp, ct)
	-- 那之后，自己抽出回去的数量
	if Duel.IsPlayerAffectedByEffect(tp, 20000459) and Duel.SelectYesNo(tp, aux.Stringid(20000459, 0)) then 
		Duel.Hint(HINT_CARD, 1-tp, 20000459)
		ct = ct + 1 
	end
	Duel.BreakEffect()
	Duel.Draw(tp, ct, REASON_EFFECT)
end
function fu_GD.N_op1(func)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local ct = fu_GD.ReturnDeck(e, tp)
		if ct == 0 then return end
		if not fu_GD.SetDeckTop(e, tp, func) then return end
		fu_GD.DrawReturn(tp, ct)
	end
end
function fu_GD.N_op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsPublic() then return end
	local e1 = fuef.S(e,EFFECT_UPDATE_LEVEL):VAL(ev)
	fuef.FC(e,"ADJ",tp):OP("N_op2op2"):OBJ(e1.e)
end
function fu_GD.N_op2op2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetLabelObject():GetHandler()
	if not (c:IsLocation(LOCATION_HAND) and c:IsPublic()) then 
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
-- ritual monster initial
function fu_GD.RM_initial(_glo)
	local cm, m = fuef.initial(fu_GD, _glo, "AddCode,ReviveLimit", 455)
	cm.pe1 = fuef.F(m):PRO("PTG"):RAN("M"):TRAN(1,0):CON("RM_con1")
	return cm, m
end
function fu_GD.RM_con1(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
if self_code ~= 20000450 then return end
-----------------------------------------------------------------------------------
fu_GD.N_initial("GA", "DG", "IsTyp+IsRac+IsLoc/AbleTo", "RI+M,DR,D,D")