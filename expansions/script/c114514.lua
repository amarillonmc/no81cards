--无以名状者·哈斯塔
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114514)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),aux.FilterBoolFunction(Card.IsFusionType,TYPE_FLIP),true)  
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)  
	local e2 = rsef.QO(c,EVENT_SUMMON,"eq",nil,"eq,ctrl","sa",LOCATION_MZONE,cm.con,rscost.cost(Card.IsFacedown,"upa"),rsop.target(cm.confilter,"ctrl",0,LOCATION_MZONE),cm.eqop)
	local e3 = rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON)
	local e4 = rsef.RegisterClone(c,e2,"code",EVENT_FLIP_SUMMON)
	--turn set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
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
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function cm.eqfilter(c)
	return c:IsType(TYPE_FLIP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.confilter(c,e,tp)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and not c:IsStatus(STATUS_SUMMONING) and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.eqop(e,tp)
	local g,tc = rsop.SelectSolve(HINTMSG_OPPO,tp,cm.confilter,tp,0,LOCATION_MZONE,1,1,nil,{})
	if not tc then return end
	local g2,tc2 = rsop.SelectSolve("eq",tp,cm,eqfilter,tp,LOCATION_DECK,1,1,nil,{})
	if rsop.Equip(e,tc2,tc) then
		Duel.GetControl(tc,tp,0)
	end
end