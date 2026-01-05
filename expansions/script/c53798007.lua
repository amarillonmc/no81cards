--绝对服从魔人-虚空魔人
function c53798007.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53798007,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c53798007.spcon)
	e1:SetTarget(c53798007.sptg)
	e1:SetOperation(c53798007.spop)
	c:RegisterEffect(e1)
	--disable-effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCondition(c53798007.regcon)
	e2:SetOperation(c53798007.regop)
	c:RegisterEffect(e2)
	--disable-battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c53798007.regop2)
	c:RegisterEffect(e3)
end
function c53798007.spcon(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and p==1-tp--re:GetActivateLocation()
end
function c53798007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,c)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and #g~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c53798007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,99,nil)
		if #g==0 or Duel.Destroy(g,REASON_EFFECT)==0 or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 or not rc:IsRelateToChain() or rc:IsControler(tp) then return end
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.CalculateDamage(c,rc,true)
	end
end
function c53798007.cfilter(c,code)
	if not (c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)) return false end
	return c:GetReasonEffect():IsActivated() and code==53798007
end
function c53798007.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	local code=ct~=0 and Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_CODE) or 0
	local g=eg:Filter(c53798007.cfilter,nil,code)
	if #g==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetCondition(c53798007.discon)
		e1:SetReset(RESET_EVENT+0x17a0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
function c53798007.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,d=Duel.GetBattleMonster(0)
	local tc=a:IsStatus(STATUS_BATTLE_DESTROYED) and a or d
	if not tc then return end
	c:SetCardTarget(tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(c53798007.discon)
	e1:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
end
function c53798007.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetOwner():GetCardTarget()
	return g and g:IsContains(e:GetHandler())
end
