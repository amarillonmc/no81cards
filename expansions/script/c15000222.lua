local m=15000222
local cm=_G["c"..m]
cm.name="白夜骑士·负火之乌列尔"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15000222)
	--self
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(15000222)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.rfilter)
	e2:SetCondition(cm.deccon)
	e2:SetValue(cm.decval)
	c:RegisterEffect(e2)
	--summon with no tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(cm.ntcon)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	--Destroyed
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,15000222)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
end
function cm.decfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceup()
end
function cm.rfilter(e,c)
	return c:IsHasEffect(15000222)
end
function cm.deccon(e)
	return Duel.IsExistingMatchingCard(cm.decfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.decval(e,c)
	return 0x1
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.decfilter,0,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function cm.desfilter(c,sc,tp,seq)
	local cseq=c:GetSequence()
	local p=c:GetControler()
	--local loc=c:GetLocation()&(LOCATION_MZONE+LOCATION_SZONE)
	--if loc==LOCATION_MZONE then
		if cseq==5 and p==tp and seq<=2 then return true end
		if cseq==5 and p~=tp and seq>=2 and seq<5 then return true end
		if cseq==6 and p==tp and seq>=2 and seq<5 then return true end
		if cseq==6 and p~=tp and seq<=2 then return true end
		if cseq<5 and p==tp then return math.abs(cseq-seq)<=1 end
		if cseq<5 and p~=tp then
			if seq==0 then return cseq>=3 end
			if seq==1 then return cseq>=2 end
			if seq==2 then return cseq>=1 and cseq<=3 end
			if seq==3 then return cseq<=2 end
			if seq==4 then return cseq<=1 end
		end
	--end
	return false
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if chkc then return chkc:IsOnField() and cm.desfilter(chkc,c,tp,seq) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c,tp,seq) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,3,nil,c,tp,seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local id=c:GetFieldID()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.desop)
	e1:SetLabel(id)
	e1:SetLabelObject(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local tc=tg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(15000222,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,id,aux.Stringid(m,3))
		tc=tg:GetNext()
	end
end
function cm.des2filter(c,id)
	if c:GetFlagEffectLabel(15000222)~=0 then
		for _,i in ipairs{c:GetFlagEffectLabel(15000222)} do
			if i==id then return true end
		end
	end
	return false
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject()
	local id=e:GetLabel()
	local tg=Duel.GetMatchingGroup(cm.des2filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,id)
	Duel.Destroy(tg,REASON_EFFECT)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(cm.decfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(cm.decfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end