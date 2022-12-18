--交战
local m=25800110
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x211))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(5)
	e3:SetCondition(cm.drcon)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.descon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCountLimit(1)
	e5:SetCondition(cm.descon2)
	c:RegisterEffect(e5)

end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x211) and c:IsLevelAbove(5) and c:IsControler(tp)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(cm.cfilter,1,nil,tp) and not (ph>PHASE_MAIN1 and ph<PHASE_MAIN2 
		  and Duel.GetTurnPlayer()~=tp)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(cm.cfilter,1,nil,tp) and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 and Duel.GetTurnPlayer()~=tp
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then return end
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0x211) and rc:IsControler(tp)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

