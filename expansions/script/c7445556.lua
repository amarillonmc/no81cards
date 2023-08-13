--银帝 阿吉罗斯
local s,id,o=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--remain instead of send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.setcon)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--extra material
	if not Monarchs_ST_Advance_Summon then
		Monarchs_ST_Advance_Summon=true
		Monarchs_ST_Advance_Check=true
		--
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e3:SetTargetRange(LOCATION_SZONE,0)
		e3:SetCondition(s.exrcon)
		e3:SetTarget(s.exrtg)
		e3:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e4:SetTargetRange(LOCATION_HAND,0)
		e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
		e4:SetLabelObject(e3)
		Duel.RegisterEffect(e4,0)
		local e5=e4:Clone()
		Duel.RegisterEffect(e5,1)
		--
		local _Monarchs_ST_Advance_CheckTribute=Duel.CheckTribute
		Duel.CheckTribute=function(c,min,max_n,g_n,tp_n,zone)
							  Monarchs_ST_Advance_Check=false
							  local result=_Monarchs_ST_Advance_CheckTribute(c,min,max_n,g_n,tp_n,zone)
							  Monarchs_ST_Advance_Check=true
							  return result
						  end
		local _Monarchs_ST_Advance_SelectTribute=Duel.SelectTribute
		Duel.SelectTribute=function(c,min,max_n,g_n,tp_n)
							  Monarchs_ST_Advance_Check=false
							  local result=_Monarchs_ST_Advance_SelectTribute(c,min,max_n,g_n,tp_n)
							  Monarchs_ST_Advance_Check=true
							  return result
						  end
	end
end
function s.exrcon(e)
	return Monarchs_ST_Advance_Check
end
function s.exrtg(e,c)
	return c:IsFaceup() and c:GetFlagEffect(7445557)>0
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return e:GetHandler():GetFlagEffect(id)==0 and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rc:IsSetCard(0xbe)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,0)) then
		Duel.ConfirmCards(1-tp,e:GetHandler())
		Duel.HintSelection(Group.FromCards(rc))
		rc:CancelToGrave()
		--remain field
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(id,3))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetCode(EFFECT_REMAIN_FIELD)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3)
		rc:RegisterFlagEffect(7445557,RESET_EVENT+RESETS_STANDARD,0,0)
		e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e)
		and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
