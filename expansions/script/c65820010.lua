--源于黑影 气流
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,4))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(s.qpcon)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.maintg)
	e1:SetOperation(s.mainop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+65820010)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.maincon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.maintg)
	e2:SetOperation(s.mainop)
	c:RegisterEffect(e2)
end

s.effect_lixiaoguo=true

function s.qpcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,65820099)==0
end

function s.flip_card(c)
	if c:GetFlagEffect(65820010)==0 then
		c:RegisterFlagEffect(65820010,0,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820010,1))
	else
		c:ResetFlagEffect(65820010)
	end
end

function s.gain_use_counter(e,tp)
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099),0)
	if count>=10 then return end
	Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	local count1=count+1
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count1))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count1)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end

function s.consume_use_counter(e,tp)
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
	Duel.ResetFlagEffect(tp,65820099)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	end
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end

function s.thfilter(c)
	return c.effect_lixiaoguo
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local has_use=Duel.GetFlagEffect(tp,65820099)>0
	local is_flipped=e:GetHandler():GetFlagEffect(65820010)>0

	local need_pay=(not has_use and not is_flipped) or (has_use and is_flipped)
	if chk==0 then
		if need_pay then return true end
		return true
	end
	if need_pay then
		local lp=Duel.GetLP(tp)
		if lp>=2000 then
			Duel.PayLPCost(tp,2000,REASON_COST)
		else
			Duel.PayLPCost(tp,lp,REASON_COST)
		end
		if Duel.GetLP(tp)<=0 then
			Duel.SetLP(tp,4000)
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
		end
	end
end

function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local has_use=Duel.GetFlagEffect(tp,65820099)>0
	local is_flipped=c:GetFlagEffect(65820010)>0

	if (has_use and not is_flipped) or (not has_use and is_flipped) then
		if chk==0 then
			return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		end
		if has_use then s.consume_use_counter(e,tp) end
		e:SetLabel(1)
	else
		if chk==0 then
			return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
		end
		if has_use then s.consume_use_counter(e,tp) end
		e:SetLabel(2)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
	end
end

function s.mainop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if label==1 then
		if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,99,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			for tc in aux.Next(g) do
				s.flip_card(tc)
			end
			Duel.RaiseEvent(g,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
			Duel.SetLP(tp,Duel.GetLP(tp)-#g*1000)
			if Duel.GetLP(tp)<=0 then
				Duel.SetLP(tp,4000)
				Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
			end
		end
	else
		if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil):GetFirst()
		if not tc then return end
		Duel.ConfirmCards(1-tp,tc)
		s.flip_card(tc)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			s.gain_use_counter(e,p)
		end
	end
end

function s.maincon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x3a32)
end