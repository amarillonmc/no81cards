--双姬谐奏
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0xca70) then
	Duel.RegisterFlagEffect(rp,id,RESET_CHAIN,0,1)
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,500)
end
function s.thfilter(c)
	return c:IsSetCard(0xca70) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.cfilter(c)
	return c:IsSetCard(0xca70,0x5a70) and c:IsFaceup()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	local c=e:GetHandler()
	if Duel.Recover(tp,500,REASON_EFFECT)>0 and Duel.Recover(1-tp,500,REASON_EFFECT)>0 then
		local ct=Duel.GetFlagEffect(tp,id)
		if cl==1 and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(ct*300)
			e1:SetTargetRange(LOCATION_MZONE,0)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			Duel.RegisterEffect(e2,tp)
		end
		local tg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if cl==3 and tg:GetClassCount(Card.GetCode)>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local sg=tg:SelectSubGroup(tp,aux.dncheck,false,2,2)
			if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			end
		end
		if cl==5 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_ONFIELD,0)
			e1:SetTarget(aux.TargetBoolFunction(s.cfilter))
			e1:SetValue(s.efilter)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
		end
	end
end