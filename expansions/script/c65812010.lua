--狂风呼啸
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65812000)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(s.excondition)
	e0:SetDescription(aux.Stringid(id,2))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not PNFL_LOCATION_CHECK then
		PNFL_LOCATION_CHECK=true
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_MOVE)
		ge6:SetCondition(s.condition)
		ge6:SetOperation(s.checkop6)
		Duel.RegisterEffect(ge6,true)
	end
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,5))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.locfilter,1,nil)
end
function s.checkop6(e,tp,eg,ep,ev,re,r,rp)
	eg:IsExists(s.locfilter,1,nil)
	local tg=Duel.GetMatchingGroup(s.locfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(65812010,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65812010,3))
		end
	end
end
function s.locfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousLocation()~=c:GetLocation()) 
		and c:GetFlagEffect(65812010)==0
end


function s.exfilter(c)
	return c:IsCode(65812000) and c:IsFaceup()
end
function s.excondition(e)
	return Duel.IsExistingMatchingCard(s.exfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end


function s.filter(c)
	return not c:IsLocation(LOCATION_FZONE) and not c:IsLocation(LOCATION_PZONE) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function s.get(c,e)
	return not c:IsImmuneToEffect(e) and c:GetSequence()<=4 and not c:IsLocation(LOCATION_PZONE)
end
function s.shfilter(c)
	return c:GetFlagEffect(65812010)>0
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(id,0)},
			{true,aux.Stringid(id,1)})
	local a=0
	local rsg=0
	if Duel.IsExistingMatchingCard(s.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then a=1 end
	if op==2 then
		local g=Duel.GetMatchingGroup(s.get,tp,LOCATION_MZONE,0,nil,e)
		local num1=g:GetCount()
		local g2=Duel.GetMatchingGroup(s.get,1-tp,LOCATION_MZONE,0,nil,e)
		local num2=g2:GetCount()
		local g3=Duel.GetMatchingGroup(s.get,tp,LOCATION_SZONE,0,nil,e)
		local num3=g3:GetCount()
		local g4=Duel.GetMatchingGroup(s.get,1-tp,LOCATION_SZONE,0,nil,e)
		local num4=g4:GetCount()
		for i=1,num1 do
			local sg=g:Clone()
			for tc in aux.Next(sg) do
				local seq=tc:GetSequence()
				if seq~=4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then
					Duel.MoveSequence(tc,seq+1)
					g:RemoveCard(tc)
					rsg=rsg+1
				end
			end
		end
		for i=1,num2 do
			local sg2=g2:Clone()
			for tc in aux.Next(sg2) do
				local seq=tc:GetSequence()
				if seq~=4 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq+1) then
					Duel.MoveSequence(tc,seq+1)
					g2:RemoveCard(tc)
					rsg=rsg+1
				end
			end
		end
		for i=1,num3 do
			local sg3=g3:Clone()
			for tc in aux.Next(sg3) do
				local seq=tc:GetSequence()
				if seq~=4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq+1) then
					Duel.MoveSequence(tc,seq+1)
					g3:RemoveCard(tc)
					rsg=rsg+1
				end
			end
		end
		for i=1,num4 do
			local sg4=g4:Clone()
			for tc in aux.Next(sg4) do
				local seq=tc:GetSequence()
				if seq~=4 and Duel.CheckLocation(1-tp,LOCATION_SZONE,seq+1) then
					Duel.MoveSequence(tc,seq+1)
					g4:RemoveCard(tc)
					rsg=rsg+1
				end
			end
		end
	elseif op==1 then
		local g=Duel.GetMatchingGroup(s.get,tp,LOCATION_MZONE,0,nil,e)
		local num1=g:GetCount()
		local g2=Duel.GetMatchingGroup(s.get,1-tp,LOCATION_MZONE,0,nil,e)
		local num2=g2:GetCount()
		local g3=Duel.GetMatchingGroup(s.get,tp,LOCATION_SZONE,0,nil,e)
		local num3=g3:GetCount()
		local g4=Duel.GetMatchingGroup(s.get,1-tp,LOCATION_SZONE,0,nil,e)
		local num4=g4:GetCount()
		for i=1,num1 do
			local sg=g:Clone()
			for tc in aux.Next(sg) do
				local seq=tc:GetSequence()
				if seq~=0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then
					Duel.MoveSequence(tc,seq-1)
					g:RemoveCard(tc)
					rsg=rsg+1
				end
			end
		end
		for i=1,num2 do
			local sg2=g2:Clone()
			for tc in aux.Next(sg2) do
				local seq=tc:GetSequence()
				if seq~=0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq-1) then
					Duel.MoveSequence(tc,seq-1)
					g2:RemoveCard(tc)
					rsg=rsg+1
				end
			end
		end
		for i=1,num3 do
			local sg3=g3:Clone()
			for tc in aux.Next(sg3) do
				local seq=tc:GetSequence()
				if seq~=0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1) then
					Duel.MoveSequence(tc,seq-1)
					g3:RemoveCard(tc)
					rsg=rsg+1
				end
			end
		end
		for i=1,num4 do
			local sg4=g4:Clone()
			for tc in aux.Next(sg4) do
				local seq=tc:GetSequence()
				if seq~=0 and Duel.CheckLocation(1-tp,LOCATION_SZONE,seq-1) then
					Duel.MoveSequence(tc,seq-1)
					g4:RemoveCard(tc)
					rsg=rsg+1
				end
			end
		end
	end
	if rsg>0 and a>0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if sc:IsFaceup() and sc:IsCanBeDisabledByEffect(e,false) then
			Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			sc:RegisterEffect(e2)
			if sc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				sc:RegisterEffect(e3)
			end
		end
	end
end

function s.cfilter(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	local code1,code2=c:GetPreviousCodeOnField()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and (code1==65812000 or code2==65812000)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,se) and not eg:IsContains(e:GetHandler())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end