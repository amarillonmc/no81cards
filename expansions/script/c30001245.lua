--3929 永续陷阱
local m=30001245
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_ACTIVATE)
	e17:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e17)
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.itg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.itg)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	--Effect 2 
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_RELEASE)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_SZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(2)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51)   
	--Effect 3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.damcon)
	e3:SetTarget(cm.damtg)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
end
--Effect 1
function cm.itg(e,c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)*200
end
--Effect 2
function cm.hf(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsReleasableByEffect()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)	 
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:Select(tp,1,#g,nil)
	if #hg==0 or Duel.SendtoHand(hg,nil,REASON_EFFECT)==0 or hg:Filter(Card.IsLocation,nil,LOCATION_HAND)==0 then return false end
	Duel.AdjustAll()
	local tg=Duel.GetMatchingGroup(cm.hf,tp,LOCATION_ONFIELD,0,nil) 
	if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		local rg=tg:Select(tp,1,#tg,nil) 
		Duel.Release(rg,REASON_EFFECT)
	end
end
--Effect 3
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_ADVANCE) 
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=eg:GetFirst():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc or tc==nil then return end
	local atk=eg:GetFirst():GetAttack()
	if Duel.Recover(tp,atk,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
