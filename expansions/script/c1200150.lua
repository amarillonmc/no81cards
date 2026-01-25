--Ukkoskivi 雷石
function c1200150.initial_effect(c)
	aux.AddCodeList(c,1200120)
	aux.AddCodeList(c,1200130)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c1200150.dissop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--change position
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200150,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c1200150.postg)
	e4:SetOperation(c1200150.posop)
	c:RegisterEffect(e4)
	--position change
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1200150,1))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c1200150.pccon)
	e5:SetCost(c1200150.pccost)
	e5:SetTarget(c1200150.pctg)
	e5:SetOperation(c1200150.pcop)
	c:RegisterEffect(e5)
	
end

function c1200150.dissop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c1200150.disop)
	Duel.RegisterEffect(e1,tp)
end
function c1200150.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc,pos=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
	local rc=re:GetHandler()
	if re:GetHandlerPlayer()==1-Duel.GetTurnPlayer() then return end
	if rc:IsLocation(LOCATION_MZONE) then
		if re:IsActiveType(TYPE_MONSTER) and rc:IsAttackPos() and rc:GetAttackAnnouncedCount()==0 then
			Duel.NegateEffect(ev)
		end
	else
		if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and pos==POS_FACEUP_ATTACK and rc:GetAttackAnnouncedCount()==0 then
			Duel.NegateEffect(ev)
		end
	end
end

function c1200150.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c1200150.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end

function c1200150.pccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==Duel.GetTurnPlayer() and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and e:GetHandler():IsFacedown()
end
function c1200150.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c1200150.pcfilter(c)
	return c:IsCanChangePosition()
end
function c1200150.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1200150.pcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1200150.pcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c1200150.pcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c1200150.pcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end





