--废铁龙心
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--equipgt
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabelObject(e0)
	e2:SetCondition(s.eqcon2)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	if not s.global_activate_check then
		s.global_activate_check=true
		s.global_effect_table={}
		s[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsOriginalSetCard(0x24) and rc:IsType(TYPE_SYNCHRO) and rc:IsFaceup() and rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(id)==0 then
		s[0]=s[0]+1
		local ct=s[0]
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,ct)
		--Debug.Message("0")
		s.global_effect_table[ct]=re
	end
end
function s.eqfilter(c)
	return c:IsFaceup() and c:IsOriginalSetCard(0x24) and c:IsType(TYPE_SYNCHRO)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eg=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if eg:GetCount()>0 then
		local tc=eg:GetFirst()
		Duel.HintSelection(eg)
		Duel.Equip(tp,c,tc)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		--
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				--spell speed 2
				if effect:IsHasType(EFFECT_TYPE_IGNITION) then
					effect:SetType(EFFECT_TYPE_QUICK_O)
					effect:SetCode(EVENT_FREE_CHAIN)
					effect:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					local con=effect:GetCondition()
					effect:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetHandler()
						--Debug.Message("1")
						if c:GetFlagEffectLabel(id) then
							--Debug.Message("2")
							local ct=c:GetFlagEffectLabel(id)
							local ce=s.global_effect_table[ct]
							if ce then
								--Debug.Message("3")
								local etg=e:GetTarget()
								local eop=e:GetOperation()
								local cetg=ce:GetTarget()
								local ceop=ce:GetOperation()
								return (not etg or not etg==cetg) and (not eop or not eop==ceop) and (not con or con(e,tp,eg,ep,ev,re,r,rp))
							end
						end
						return not con or con(e,tp,eg,ep,ev,re,r,rp)
					end)
				end
			end
			return cregister(card,effect,flag)
		end
		--
		tc:ReplaceEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD)
		Card.RegisterEffect=cregister
	end
end
function s.eqlimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp)
end
function s.cfilter(c,tp,se)
	return c:IsSetCard(0x24) and c:IsType(TYPE_SYNCHRO)
		and (se==nil or c:GetReasonEffect()~=se)
end
function s.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(s.cfilter,1,nil,tp,se)
end
