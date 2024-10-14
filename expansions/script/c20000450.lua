--创导龙裔·觉醒者
dofile("expansions/script/c20000000.lua")
fu_GD = fu_GD or { }
--self_draw_con
function fu_GD.sd_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and rp==tp
end
--Normal initial
function fu_GD.N_initial(add_cat, f1_loc, f1_func, f1_val)
	local cm, m = fuef.initial(fu_GD, _glo)
	local func = function(e,tp) return fugf.GetFilter(tp, f1_loc, f1_func, f1_val) end
	cm.pe1 = fuef.I():CAT("TD+DR"..(add_cat and "+"..add_cat or "")):RAN("H"):CTL(m):Func("N_cos1,N_tg1(%1),N_op1(%1)", func)
	cm.pe2 = fuef.FC("DR"):RAN("H"):Func("sd_con,N_op2")
	return cm, m
end
function fu_GD.N_cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	fuef.S(e,EFFECT_PUBLIC):DES("PUB"):PRO("HINT"):RES("STD+PH/ED+OPPO")
end
function fu_GD.N_tg1(func)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tg = func(e,tp,eg,ep,ev,re,r,rp)
		if chk==0 then return Duel.IsPlayerCanDraw(tp) and fugf.GetFilter(tp,"H","AbleTo+Not",{"D",e},1) and #tg>0 end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	end
end
function fu_GD.N_op1(func)
	return function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local max, maxn = 2, #fugf.GetFilter(tp,"M","IsTyp","RI+M") + 1
		if Duel.IsPlayerAffectedByEffect(tp,20000457) then max = maxn end
		local g = fugf.Select(tp,"H","AbleTo+Not",{"D",e}, 1, max)
		if #g==0 then return end
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 then return end
		max = Duel.IsPlayerAffectedByEffect(tp,20000458) and maxn or 1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tg = fugf.Select(tp, func(e,tp,eg,ep,ev,re,r,rp), "GChk", nil, 1, max)
		if #tg==0 then return end
		if fugf.Filter(tg,"IsLoc","G",1) then Duel.SendtoDeck(tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE),nil,0,REASON_EFFECT) end
		Duel.ShuffleDeck(tp) 
		for tc in aux.Next(tg) do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		end
		if #tg>1 then Duel.SortDecktop(tp,tp,#tg) end
		Duel.ConfirmDecktop(tp,#tg)
		Duel.BreakEffect()
		max = #g
		if Duel.IsPlayerAffectedByEffect(tp,20000459) and Duel.SelectYesNo(tp,aux.Stringid(20000459,0)) then 
			Duel.Hint(HINT_CARD,1-tp,20000459)
			max = max + 1 
		end
		Duel.Draw(tp,max,REASON_EFFECT)
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
-- ritual spell initial
function fu_GD.RS_initial(f1_func, f1_val)
	local cm, m = fuef.initial(fu_GD)
	local func = function(e,tp) return fugf.GetFilter(tp, "G", f1_func, f1_val) end
	cm.pe1 = fuef.FTO("LEA"):CAT("TD+DR+GA"):PRO("DE"):RAN("G"):CTL(m):Func("RS_con1,N_tg1(%1),N_op1(%1)", func)
	return cm, m
end
function fu_GD.RS_con1(e,tp,eg,ep,ev,re,r,rp)
	return fugf.Filter(eg,"IsTyp+IsPLoc","RI+M,M",1) and aux.exccon(e)
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