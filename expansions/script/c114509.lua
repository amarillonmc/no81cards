--贤者蜘蛛
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114509)
function cm.initial_effect(c)
	local e1 = rsef.QO(c,EVENT_CHAINING,"sp",{1,m},"sp","dsp",rsloc.hg,cm.spcon,nil,rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e4 = rsef.STO_Flip(c,"sset",{1,m+100},"sset","de",nil,nil,rsop.target(cm.setfilter,"sset",0,LOCATION_GRAVE),cm.setop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.accon)
	e2:SetCost(cm.accost)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	--turn set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(rscon.phmp)
	e3:SetTarget(cm.postg)
	e3:SetOperation(cm.posop)
	c:RegisterEffect(e3)
end
function cm.setfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.setop(e,tp) 
	local c = e:GetHandler()
	local ct,og,tc = rsop.SelectSSet(tp,aux.NecroValleyFilter(cm.setfilter),tp,0,LOCATION_GRAVE,1,1,{tp,tp},e,tp)
	if not tc then return end
	if tc:IsType(TYPE_QUICKPLAY) then
		local e1 = rscf.QuickBuff({c,tc},"qas")
	elseif tc:IsType(TYPE_TRAP) then
		local e1 = rscf.QuickBuff({c,tc},"tas")
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.spop(e,tp)
	local c = rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.accon(e)
	cm[0]=false
	return true
end
function cm.acfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.actarget(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.accost(e,te,tp)
	return Duel.IsExistingMatchingCard(cm.acfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.acfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	cm[0]=true
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
