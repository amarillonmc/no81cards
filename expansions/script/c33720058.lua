--无情神秘巨人 / Mistico Gigante Senzacuore
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--set as QP
	local set=Effect.CreateEffect(c)
	set:SetDescription(1159)
	set:SetType(EFFECT_TYPE_FIELD)
	set:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	set:SetCode(EFFECT_SPSUMMON_PROC_G)
	set:SetRange(LOCATION_HAND)
	set:SetCondition(s.CustomSetCon)
	set:SetOperation(s.CustomSSet(c,REASON_RULE,TYPE_EFFECT))
	c:RegisterEffect(set)
	--restore original type property
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetCondition(s.RestoreCon)
	e0:SetOperation(s.RestoreTypeReg(TYPE_EFFECT))
	c:RegisterEffect(e0)
	--act
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCost(s.cost2)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.operation2)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.damcon)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
function s.CustomSetCon(e,c)
	if c==nil then return true end
	local ttp=c:GetControler()
	local check=true
	local egroup={Duel.IsPlayerAffectedByEffect(ttp,EFFECT_CANNOT_SSET)}
	for _,te in ipairs(egroup) do
		local tg=te:GetTarget()
		if not tg then
			check=false
		elseif c and tg(te,c,ttp) then
			check=false
		else
			if not c then
				check=false
			end
		end
	end
	return Duel.GetLocationCount(ttp,LOCATION_SZONE)>0 and check
end
function s.CustomSSet(tc,reason,tpe)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local hand_chk=true
				if not tc:IsLocation(LOCATION_HAND) then
					hand_chk=false
					tc:SetCardData(CARDDATA_TYPE,TYPE_SPELL+TYPE_QUICKPLAY)
				end
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_MONSTER_SSET)
				e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e1,true)
				if tc:IsLocation(LOCATION_SZONE) then
					if tc:IsCanTurnSet() then
						Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK)
						Duel.RaiseEvent(tc,EVENT_SSET,e,reason,tp,tp,0)
						tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY+RESET_MSCHANGE,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE,1)
					end
				else
					Duel.SSet(tp,tc,tp,false)
					tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY+RESET_MSCHANGE,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE,1)
				end
				e1:Reset()
				if hand_chk then
					tc:SetCardData(CARDDATA_TYPE,TYPE_SPELL+TYPE_QUICKPLAY)
				end
				if not tc:IsLocation(LOCATION_SZONE) then
					tc:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+tpe)
				end
			end
end
function s.RestoreCon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.RestoreTypeReg(tpe)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local e0=Effect.CreateEffect(e:GetHandler())
				e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
				e0:SetCode(EVENT_LEAVE_FIELD)
				e0:SetOperation(s.RestoreType(tpe))
				e:GetHandler():RegisterEffect(e0)
			end
end
function s.RestoreType(tpe)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				e:GetHandler():SetCardData(CARDDATA_TYPE,TYPE_MONSTER+tpe)
				e:Reset()
			end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0 and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function s.filter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN+STATUS_FLIP_SUMMON_TURN)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() then
		local prev=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-3000)
		tc:RegisterEffect(e1)
		if prev>0 and tc:GetAttack()==0 and tc:IsAbleToRemove() then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end