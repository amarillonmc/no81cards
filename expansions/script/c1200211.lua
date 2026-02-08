--数字冥魂[天空神庙]=复生系统
--1200211
local supercode=1200205 -- =登录系统卡号
local repcode=1200202 -- =摆渡人卡号
local s,id,o=GetID()
function s.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--load effect
	local le0=e0:Clone()
	le0:SetDescription(aux.Stringid(supercode,1))
	le0:SetCondition(s.sphandcon)
	c:RegisterEffect(le0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_SKIP_M1)
	c:RegisterEffect(e2)
	--immue
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(s.indcon)
	e3:SetTarget(s.indtg)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(s.efilter2)
	c:RegisterEffect(e4)
	--return to hand and summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetDescription(1104)
	e5:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.rttg)
	e5:SetOperation(s.rtop)
	c:RegisterEffect(e5)
	--load effect
	local le5=e5:Clone()
	le5:SetDescription(aux.Stringid(supercode,1))
	le5:SetType(EFFECT_TYPE_QUICK_O)
	le5:SetCode(EVENT_CHAINING)
	le5:SetCondition(s.qcon)
	c:RegisterEffect(le5)

end
s.has_text_type=TYPE_SPIRIT
function s.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end

function s.PlayerHint(e,tp,num)

	local he=Effect.CreateEffect(e:GetHandler())
	he:SetReset(RESET_PHASE+PHASE_END)
	he:SetDescription(aux.Stringid(id,num))
	he:SetType(EFFECT_TYPE_FIELD)
	he:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	he:SetTargetRange(1,0)
	Duel.RegisterEffect(he,tp)

end

function s.rfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup())
		and c:IsType(TYPE_SPIRIT)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.thfilter(c,e,tp,att)
	return c:GetOriginalAttribute()==att and c:IsType(TYPE_SPIRIT)
		and not c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local att=0
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	if Duel.CheckReleaseGroup(tp,s.rfilter,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		
		local rg=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,nil,tp)
		att=rg:GetFirst():GetOriginalAttribute()
		Duel.Release(rg,REASON_COST)
		--Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end	
	
	e:SetLabel(att,0)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetLabel(att,100)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+1)~=0 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local att,num=e:GetLabel()
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		s.PlayerHint(e,tp,7)
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
	
	if att and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,
		1,nil,e,tp,att) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then

		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,att)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		s.PlayerHint(e,tp,7)
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
	if num then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_SKIP_M1)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.indcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.indtg(e,c)
	return c:IsType(TYPE_SPIRIT) or c:IsSetCard(0x6240)
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end

function s.efilter2(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsType(TYPE_SPIRIT) and s.indcon(e)
end

function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+2)==0 end
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
			and Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND	+LOCATION_MZONE,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
			end
		end
	end
	--return hand
	--Debug.Message(1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTarget(s.reptg)
	e1:SetValue(s.repval)
	Duel.RegisterEffect(e1,tp)
	s.PlayerHint(e,tp,8)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,2)
	Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
end
function s.sumfilter(c,e,tp)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_SPIRIT)
		and not c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end



function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD)
		and c:GetDestination()==LOCATION_DECK and (c:IsSetCard(0x6240) 
		or (c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SPIRIT))) and c:IsAbleToHand()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	if true then
		local g=eg:Filter(s.repfilter,nil,tp)
		--local ct=g:GetCount()
		--if ct>1 then
		--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		--	g=g:Select(tp,1,ct,nil)
		--end
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_DECK_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id,RESET_EVENT+0x11e0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function s.repval(e,c)
	return false
end
function s.repthfilter(c)
	return c:GetFlagEffect(repcode)==0 and c:GetFlagEffect(id)~=0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.repthfilter,1,nil)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.repthfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(id)
		tc=g:GetNext()
	end
	Duel.ShuffleHand(tp)
end

function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,supercode)>0 and ep~=tp
end

function s.sphandcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,supercode)<=0 or Duel.GetCurrentChain()<=0 then return false end
	local tp=e:GetHandler():GetControler()
	local p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER)
	return Duel.GetFlagEffect(tp,supercode)>0 and p~=tp
end