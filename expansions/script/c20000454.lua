--创导龙裔的秘仪
dofile("expansions/script/c20000450.lua")
local cm, m = fuef.initial(fu_GD)
cm.e1 = fuef.A():CAT("RE"):Func("tg1,op1")
cm.e2 = fuef.FTO("LEA"):CAT("TD+DR+GA"):PRO("DE"):RAN("G"):CTL(m):Func("DRM_leave_con,tg2,op2")
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"HG","IsTyp+IsRac+CanSp+AbleTo","RI+M,DR,%1,*R",1,{e,"RI",tp}) and fugf.GetFilter(tp,"H","IsTyp+IsPublic","M",1) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg = fugf.Select(tp,"HG","IsTyp+IsRac+CanSp+AbleTo","RI+M,DR,%1,*R",1,1,{e,"RI",tp})
	if #rg ~= 1 then return end
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) == 0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg = fugf.Select(tp,"H","IsTyp+IsPublic","M",1)
	if #sg ~= 1 then return end
	Duel.ConfirmCards(1-tp,sg)
	local fid = rg:GetFirst():GetFieldID()
	fusf.RegFlag(rg + sg, m, "STD", "HINT", fid, 0)
	fuef.FC(e,"ADJ",tp):Func("op1con1,op1op1"):LAB(fid)
end
function cm.op1con1(e,tp,eg,ep,ev,re,r,rp)
	local fid = e:GetLabel()
	local rc = fugf.GetFilter(tp,"R","IsFlagLab",{m,fid}):GetFirst()
	local sc = fugf.GetFilter(tp,"H","IsFlagLab",{m,fid}):GetFirst()
	if not (rc and sc) then 
		e:Reset()
		return false
	end
	return sc:IsCanBeRitualMaterial(rc) and sc:IsLevelAbove(rc:GetLevel()) and (sc.mat_filter or aux.TRUE)(rc)
end
function cm.op1op1(e,tp,eg,ep,ev,re,r,rp)
	local fid = e:GetLabel()
	local rc = fugf.GetFilter(tp,"R","IsFlagLab",{m,fid}):GetFirst()
	local sg = fugf.GetFilter(tp,"H","IsFlagLab",{m,fid})
	if not rc or #sg ~= 1 then return end
	rc:SetMaterial(sg)
	Duel.Hint(HINT_CARD,0,m)
	Duel.ReleaseRitualMaterial(sg)
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
	e:Reset()
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAbleToDeck() and fugf.GetFilter(tp,"D","IsTyp+AbleTo","RI+S,D",1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2f(g,c)
	return g:IsContains(c)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local max, maxn = 2, #fugf.GetFilter(tp, "M", "IsTyp", "RI+M") + 1
	if Duel.IsPlayerAffectedByEffect(tp, 20000457) and maxn > max then max = maxn end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SetSelectedCard(e:GetHandler())
	local g = fugf.GetFilter(tp,"G","AbleTo+GChk","D"):SelectSubGroup(tp,cm.op2f,false,1,max,e:GetHandler())
	if Duel.SendtoDeck(g, nil, 2, REASON_EFFECT) == 0 then return end
	if not fu_GD.SetDeckTop(e, tp, fugf.GetNoP("D","IsTyp+AbleTo","RI+S,D")) then return end
	fu_GD.DrawReturn(tp, 1)
end