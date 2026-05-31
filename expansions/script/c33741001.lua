--温和通感
local s,id,o=GetID()
s.cur={[0]=0,[1]=0}
s.prev={[0]=0,[1]=0}
function s.initial_effect(c)
	--Activate from hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(s.damop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.turnop)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if (rp==0 or rp==1) and ep==1-rp then
		s.cur[rp]=1
	end
end
function s.turnop(e,tp,eg,ep,ev,re,r,rp)
	s.prev[0]=s.cur[0]
	s.prev[1]=s.cur[1]
	s.cur[0]=0
	s.cur[1]=0
end
function s.handcon(e)
	return s.prev[e:GetHandlerPlayer()]==0
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.repfilter(c,tc,rg)
	return c:IsType(TYPE_MONSTER) and not rg:IsContains(c)
		and c:IsAttribute(tc:GetAttribute()) and c:IsRace(tc:GetRace())
		and c:GetAttack()==tc:GetAttack() and c:GetDefense()==tc:GetDefense()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg={[0]=Group.CreateGroup(),[1]=Group.CreateGroup()}
	local p=tp
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.ConfirmCards(1-tp,tc)
	rg[tp]:AddCard(tc)
	local ct=1
	local ref=tc
	p=1-tp
	while ct<20 and Duel.IsExistingMatchingCard(s.repfilter,p,LOCATION_DECK,0,1,nil,ref,rg[p])
		and Duel.SelectYesNo(p,aux.Stringid(id,0)) do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CONFIRM)
		local sg=Duel.SelectMatchingCard(p,s.repfilter,p,LOCATION_DECK,0,1,1,nil,ref,rg[p])
		local sc=sg:GetFirst()
		if not sc then break end
		Duel.ConfirmCards(1-p,sc)
		rg[p]:AddCard(sc)
		ref=sc
		ct=ct+1
		p=1-p
	end
	if ct==1 then
		Duel.SendtoHand(rg[tp],nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg[tp])
	end
	if ct>=2 then
		for i=0,1 do
			local rc=rg[i]:GetCount()
			if rc>0 then
				Duel.Recover(i,rc*300,REASON_EFFECT)
			end
		end
	end
	if ct>=4 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
	if ct>=6 then
		for i=0,1 do
			local mg=rg[i]:Filter(Card.IsAbleToHand,nil)
			if mg:GetCount()>0 and Duel.SelectYesNo(i,aux.Stringid(id,1)) then
				Duel.Hint(HINT_SELECTMSG,i,HINTMSG_ATOHAND)
				local sg=mg:Select(i,1,math.min(2,mg:GetCount()),nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-i,sg)
			end
		end
	end
	if ct>=8 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetOperation(s.setop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	for i=0,1 do
		rg[i]:DeleteGroup()
	end
end
function s.setfilter(c)
	return c:IsCode(id) and c:IsSSetable()
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
