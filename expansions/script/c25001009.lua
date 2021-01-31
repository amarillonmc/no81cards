--拉古斯东•机械改造
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001009)
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,nil,rsval.spconbe)
	local e2=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND,rscon.excard2(Card.IsRace,LOCATION_MZONE,0,1,nil,RACE_MACHINE),nil,rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(cm.atkcon)
	e3:SetCost(cm.atkcost)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
	local e4=rsef.QO(c,nil,{m,2},{1,m+200},"th",nil,LOCATION_GRAVE,cm.thcon,nil,rsop.target(Card.IsAbleToHand,"th"),cm.thop)
end
function cm.con(e,tp)
	local c=e:GetHandler()
	return c:GetTurnID()==Duel.GetTurnCount() and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.thop(e,tp)
	local c=rscf.GetSelf(e) 
	if c then Duel.SendtoHand(c,nil,REASON_EFFECT) end
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetBattleMonster(tp)
	local d=Duel.GetBattleMonster(1-tp)
	return a and a:IsControler(tp) and a:IsRelateToBattle()
		and d and d:IsControler(1-tp) and d:IsRelateToBattle() and Duel.IsPlayerCanSendtoHand(1-tp,d)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d=Duel.GetBattleMonster(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,d,1,0,0)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetBattleMonster(1-tp)
	if not d:IsRelateToBattle() then return end
	if Duel.SendtoHand(d,nil,REASON_RULE)>0 then		
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		Duel.SetLP(1-tp,math.max(0,Duel.GetLP(1-tp)-1000))
	end
end