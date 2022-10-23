--真龙皇 法·王·兽 逆
if not aux.fa_qh_qechk then
	aux.fa_qh_qechk=true
	_rge=Card.RegisterEffect 
	function Card.RegisterEffect(c,ie,ob) --ReplaceEffect
		local b=ob or false
		if not (c:IsOriginalSetCard(0xf9) and c:IsLevel(9))
			or not (ie:IsHasType(EFFECT_TYPE_IGNITION)) then
			return _rge(c,ie,b)
		end  
		local n1=_rge(c,ie,b) 
		local qe=ie:Clone()
		qe:SetType(EFFECT_TYPE_QUICK_O)
		qe:SetCode(EVENT_FREE_CHAIN)
		qe:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE) 
		if ie:GetCondition() then
			local con=ie:GetCondition()
			qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.IsPlayerAffectedByEffect(tp,87498786) and Duel.GetTurnPlayer()==1-tp
					and con(e,tp,eg,ep,ev,re,r,rp) end)
		else qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return Duel.IsPlayerAffectedByEffect(tp,87498786) and Duel.GetTurnPlayer()==1-tp end)
		end 
		qe:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,e:GetHandler(),TYPE_MONSTER):Filter(Card.IsAbleToRemoveAsCost,nil) 
		if chk==0 then return g:GetCount()>0 end 
		Duel.Hint(HINT_CARD,0,87498786)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_COST) end) 
		local op=ie:GetOperation() 
		qe:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
		--
		local e5=Effect.CreateEffect(e:GetHandler()) 
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
		e5:SetCode(EVENT_DESTROYED)  
		e5:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
		--
		local g=eg:Filter(Card.IsControler,nil,1-tp) 
		local tc=g:GetFirst() 
		while tc do   
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(function(e,c)
		local tc=e:GetLabelObject()
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) end)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetLabelObject()
		return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule()) end)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.NegateEffect(ev) end)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)   
		tc=g:GetNext() 
		end  end)
		--   
		e5:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e5,tp)   
		--
		op(e,tp,eg,ep,ev,re,r,rp) end)
		local n2=_rge(c,qe,b)
		return n1,n2
	end
end
function c87498786.initial_effect(c)  
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,c87498786.ovfilter,aux.Stringid(87498786,0),99)
	c:EnableReviveLimit()   
	--x ov 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(87498786,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,87498786) 
	e1:SetCondition(c87498786.xovcon)
	e1:SetTarget(c87498786.xovtg) 
	e1:SetOperation(c87498786.xovop) 
	c:RegisterEffect(e1) 
	--Fa Fa 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(87498786,4)) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,17498786) 
	e2:SetCost(c87498786.facost) 
	e2:SetTarget(c87498786.fatg) 
	e2:SetOperation(c87498786.faop) 
	c:RegisterEffect(e2) 
	--ck 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(0xff)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c87498786.adop)
	c:RegisterEffect(e3)

end 
c87498786.pendulum_level=9 
function c87498786.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf9) and c:IsLevel(9) 
end
function c87498786.xovcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetTurnPlayer()==1-tp  
end  
function c87498786.ovfil(c) 
	return (c:IsAbleToHand() or c:IsCanOverlay()) and c:IsLevel(9) and c:IsSetCard(0xf9)   
end 
function c87498786.xovtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c87498786.ovfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
end 
function c87498786.xovop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c87498786.ovfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	local op=0 
	local b1=tc:IsAbleToHand() 
	local b2=c:IsRelateToEffect(e) and tc:IsCanOverlay() 
	if b1 and b2 then  
	op=Duel.SelectOption(tp,aux.Stringid(87498786,1),aux.Stringid(87498786,2)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(87498786,1)) 
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(87498786,2))+1 
	end  
	if op==0 then 
	Duel.SendtoHand(tc,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,tc)
	elseif op==1 then 
	Duel.Overlay(c,tc) 
	end 
	end 
end 
function c87498786.facost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c87498786.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(rc)
end
function c87498786.faop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp) 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetLabel(e:GetLabel())
	e2:SetTarget(c87498786.atktarget)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp) 
	--
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(87498786,4))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(87498786) 
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(88581108) 
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end 
function c87498786.atktarget(e,c)
	return c:IsAttribute(e:GetLabel())
end
function c87498786.filsn(c)
	return c:IsOriginalSetCard(0xf9) and c:IsLevel(9) and not c:GetFlagEffectLabel(87498786)
end
function c87498786.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(c87498786.filsn,tp,LOCATION_HAND,LOCATION_HAND,c)
	local nc=ng:GetFirst()
	while nc do
		nc:RegisterFlagEffect(87498786,RESETS_STANDARD,0,1)
		nc:ReplaceEffect(nc:GetCode(),0)
		nc=ng:GetNext()
	end
end








