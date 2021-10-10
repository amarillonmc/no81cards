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
	local c = e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF or (c:GetFlagEffect(c:GetOriginalCodeRule()) > 0 and c:IsType(TYPE_RITUAL))
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
function rsfwh.ExtraRitualFun(c,re,sum_loc,sum_filter)
	local tg = re:GetTarget()
	local op = re:GetOperation()
	re:SetTarget(cm.erftg(tg))
	re:SetOperation(cm.erfop(tg,op,sum_loc,sum_filter))
end
function cm.erftg(tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local b1 = not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		local sg = Duel.GetMatchingGroup(cm.erfspfilter,tp,sum_loc,0,nil,e,tp)
		local b2 = #sg > 0
		if chk == 0 then 
			return b1 or b2
		end
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function cm.erfop(tg,op,sum_loc,sum_filter)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local f = sum_filter
		sum_filter = function(c,...)
			return aux.NecroValleyFilter(f)(c,...)
		end
		local b1 = not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		local sg = Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.erfspfilter),tp,sum_loc,0,nil,e,tp)
		local b2 = #sg > 0
		sum_filter = f 
		local cop = 1
		if b1 and not b2 then cop = 1
		elseif not b1 and b2 then cop = 2
		elseif b1 and b2 then 
			cop = rshint.SelectOption(tp,true,{m,3},true,{m,4})
		else
			sum_filter = f
			return 
		end
		if cop == 1 then 
			op(e,tp,eg,ep,ev,re,r,rp)
		elseif cop == 2 then
			local og,ritc = rsop.SelectCards("sp",tp,aux.NecroValleyFilter(cm.erfspfilter),tp,sum_loc,0,1,1,nil,e,tp)
			cm.attach_list[ritc] = nil
			local og2,matc = rsop.SelectCards("xmat",tp,cm.erfmatfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,ritc.rsfwh_ex_ritual)
			local matg = matc:GetOverlayGroup()
			if #matg > 0 then
				Duel.Overlay(ritc,matg)
			end
			ritc:SetMaterial(Group.FromCards(matc))
			Duel.Overlay(ritc,matc)
			Duel.BreakEffect()
			Duel.SpecialSummon(ritc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			local e1 = rsef.FC_PhaseLeave({ritc,tp},ritc,nil,nil,PHASE_END,cm.ovlop2(matc),rsrst.std)
			local code = ritc:GetOriginalCodeRule()
			matc:RegisterFlagEffect(m,rsrst.std,0,1)
			ritc:RegisterFlagEffect(code,rsrst.std,0,1)
			Duel.RegisterFlagEffect(tp,code,rsrst.ep,0,1)
			local tc = ritc:GetOverlayGroup():Filter(Card.IsSetCard,nil,0x7f1b):GetFirst()
			cm.attach_list[ritc] = tc
		end
		sum_filter = f
	end
end
function cm.ovlop2(matc)
	return function(g,e,tp)
		local tc = g:GetFirst()
		local og = tc:GetOverlayGroup()
		if og:IsContains(matc) and matc:GetFlagEffect(m) > 0 then 
			if matc:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 then
				Duel.MoveToField(matc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			elseif matc:IsSetCard(0x6f1b) and matc:IsType(TYPE_MONSTER) and rscf.spfilter2()(matc,e,tp) then 
				local matg2 = og - matc
				Duel.SpecialSummon(matc,0,tp,tp,false,false,POS_FACEUP)
				if #matg2 > 0 then 
					Duel.Overlay(matc, matg2)
				end
			end
		end
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function cm.erfspfilter(c,e,tp)
	local mat_filter = c.rsfwh_ex_ritual
	return mat_filter and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.IsExistingMatchingCard(cm.erfmatfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,mat_filter) and Duel.GetFlagEffect(tp, c:GetOriginalCodeRule()) == 0
end
function cm.erfmatfilter(c,e,tp,mat_filter)
	return c:IsCanOverlay() and mat_filter(c,e,tp) and Duel.GetMZoneCount(tp,c,tp) > 0
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
