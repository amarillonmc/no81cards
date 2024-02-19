--深土看守者 花鸟龙 普拉库利
local m=30013020
local cm=_G["c"..m]  
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.qktg)
	e1:SetOperation(cm.qkop)
	c:RegisterEffect(e1)
	--Effect 3
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_RELEASE+CATEGORY_TODECK)
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCondition(cm.thcon1)
	e12:SetCost(cm.thcost)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_RELEASE+CATEGORY_TODECK)
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetCode(EVENT_FREE_CHAIN)
	e32:SetRange(LOCATION_GRAVE)
	e32:SetCondition(cm.thcon2)
	e32:SetCost(cm.thcost)
	e32:SetTarget(cm.thtg)
	e32:SetOperation(cm.thop)
	c:RegisterEffect(e32)
end
--Effect 1
function cm.repfilter(c,tp)
	return not c:IsReason(REASON_REPLACE)
		and c:IsOnField() and c:IsControler(tp) 
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) 
		and (c:IsFacedown() and c:IsLocation(LOCATION_MZONE))
		or (c:IsFaceup() and (c:IsSetCard(0x92c) or c:IsType(TYPE_FLIP)))
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND) and c:IsDiscardable() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)
end
--Effect 2
function cm.qktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.qkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	Duel.BreakEffect() 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(30013020)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.activate2)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	e6:SetValue(cm.effectfilter)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_DISEFFECT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetValue(cm.effectfilter)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e7)
	c:RegisterFlagEffect(m+105,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0)) 
	c:RegisterFlagEffect(m+105,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1)) 
	c:RegisterFlagEffect(m+105,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2)) 
end
function cm.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:IsHasType(EFFECT_TYPE_FLIP)
end
function cm.mset(c)
	return c:IsMSetable(true,nil)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.mset,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.mset,tp,LOCATION_HAND,0,nil)
	if #sg==0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=sg:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsMSetable(true,nil) then
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
--Effect 3
function cm.thcon1(e)
	local tsp=e:GetHandler():GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcon2(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
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
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		else
			e:SetLabel(0)
			local mg1=Duel.GetRitualMaterial(tp)
			local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
			return cm.RitualUltimateFilter(e:GetHandler(),cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
		end
	end 
	if e:GetLabel()==100 then
		e:SetLabel(0)
		Duel.DiscardHand(tp,cm.dfilter,1,1,REASON_COST+REASON_DISCARD,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end 
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.mfilter),tp,LOCATION_GRAVE,0,nil)
	if not cm.RitualUltimateFilter(tc,cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal") then return end
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
		Duel.SendtoDeck(mat2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEDOWN_DEFENSE)>0 then
			Duel.ConfirmCards(1-tp,tc)
		end
		tc:CompleteProcedure()
	end
end
