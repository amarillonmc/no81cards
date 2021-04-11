--深土看守者 花鸟龙 普拉库利
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm = rscf.DefineCard(30013020)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.FC_DestroyReplace(c,nil,LOCATION_HAND,cm.repfilter,rsop.cost(0,"dh"))
	local e2 = rsef.STO_Flip(c,{m,0},nil,nil,"de",aux.NOT(cm.qcon),nil,nil,cm.pop)
	local e4 = rsef.STO_Flip(c,{m,0},nil,nil,"de",cm.qcon,cm.ptg3,nil,cm.pop3)
	local e3 = rsef.FTO(c,EVENT_PHASE+PHASE_END,"sp",1,"sp,td",nil,LOCATION_GRAVE,nil,rscost.reglabel(100),cm.rittg,cm.ritop)
	local e5 = rsef.FV_Player(c,m,1,nil,{1,0},nil,LOCATION_SZONE,cm.acon)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(cm.acon)
	e6:SetValue(cm.effectfilter)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_DISEFFECT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(cm.acon)
	e7:SetValue(cm.effectfilter)
	c:RegisterEffect(e7)
	local e8 = rsef.I(c,"sum",1,"sum",nil,LOCATION_SZONE,cm.acon,nil,rsop.target(cm.sumfilter,"sum",LOCATION_HAND),cm.sumop)
	local e9 = rsef.RegisterOPTurn(c,e8,cm.qcon)
end
function cm.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsHasType(EFFECT_TYPE_FLIP)
end
function cm.sumfilter(c)
	return c:IsMSetable(true,nil)
end
function cm.sumop(e,tp)
	local g,tc = rsop.SelectSolve("sum",tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil,{})
	if tc then
		Duel.MSet(tp,tc,true,nil)
	end
end
function cm.acon(e,tp)
	return e:GetHandler():GetFlagEffect(m) > 0
end
function cm.qcon(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,m)
end
function cm.ptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 end
end
function cm.pop3(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	if not c or Duel.GetLocationCount(tp,LOCATION_SZONE) <= 0 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1 = rscf.QuickBuff_ND(c,"type",TYPE_SPELL+TYPE_CONTINUOUS,rsrst.std - RESET_TURN_SET)
		Duel.BreakEffect()
		c:RegisterFlagEffect(m,rsrst.std,0,1)
	end
end
function cm.pop(e,tp)
	local c = e:GetHandler()
	c:RegisterFlagEffect(m,rsrst.std_ep,0,1)
	local e1 = rsef.FC({c,tp},EVENT_PHASE+PHASE_END,nil,1,nil,nil,cm.pcon2,cm.pop2,rsrst.ep)
end
function cm.pcon2(e,tp)
	return e:GetHandler():GetFlagEffect(m) > 0 and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
function cm.pop2(e,tp)
	rshint.Card(m)
	local c = e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1 = rscf.QuickBuff_ND(c,"type",TYPE_SPELL+TYPE_CONTINUOUS,rsrst.std - RESET_TURN_SET)
		Duel.BreakEffect()
		c:RegisterFlagEffect(m,rsrst.std,0,1)
	end
end
function cm.repfilter(c,e,tp)
	return c:IsFaceup() and (c:IsType(TYPE_FLIP) or c:IsSetCard(0x92c)) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEDOWN_DEFENSE) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.filter(c,e,tp)
	return true
end
function cm.mfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_FLIP) and c:IsAbleToDeck()
end
function cm.dfilter(c,e,tp)
	if not c:IsDiscardable() then return false end
	local mg1=Duel.GetRitualMaterial(tp):Filter(aux.TRUE,c)
	local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
	return cm.RitualUltimateFilter(e:GetHandler(),cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
end
function cm.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel() == 100 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		else
			e:SetLabel(0)
			local mg1=Duel.GetRitualMaterial(tp)
			local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
			return cm.RitualUltimateFilter(e:GetHandler(),cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
		end
	end 
	if e:GetLabel() == 100 then
		e:SetLabel(0)
		rsop.SelectToGrave(tp,cm.dfilter,tp,LOCATION_HAND,0,1,1,nil,{REASON_DISCARD+REASON_COST },e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function cm.ritop(e,tp,eg,ep,ev,re,r,rp)
	local tc = rscf.GetSelf(e)
	if not tc then return end 
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.mfilter),tp,LOCATION_GRAVE,0,nil)
	if not cm.RitualUltimateFilter(tc,cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal") then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsType,nil,TYPE_FLIP)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEDOWN_DEFENSE)
		tc:CompleteProcedure()
	end
end
