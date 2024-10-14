--身势·振刀
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010252)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,60010252,cm.mfilter,1,true,true)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.uop)
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	Duel.RegisterEffect(e3,0)

	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
end
function cm.mfilter(c,fc,sub,mg,sg)
	local tf=false
	if not sg or sg:FilterCount(aux.TRUE,c)==0 then tf=true 
	elseif sg:GetFirst():GetColumnGroup():IsContains(c) then tf=true end
	return c:IsLocation(LOCATION_MZONE) and tf
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,re:GetHandler()) and c:CheckFusionMaterial(nil,re:GetHandler()) and rp~=tp end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local fc=Duel.SelectMatchingCard(tp,cm.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,re:GetHandler()):GetFirst()
		local fg=Group.FromCards(re:GetHandler(),fc)
		c:SetMaterial(fg)
		if Duel.SendtoGrave(fg,REASON_SPSUMMON)==2 then
			Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end

function cm.mfilter2(c,tc)
	return c:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) and c:GetColumnGroup():IsContains(tc) 
		and #Group.FromCards(c,tc):Filter(cm.mfilter3,nil)>0
end
function cm.mfilter3(c)
	return c:IsCode(60010252) and c:IsFaceup()
end

function cm.uop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function cm.disfilter(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(m) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsDisabled()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetLocation()~=re:GetActivateLocation()
		and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function cm.filter(c)
	return aux.IsCodeListed(c,60010252) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil):Select(tp,1,1,nil)
		if #sg>0 then Duel.SSet(tp,sg:GetFirst()) end
	end
end


