--人理之基 开膛手杰克
function c22021120.initial_effect(c)
	aux.AddCodeList(c,22021110)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,22021120+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22021120.damcon)
	e1:SetTarget(c22021120.damtg)
	e1:SetOperation(c22021120.damop)
	c:RegisterEffect(e1)
end
function c22021120.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsControler(tp)
end
function c22021120.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1100)
end
function c22021120.cfilter(c)
	return c:IsFaceup() and c:IsCode(22021110)
end
function c22021120.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 and Duel.SelectOption(tp,aux.Stringid(22021120,1)) and Duel.IsExistingMatchingCard(c22021120.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22021120,0)) then
		Duel.BreakEffect()
		Duel.SelectOption(tp,aux.Stringid(22021120,2))
		Duel.Damage(1-tp,2200,REASON_EFFECT)
	end
end
