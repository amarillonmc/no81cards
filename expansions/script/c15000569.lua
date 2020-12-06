local m=15000569
local cm=_G["c"..m]
cm.name="寂影双·坠刃"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--zone limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MUST_USE_MZONE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetValue(cm.zonelimit)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.value)
	c:RegisterEffect(e1)
	--SpecialSummon and SearchCard
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,15000569)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_CUSTOM+15000569)
	e4:SetCountLimit(1,15010569)
	e4:SetCondition(cm.dcon)
	e4:SetTarget(cm.dtg)
	e4:SetOperation(cm.dop)  
	c:RegisterEffect(e4)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,15000561)
end
function cm.zonelimit(e)
	return 0x1f001f | (0x600060 & ~e:GetHandler():GetLinkedZone())
end
function cm.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)*500
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsPlayerCanSpecialSummonMonster(1-tp,15000561,nil,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) and Duel.GetMZoneCount(1-tp)~=0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(1-tp,15000561,nil,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) and Duel.GetMZoneCount(1-tp)~=0 end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,0,nil)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,0)
end
function cm.desfilter(c)
	return (c:IsCode(15000560) or aux.IsCodeListed(c,15000560)) and c:IsAbleToHand()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	if not Duel.IsPlayerCanSpecialSummonMonster(1-tp,15000561,nil,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) and Duel.GetMZoneCount(1-tp)~=0 then return end
	local token=Duel.CreateToken(tp,15000561)
	if Duel.SpecialSummon(token,0,1-tp,1-tp,false,false,POS_FACEUP)~=0 then
		Duel.RaiseEvent(c,EVENT_CUSTOM+15000569,re,r,rp,ep,ev)
		if Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local ag=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(ag,nil,REASON_EFFECT)
		end
	end
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	cm[tp]=0
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.val)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.val(e,re,dam,r,rp,rc)
	if cm[e:GetOwnerPlayer()]==1 or bit.band(r,REASON_EFFECT)~=0 then
		return math.floor(dam/2)
	else return dam end
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,0,nil)
	e:GetHandler():ResetFlagEffect(m)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,0,nil)
	if g:GetCount()~=0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end