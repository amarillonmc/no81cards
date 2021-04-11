--天穹司书 远览之亚扎利亚斯
function c72410290.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--to spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410290,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,72410290)
	e1:SetTarget(c72410290.igtg)
	e1:SetOperation(c72410290.igop)
	c:RegisterEffect(e1)
	--ss success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410290,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,72410291)
	e2:SetCondition(c72410290.retcon)
	e2:SetTarget(c72410290.rettg)
	e2:SetOperation(c72410290.retop)
	c:RegisterEffect(e2)
	--as spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72410290,3))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,72410292)
	e3:SetCondition(c72410290.spellcon)
	e3:SetTarget(c72410290.spelltg)
	e3:SetOperation(c72410290.spellop)
	c:RegisterEffect(e3)
end
--
function c72410290.igtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND))
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c72410290.igop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND)) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(72410290,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
end
--
function c72410290.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsType(TYPE_SPELL) and rc:IsType(TYPE_CONTINUOUS)
end
function c72410290.filter(c,e)
	local thchk=Duel.IsEnvironment(56433456)
	return c:IsCanBeBattleTarget(e:GetHandler())
end
function c72410290.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local thchk=Duel.IsEnvironment(56433456)
	if chk==0 then return Duel.IsExistingMatchingCard(c72410290.filter,tp,0,LOCATION_MZONE,1,nil,e) and e:GetHandler():IsAttackable() end
end
function c72410290.retop(e,tp,eg,ep,ev,re,r,rp)
	local thchk=Duel.IsEnvironment(56433456)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
	local g=Duel.SelectMatchingCard(tp,c72410290.filter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if g:GetCount()>0 then
		if thchk then
			local c=e:GetHandler()
			local atk=c:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(atk)
			c:RegisterEffect(e1)
		end
			Duel.BreakEffect()
			Duel.CalculateDamage(e:GetHandler(),g:GetFirst())
	end
end
--

function c72410290.filter1(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function c72410290.spellcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	if des:IsReason(REASON_BATTLE) then
		local rc=des:GetReasonCard()
		return rc and rc:IsSetCard(0xa729) and rc:IsControler(tp) and rc:IsRelateToBattle()
	elseif re then
		local rc=re:GetHandler()
		return eg:IsExists(c72410290.filter1,1,nil,tp)
			and rc and rc:IsSetCard(0xa729) and rc:IsControler(tp) and re:IsActiveType(TYPE_MONSTER)
	end
	return not (e:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsType(TYPE_CONTINUOUS))
end
function c72410290.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c72410290.spellop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
