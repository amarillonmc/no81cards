--超时空战斗机-斑鸠
local m=13257360
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableCounterPermit(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB)
	c:SetCounterLimit(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,10)
	c:EnableReviveLimit()
	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e8)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_HAND)
	e9:SetCondition(cm.spcon)
	e9:SetTarget(cm.sptg)
	e9:SetOperation(cm.spop)
	c:RegisterEffect(e9)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.pctg)
	e3:SetOperation(cm.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(cm.bombcost)
	e4:SetTarget(cm.bombtg)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(cm.bgmop)
	c:RegisterEffect(e11)
	eflist={{"bomb",e4}}
	cm[c]=eflist
	
end
function cm.spcfilter(c,tp)
	return c:IsSetCard(0x351) and c:IsFaceup() and c:IsAbleToDeckAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,0,1,nil,c:GetControler())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rc=e:GetLabelObject()
	Duel.SendtoDeck(rc,tp,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
end
function cm.efilter(e,te)
	local c=e:GetHandler()
	return ((c:IsAttribute(ATTRIBUTE_LIGHT) and te:IsActiveType(TYPE_MONSTER)) or (c:IsAttribute(ATTRIBUTE_DARK) and te:IsActiveType(TYPE_SPELL+TYPE_TRAP))) and e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and c:GetFlagEffect(FLAG_ID_CHAINING)>0 and ((c:IsAttribute(ATTRIBUTE_LIGHT) and re:IsActiveType(TYPE_MONSTER)) or (c:IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP))) then
		if c:GetFlagEffect(m)==0 then 
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,1,1)
		else
			local label=c:GetFlagEffectLabel(m)
			c:SetFlagEffectLabel(m,label+1)
		end
		if c:GetFlagEffectLabel(m)>=2 then
			Duel.Hint(HINT_CARD,1,m)
			c:AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
			c:SetFlagEffectLabel(m,0)
		end
	end
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetValue(att)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e5)
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetValue(-200)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e7)
	end
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB)>0 end
	local ct=e:GetHandler():GetCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,ct,REASON_COST)
end
function cm.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.Destroy(g,REASON_EFFECT)
	if e:GetHandler():IsAttackBelow(0) or e:GetHandler():IsDefenseBelow(0)  then
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,7))
end
