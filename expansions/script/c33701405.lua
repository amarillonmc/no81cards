--【背景音台】最终之所 ～The Farthest Ends～
local m=33701405
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.sumlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=math.floor(Duel.GetLP(tp)/100)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x1440,ct,c) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local ct=math.floor(Duel.GetLP(tp)/100)
		c:AddCounter(0x1440,ct)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetAttacker()
	return tp~=Duel.GetTurnPlayer() and tg:IsOnField() and tg:IsCanBeEffectTarget(e)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(0)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e4)
		end
		Duel.SpecialSummonComplete()
		local at=Duel.GetAttacker()
		if tc and at:IsAttackable() and not at:IsImmuneToEffect(e) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetCode(EFFECT_CHANGE_DAMAGE)
			e4:SetTargetRange(1,0)
			e4:SetReset(RESET_EVENT+EVENT_DAMAGE_STEP_END)
			e4:SetValue(cm.damval)
			Duel.RegisterEffect(e4,tp)
			Duel.CalculateDamage(at,tc)
		end
	end
end
function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)==0 then return val end
	local c=e:GetOwner()
	local ct=c:GetCounter(0x1440)
	local ct1=math.ceil(val/100)
	if ct<ct1 then ct1=ct end
	c:RemoveCounter(c:GetControler(),0x1440,ct1,REASON_EFFECT+REASON_REPLACE)
	if val>ct1 then val=val-ct1*100
	else val=0 end
	return val
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(Duel.GetCurrentPhase(),PHASE_MAIN1+PHASE_MAIN2)~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)
	if ct==0 then 
		Duel.SetLP(tp,0)
	else 
		Duel.Recover(tp,math.max(ct*100,4000),REASON_EFFECT)
	end
end



