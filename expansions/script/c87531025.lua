--征展星“天狼座” 沃夫
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x64a)
	aux.EnablePendulumAttribute(c,false)
	--超量召唤
	aux.AddXyzProcedure(c,nil,3,8,s.ovfilter,aux.Stringid(id,0),8,s.xyzop)
	c:EnableReviveLimit()
	--特召限制    
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)
	--全抗    
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--效果适用    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.efop)
	c:RegisterEffect(e2)
	--适用效果    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ffcon)
	e1:SetTarget(s.fftg)
	e1:SetOperation(s.ffop)
	c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_FUSION) and c:IsType(TYPE_PENDULUM))
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end	
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(id)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_XYZ) then return end
	--指示物放置    
    c:AddCounter(0x64a,4)
	--战破代替    
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetTarget(s.reptg)
	e1:SetOperation(s.repop)
	c:RegisterEffect(e1,true)
	--双召自肃    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
    local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e3,tp)    
	--抽阶破坏    
    local fid=c:GetFieldID()
    c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,0,1,fid)
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_DRAW)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)	
    e4:SetLabel(fid)
    e4:SetLabelObject(c)
	e4:SetCondition(s.descon)
	e4:SetOperation(s.desop)
	e4:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	Duel.RegisterEffect(e4,tp)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x64a,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x64a,1,REASON_EFFECT)
end
function s.splimit0(e,c)
	return not c:IsLocation(LOCATION_HAND)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	return e:GetLabelObject():GetFlagEffectLabel(id)==e:GetLabel()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function s.ffcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.fftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil):GetCount()>0 and Duel.GetFlagEffect(tp,id)==0
    local b2=Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.GetFlagEffect(tp,id+o)==0
	if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local cost=0
    if b1 and b2 then cost=2 end
    if (b1 and not b2) or (b2 and not b1) then cost=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,cost,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
    Duel.SetTargetCard(g)
    local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)    
end
function s.ffop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=tg:GetCount()
	for i=1,ct do
    	local b1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil):GetCount()>0 and Duel.GetFlagEffect(tp,id)==0
    	local b2=Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.GetFlagEffect(tp,id+o)==0
    	if not b1 and not b2 then break end
        local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,2),1},
			{b2,aux.Stringid(id,3),2})
		if i>1 then
			Duel.BreakEffect()
		end
        if op==1 then
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then		
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
            end    
            Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
        elseif op==2 then
        	Duel.DiscardDeck(tp,3,REASON_EFFECT)
            Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
        end
	end
end