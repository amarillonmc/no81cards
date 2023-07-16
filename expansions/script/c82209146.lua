--超新星 赫利俄斯
local m=82209146
local cm=c82209146
function cm.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule  
	local e0=Effect.CreateEffect(c)  
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)  
	e0:SetType(EFFECT_TYPE_FIELD)  
	e0:SetRange(LOCATION_HAND)  
	e0:SetCode(EFFECT_SPSUMMON_PROC)  
	e0:SetCondition(cm.hspcon)  
	e0:SetOperation(cm.hspop)  
	c:RegisterEffect(e0)  
	--update atk
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCode(EFFECT_SET_ATTACK)  
	e1:SetValue(cm.value)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_SET_DEFENSE)  
	c:RegisterEffect(e2)  
	--negate  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetCondition(cm.discon)  
	e3:SetTarget(cm.distg)  
	e3:SetOperation(cm.disop)  
	c:RegisterEffect(e3)  
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	--summon success  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e5:SetOperation(cm.spsumsuc)  
	c:RegisterEffect(e5) 
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e6:SetRange(LOCATION_MZONE)  
	e6:SetCode(EVENT_CHAIN_END)  
	e6:SetOperation(cm.spsumsuc2)  
	c:RegisterEffect(e6)  
end
function cm.hspfilter(c,ft,tp)  
	return c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelBelow(9)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())  
end  
function cm.hspcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	return ft>-1 and Duel.CheckReleaseGroup(tp,cm.hspfilter,1,nil,ft,tp)  
end  
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,ft,tp)  
	Duel.Release(g,REASON_COST)  
end  
function cm.filter(c)  
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)  
end  
function cm.value(e,c)  
	return Duel.GetMatchingGroupCount(cm.filter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*400  
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local ph=Duel.GetCurrentPhase()  
	return (not c:IsStatus(STATUS_BATTLE_DESTROYED)) and Duel.IsChainDisablable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end  
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
	local g1=Duel.GetDecktopGroup(1-tp,3) 
	local g2=Duel.GetDecktopGroup(tp,3)  
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,6,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g1=Duel.GetDecktopGroup(1-tp,3)
		local g2=Duel.GetDecktopGroup(tp,3)
		g1:Merge(g2)
		if g1:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		end
	end
end  
function cm.spsumsuc(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetCurrentChain()==0 then  
		Duel.SetChainLimitTillChainEnd(aux.FALSE)  
	elseif Duel.GetCurrentChain()==1 then  
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
	end  
end  
function cm.spsumsuc2(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():GetFlagEffect(m)~=0 then  
		Duel.SetChainLimitTillChainEnd(aux.FALSE)  
	end  
	e:GetHandler():ResetFlagEffect(m)  
end  