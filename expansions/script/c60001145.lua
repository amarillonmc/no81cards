--钢铁律命“真理”奥兰多
function c60001145.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c60001145.mfilter,c60001145.xyzcheck,2,2) 
	--spsummon proc
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(60001145,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,60001145+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60001145.hspcon)
	e1:SetOperation(c60001145.hspop)
	c:RegisterEffect(e1)
	--skip 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_TURN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0) 
	e2:SetCondition(c60001145.skcon)
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c60001145.skcon)
	e2:SetOperation(c60001145.skop)
	c:RegisterEffect(e2)
	--indes 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTargetRange(LOCATION_MZONE,0) 
	e3:SetCondition(c60001145.idcon)
	e3:SetTarget(c60001145.idtg)  
	e3:SetValue(c60001145.efilter)
	c:RegisterEffect(e3)  
	--xx
	local e4=Effect.CreateEffect(c)  
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e4:SetCode(EVENT_PHASE+PHASE_END) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1) 
	e4:SetTarget(c60001145.xxtg) 
	e4:SetOperation(c60001145.xxop) 
	c:RegisterEffect(e4)
end
function c60001145.mfilter(c) 
	local tp=c:GetControler()
	return c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-tp)
end
function c60001145.xyzcheck(g)
	return true 
end 
function c60001145.cgfil(c,ft)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c60001145.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,c) 
	local g=Duel.GetMatchingGroup(c60001145.cgfil,tp,LOCATION_MZONE,0,nil)
	return ft>0 and g:GetCount()>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=g:GetCount() and Duel.GetDecktopGroup(tp,g:GetCount()):GetCount()==Duel.GetDecktopGroup(tp,g:GetCount()):FilterCount(Card.IsCanOverlay,nil)
end
function c60001145.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c60001145.cgfil,tp,LOCATION_MZONE,0,nil) 
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE) 
	local x=g:GetCount() 
	local og=Duel.GetDecktopGroup(tp,x) 
	Duel.Overlay(c,og) 
	local tc=g:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2) 
	tc=g:GetNext() 
	end 
end
function c60001145.skcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()<=3 
end 
function c60001145.skop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60001145.idcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=4 
end 
function c60001145.idtg(e,c)
	return c:IsDefensePos() 
end 
function c60001145.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function c60001145.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c60001145.dsfil(c)
	return aux.NegateAnyFilter(c)
end
function c60001145.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c60001145.dsfil,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()<=0 then return end 
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then 
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)   
	Duel.BreakEffect() 
	--
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_DEFENSE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1000) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
	c:RegisterEffect(e1)
	else
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end 
end 





