--转生到桃源乡的大神邸官
local m=11621415
local cm=_G["c"..m]
function c11621415.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--ntr
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))	
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.ntrcon)
	e2:SetTarget(cm.ntrtg)
	e2:SetOperation(cm.ntrop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m*2+1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	cm[c]=e3	  
end
--
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1500,300,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.filter(c)
	return c:IsSetCard(0x5220) and c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1500,300,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	--local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	--if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	--  local ag=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	--  if ag:GetCount()>0 then
	--  Duel.HintSelection(ag)
	--  Duel.BreakEffect()
	--  --immune
	--  local e1=Effect.CreateEffect(e:GetHandler())
	--  e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	--  e1:SetCode(EFFECT_DESTROY_REPLACE)
	--  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--   e1:SetRange(LOCATION_MZONE)
	--  e1:SetTarget(cm.reptg)
	--  e1:SetValue(cm.repval)
	--  e1:SetLabel(p)
	--  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	--  --e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	--  ag:GetFirst():RegisterEffect(e1,true)
	--  ag:GetFirst():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	--  end
	--end
end
function cm.repfilter(c,tp)
	return  c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,p,0,LOCATION_EXTRA,nil)
	if chk==0 then return g:GetCount()>0 and eg:IsExists(cm.repfilter,1,nil,p) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		return true
	else return false end
end
function cm.repval(e,c)
	local p=e:GetLabel()
	return cm.repfilter(c,p)
end
--02
function cm.ntrfilter(c)
	return c:IsSetCard(0x5220) and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.ntrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and Duel.IsExistingMatchingCard(cm.ntrfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spfilter(c,tp)
	return c:IsSetCard(0x5220)  and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0,TYPES_EFFECT_TRAP_MONSTER,c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
end
function cm.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local turnp=Duel.GetTurnPlayer()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,turnp,LOCATION_EXTRA,0,nil)
	if chk==0 then return c:IsSSetable() and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,turnp,LOCATION_EXTRA)
end
function cm.ntrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local turnp=Duel.GetTurnPlayer()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,turnp,LOCATION_EXTRA,0,nil)
		Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
		local sg=g:Select(turnp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
--03
function cm.thfilter(c)
	return c:IsSetCard(0x5220)  and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_REMOVED))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--