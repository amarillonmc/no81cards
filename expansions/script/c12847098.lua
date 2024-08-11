--宇宙·埃列什基伽勒
local m=12847098
local cm=_G["c"..m]
cm.code=12847098
cm.side_code=12847099
function cm.initial_effect(c)
	c:EnableCounterPermit(0xa7f)
	c:SetCounterLimit(0xa7f,64)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(cm.sumsuc)
	c:RegisterEffect(e0)
	local e0_1=Effect.CreateEffect(c)
	e0_1:SetType(EFFECT_TYPE_SINGLE)
	e0_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0_1:SetCondition(cm.con2)
	e0_1:SetValue(1)
	c:RegisterEffect(e0_1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(cm.con2)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--link summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_ACTIVATE_CONDITION)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--remove
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(m,0))
	e2_1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2_1:SetType(EFFECT_TYPE_QUICK_O)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCountLimit(1,m)
	e2_1:SetCode(EVENT_FREE_CHAIN)
	e2_1:SetCondition(cm.con2)
	e2_1:SetTarget(cm.remtg)
	e2_1:SetOperation(cm.remop)
	c:RegisterEffect(e2_1)
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con)
	e3:SetValue(cm.attackup)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.imcon)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	--change
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.con)
	e5:SetCost(cm.chcost)
	e5:SetTarget(cm.chtg)
	e5:SetOperation(cm.chop)
	c:RegisterEffect(e5)
	if not cm.Side_Check then
		cm.Side_Check=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetCondition(cm.backon)
		e0:SetOperation(cm.backop)
		Duel.RegisterEffect(e0,tp)
	end
end
function cm.checkitside(c)
	return c.code and c.side_code and c:GetFlagEffect(16100000)==0 and c:GetOriginalCode()==c.side_code
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.checkitside,tp,0x7f,0x7f,nil)
	return dg:GetCount()>0
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.checkitside,tp,0x7f,0x7f,nil)
	for c in aux.Next(dg) do
		local tcode=c.code
		c:SetEntityCode(tcode)
		if c:IsFacedown() then
			Duel.ConfirmCards(1-tp,Group.FromCards(c))
		end
		c:ReplaceEffect(tcode,0,0)
		Duel.Hint(HINT_CARD,0,tcode)
		if c:IsLocation(LOCATION_HAND) then
			local sp=c:GetControler()
			Duel.ShuffleHand(sp)
		end
	end
	Duel.Readjust()
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(m,14))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler()~=e:GetHandler() and e:GetHandler():GetFlagEffect(16100000)==0 and Duel.GetFlagEffect(tp,m)<10
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0xa7f,1) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0xa7f,1)
	local num=Duel.GetRandomNumber(2,13)
	Duel.Hint(24,0,aux.Stringid(m,num))
end
function cm.attackup(e,c)
	return c:GetCounter(0xa7f)*200
end
function cm.imcon(e)
	return e:GetHandler():IsAttackAbove(4000) and e:GetHandler():GetFlagEffect(16100000)==0
end
function cm.con(e)
	return e:GetHandler():GetFlagEffect(16100000)==0
end
function cm.con2(e)
	return e:GetHandler():GetFlagEffect(16100000)>0
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0xa7f,10,REASON_COST) end
	c:RemoveCounter(tp,0xa7f,10,REASON_COST)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(16100000)==0 then
		Duel.Hint(HINT_CARD,0,12847099)
		local sidecode=c.side_code
		c:SetEntityCode(sidecode)
		c:RegisterFlagEffect(16100000,RESET_EVENT+0x7e0000,0,0)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m+1,5))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_INACTIVATE)
		e3:SetValue(cm.effectfilter)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e4,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m+1,5))
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetTargetRange(1,0)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		Duel.RegisterEffect(e4,tp)
		Duel.Hint(24,0,aux.Stringid(m+1,0))
	end
end
function cm.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	return te:GetHandler():IsCode(m+1)
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) and c:GetFlagEffect(16100000)>0 end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(24,0,aux.Stringid(m+1,1))
	Duel.Hint(24,0,aux.Stringid(m+1,2))
	for i=1,1 do
		Duel.Hint(HINT_CARD,0,12847097)
	end
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 and c:GetFlagEffect(16100000)>0 then
		Duel.Hint(HINT_CARD,0,12847098)
		local sidecode=c.code
		c:SetEntityCode(sidecode)
		c:ResetFlagEffect(16100000)
		Duel.AdjustAll()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=Duel.SelectMatchingCard(tp,cm.ccheck,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		tc:AddCounter(0xa7f,5)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(-2000)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.ccheck(c)
	return c:IsCode(m) and c:IsCanAddCounter(0xa7f,5)
end