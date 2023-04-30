--概念虚械 仁爱
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
local cm,m,o=GetID()
fu_cim = fu_cim or {}
-------------------------------main effect
function fu_cim.XyzUnite(c)
	c:EnableReviveLimit()
	local e0=fuef.F(c,1165,EFFECT_SPSUMMON_PROC,"OE","E",nil,SUMMON_TYPE_XYZ,nil,fu_cim.XyzProccon,fu_cim.XyzProctg,aux.XyzLevelFreeOperation(),c)
	local e1 = fuef.QO(c,{20000150,1},nil,nil,"TG","M",1,nil,fu_cim.RemoveXyz,fu_cim.GM_tg,fu_cim.GM_op,c)
	local e2 = fuef.SC(c,nil,EVENT_MOVE,"DE",nil,fu_cim.GF_con,fu_cim.GF_op,c)
	return e0,e1,e2
end
function fu_cim.RemoveXyz(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=fugf.GetFilter(tp,"M",{Card.IsSetCard,Card.CheckRemoveOverlayCard},{0xcfd1,{tp,1,REASON_COST}})
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	g:Select(tp,1,1,nil):GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
-------------------------------
function fu_cim.XyzProc_cardf(c,xyzc,tp)
	if not aux.XyzLevelFreeFilter(c,xyzc) then return false end
	return (Duel.GetFlagEffect(tp,20000167)>0 and c:IsControler(1-tp)) or (c:IsControler(tp) and not c:IsType(TYPE_LINK))
end
function fu_cim.XyzProc_groupf(g,xyzc,tp)
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)==0 or fugf.Filter(g,Card.IsControler,1-tp,nil,2) then return false end
	if Duel.GetFlagEffect(tp,20000167)==0 and fugf.Filter(g,Card.IsControler,1-tp,nil,1) then return false end
	if xyzc:GetRank()==12 and not (fugf.Filter(g,Card.IsType,TYPE_XYZ,nil,1) or fugf.Filter(g,Card.IsControler,1-tp,nil,1)) then return false end
	local sg=fugf.Filter(g,Card.IsControler,tp)
	return sg:GetSum(Card.GetRank) + sg:GetSum(Card.GetLevel) + (fugf.Filter(g,Card.IsControler,1-tp,nil,1) and 3 or 0) == xyzc:GetRank()
end
function fu_cim.XyzProccon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetRank()==12 and 99 or 2
	if min then
		minc=math.max(2,min)
		maxc=math.min(maxc,max)
	end
	if maxc<minc then return false end
	local mg=fugf.GetFilter(tp,"M+M",fu_cim.XyzProc_cardf,{c,tp})
	if og then mg=fugf.Filter(og,fu_cim.XyzProc_cardf,{c,tp}) end
	og=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if fugf.Filter(og,aux.MustMaterialCounterFilter,mg,nil,1) then return false end
	Duel.SetSelectedCard(og)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(fu_cim.XyzProc_groupf,minc,maxc,c,tp)
	Auxiliary.GCheckAdditional=nil
	return res
end
function fu_cim.XyzProctg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local minc=2
	local maxc=c:GetRank()==12 and 99 or 2
	if min then
		minc=math.max(2,min)
		maxc=math.min(maxc,max)
	end
	local mg=fugf.GetFilter(tp,"M+M",fu_cim.XyzProc_cardf,{c,tp})
	if og then mg=fugf.Filter(og,fu_cim.XyzProc_cardf,{c,tp}) end
	Duel.SetSelectedCard(Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	mg=mg:SelectSubGroup(tp,fu_cim.XyzProc_groupf,Duel.IsSummonCancelable(),minc,maxc,c,tp)
	Auxiliary.GCheckAdditional=nil
	if not (mg and #mg>0) then return false end
	if fugf.Filter(mg,Card.IsControler,1-tp,nil,1) then
		Duel.Hint(HINT_CODE,tp,20000167)
		Duel.ResetFlagEffect(tp,20000167)
	end
	mg:KeepAlive()
	e:SetLabelObject(mg)
	return true
end
function fu_cim.GM_tgf(c,e)
	return c:IsCanOverlay() and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function fu_cim.GM_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and fu_cim.GM_tgf(chkc,e) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and fugf.GetFilter(tp,"G+G",fu_cim.GM_tgf,e,nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	fugf.SelectTg(tp,"G+G",fu_cim.GM_tgf,e,nil,1)
end
function fu_cim.GM_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsType(TYPE_XYZ)) then return end
	Duel.Overlay(c,tc)
end
function fu_cim.GF_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function fu_cim.GF_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=re:GetOperation()
	if not c.Add or not op then return end
	re:SetOperation(fu_cim.GF_op1(op,c.Add))
end
function fu_cim.GF_op1(ori_op,add_op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		e:SetOperation(ori_op)
		ori_op(e,tp,eg,ep,ev,re,r,rp)
		add_op(e,tp,eg,ep,ev,re,r,rp)
	end
end
function fu_cim.BM_con(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsSetCard(0xcfd1)
end
function fu_cim.BM_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not c.Add then return end
	c.Add(c,rc)
	if rc:IsType(TYPE_EFFECT) then return end
	local e2=fuef.S(e,nil,EFFECT_ADD_TYPE,nil,nil,TYPE_EFFECT,nil,nil,nil,{rc,true},RESET_EVENT+RESETS_STANDARD)
end
-------------------------------
if not cm then return end
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and (c:GetAttack()/2)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	Duel.Recover(tp,c:GetAttack()/2,REASON_EFFECT)
end