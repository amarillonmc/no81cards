--焰之巫女 莉诺
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m , cm = rscf.DefineCard(40009561)
if rsfwh then return end
rsfwh = cm 
cm.attach_list = { }

function rsfwh.OvelayFun(c,code)
	local e1 = rscf.AddSpecialSummonProcdure(c,LOCATION_HAND,cm.ovcon,nil,cm.ovop,nil,{1,code+100},SUMMON_VALUE_SELF)
	return e1
end
function cm.ovcon(e,c,tp)
	return Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.ovfilter(c)
	return c:IsCanOverlay() and c:IsFaceup() and cm.ovtfilter(c) and Duel.GetMZoneCount(tp,c,tp) > 0
end
function cm.ovtfilter(c)
	return c:IsSetCard(0x7f1b) and c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS)
end
function cm.ovop(e,tp)
	local c = e:GetHandler()
	cm.attach_list[c] = nil
	local og,tc = rsop.SelectSolve("xmat",tp,cm.ovfilter,tp,LOCATION_ONFIELD,0,1,1,nil,{})
	Duel.Overlay(c,og)
	local mc = og:GetFirst()
	cm.attach_list[c] = mc
	local e1 = rsef.FC_PhaseLeave({c,tp},c,nil,nil,PHASE_END,cm.ovlop,rsrst.std_ntf)
end
function cm.ovlop(g,e,tp)
	local tc = g:GetFirst()
	local og = tc:GetOverlayGroup():Filter(cm.ovtfilter,nil)
	local ft = Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft > 0 and #og > ft then
		rshint.Select(tp,"tf")
		og = og:Select(tp,ft,ft,nil)
	end
	for mc in aux.Next(og) do
		Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function rsfwh.SummonFun(c,code,cate,tg,op,cate2,tg2,op2)
	cate = cate or 0
	cate2 = cate2 or 0 
	local e1 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{code,1},{1,code},nil,"de",nil,nil,cm.ssftg(cate,tg,op,cate2,tg2))
	local e2 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{code,2},{1,code},nil,"de",rsfwh.CheckSSCon,nil,cm.ssftg(cate,tg,op2,cate2,tg2))
	local e3 = rsef.STO(c,EVENT_SUMMON_SUCCESS,{code,1},{1,code},nil,"de",nil,nil,cm.ssftg(cate,tg,op,cate2,tg2))
	local e4 = rsef.STO(c,EVENT_SUMMON_SUCCESS,{code,2},{1,code},nil,"de",rsfwh.CheckSSCon,nil,cm.ssftg(cate,tg,op2,cate2,tg2))
	return e1,e2,e3,e4
end
function cm.ssftg(cate,tg,op,cate2,tg2)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c = e:GetHandler()
		local reg_cate, reg_op = cate, op
		local ex_cate, ex_op, code
		if chk == 0 then return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) end
		tg(e,tp,eg,ep,ev,re,r,rp,1)
		if rsfwh.CheckSSCon(e) then
			reg_cate = reg_cate | cate2
			local mc = cm.attach_list[c]
			if mc then
				code = mc:GetOriginalCode()
				local meta = _G["c".. code]
				if meta and meta.Overlay_List and Duel.GetFlagEffect(tp,code) == 0 then
					ex_cate, ex_op = table.unpack(meta.Overlay_List)
					reg_cate = reg_cate | (ex_cate or 0)
				end
			end
			tg2(e,tp,eg,ep,ev,re,r,rp,1)
		end
		e:SetCategory(reg_cate)
		e:SetOperation(cm.ssfop(reg_op,ex_op,code))
	end
end
function cm.ssfop(op,ex_op,code)
	return function(e,tp,...)
		op(e,tp,...)
		if ex_op then
			Duel.Hint(HINT_CARD,0,code)
			ex_op(e,tp,...)
			if code then
				Duel.RegisterFlagEffect(tp,code,rsrst.ep,0,1)
			end
		end
	end
end
function rsfwh.CheckSSCon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
end
function rsfwh.ExtraEffect(e)
	local tg = e:GetTarget() or aux.TRUE 
	local op = e:GetOperation() or aux.TRUE 
	local cate = e:GetCategory()
	e:SetTarget(cm.ssftg2(cate,tg,op))
end
function cm.ssftg2(cate,tg,op)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c = e:GetHandler()
		local reg_cate, reg_op = cate, op
		local ex_cate, ex_op, code
		if chk == 0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
		tg(e,tp,eg,ep,ev,re,r,rp,1)
		if rsfwh.CheckSSCon(e) then
			local mc = cm.attach_list[c]
			if mc then
				code = mc:GetOriginalCode()
				local meta = _G["c".. code]
				if meta and meta.Overlay_List and Duel.GetFlagEffect(tp,code) == 0 then
					ex_cate, ex_op = table.unpack(meta.Overlay_List)
					reg_cate = reg_cate | (ex_cate or 0)
				end
			end
		end
		e:SetCategory(reg_cate)
		e:SetOperation(cm.ssfop(reg_op,ex_op,code))
	end
end
------------------------------------
function cm.initial_effect(c)
	local e1 = rsfwh.OvelayFun(c,m)
	local e2,e3 = rsfwh.SummonFun(c,m,CATEGORY_SEARCH+CATEGORY_TOHAND,cm.thtg,cm.thop,CATEGORY_SPECIAL_SUMMON,cm.sptg,cm.spop)
end
function cm.filter(c)
	return not c:IsCode(m) and c:IsSetCard(0x6f1b) and c:IsType(TYPE_MONSTER)
end
function cm.thfilter(c)
	return cm.filter(c) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return cm.filter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g > 0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
