--源于黑影 气流
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(s.condition1)
	c:RegisterEffect(e0)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e10:SetCondition(s.condition2)
	c:RegisterEffect(e10)
	--正面【表】
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(s.condition)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--反面【表】
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetCondition(s.condition2)
	e11:SetCost(s.rmcost1)
	e11:SetTarget(s.damtg1)
	e11:SetOperation(s.rmop1)
	c:RegisterEffect(e11)
	--正面【里】
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.condition1)
	e2:SetCost(s.rmcost1)
	e2:SetTarget(s.damtg1)
	e2:SetOperation(s.rmop1)
	c:RegisterEffect(e2)
	--反面【里】
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_ACTIVATE)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e21:SetCondition(s.condition3)
	e21:SetCost(s.rmcost)
	e21:SetTarget(s.damtg)
	e21:SetOperation(s.rmop)
	c:RegisterEffect(e21)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+65820010)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.condition4)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.damtg1)
	e3:SetOperation(s.rmop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+65820010)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.condition5)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
end

s.effect_lixiaoguo=true

--正面【表】
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return math.max(Duel.GetFlagEffect(tp,65820099)-Duel.GetFlagEffect(tp,65820100),0)==0 and c:GetFlagEffect(65820010)==0
end
--反面【表】
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return math.max(Duel.GetFlagEffect(tp,65820099)-Duel.GetFlagEffect(tp,65820100),0)==0 and c:GetFlagEffect(65820010)>0
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(65820010)==0 and eg:IsExists(Card.IsPreviousControler,1,nil,tp)
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	local lp=Duel.GetLP(tp)
	if lp>=800 then
		Duel.PayLPCost(tp,800,REASON_COST)
	else
		Duel.PayLPCost(tp,lp,REASON_COST)
	end
	if Duel.GetLP(tp)<=0 then
		Duel.SetLP(tp,4000)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_COST,tp,tp,4000)
	end
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
end
function s.thfilter(c)
	return c.effect_lixiaoguo
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		--翻面
		Duel.ConfirmCards(1-tp,tc)
		if tc:GetFlagEffect(65820010)==0 then 
			tc:RegisterFlagEffect(65820010,0,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820010,1))		
		else
			tc:ResetFlagEffect(65820010)
		end
		Duel.RaiseEvent(tc,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
	end
	
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local count=math.max(Duel.GetFlagEffect(p,65820099)-Duel.GetFlagEffect(p,65820100),0)
	if count>=10 or not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	for i=0,10,1 do
		Duel.ResetFlagEffect(p,EFFECT_FLAG_EFFECT+65820000+i)
	end
	Duel.RegisterFlagEffect(p,65820099,0,0,1)
	local count1=math.max(Duel.GetFlagEffect(p,65820099)-Duel.GetFlagEffect(p,65820100),0)
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count1))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count1)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,p)
end


--正面【里】
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return math.max(Duel.GetFlagEffect(tp,65820099)-Duel.GetFlagEffect(tp,65820100),0)>0 and c:GetFlagEffect(65820010)==0
end
--反面【里】
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return math.max(Duel.GetFlagEffect(tp,65820099)-Duel.GetFlagEffect(tp,65820100),0)>0 and c:GetFlagEffect(65820010)>0
end
function s.condition5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(65820010)>0 and eg:IsExists(Card.IsPreviousControler,1,nil,tp)
end
function s.rmcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	for i=0,10,1 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	Duel.RegisterFlagEffect(tp,65820100,0,0,1)
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-Duel.GetFlagEffect(tp,65820100),0)
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end
function s.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function s.rmop1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		while tc do
			if tc:GetFlagEffect(65820010)==0 then 
				tc:RegisterFlagEffect(65820010,0,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820010,1))		
			else 
				tc:ResetFlagEffect(65820010)
			end
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
		
		Duel.SetLP(tp,Duel.GetLP(tp)-g:GetCount()*1000)
		if Duel.GetLP(tp)<=0 then
			Duel.SetLP(tp,4000)
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
		end
	end
end