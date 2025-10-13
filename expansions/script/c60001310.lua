--奇锋厄川·邓艾
local cm,m,o=GetID()
		
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	
	if not cm.check then 
		cm.check=1
		local exe=Effect.CreateEffect(c)
		exe:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		exe:SetCode(EVENT_PREDRAW)
		exe:SetCountLimit(1)
		exe:SetOperation(cm.retop)
		Duel.RegisterEffect(exe,tp)
	end
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.dcon)
	e2:SetTarget(cm.dtg)
	e2:SetOperation(cm.dop)
	c:RegisterEffect(e2)
end
--random
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g~=0 end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(#Duel.GetOperatedGroup())
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function cm.filter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsSummonable(false,nil)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:GetActivateEffect():IsActivatable(tp))
end
function cm.dfil(c)
	return c:IsType(TYPE_MONSTER) and c:GetBaseAttack()~=0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local i=math.random(12,13)
	Duel.Hint(24,0,aux.Stringid(60001310,i))
	
	local item=math.min(e:GetLabel(),3)
	if not item or item==0 then return end
	local choice={true,true,true}
	local ex=0
	local close=0
	for i=1,item do
		if close==1 then return end
		local op=aux.SelectFromOptions(tp,
				{choice[1],aux.Stringid(m,2)},
				{choice[2],aux.Stringid(m,3)},
				{choice[3],aux.Stringid(m,4)},
				{true,aux.Stringid(m,5)})
		if op==1 then
			local g=Duel.GetDecktopGroup(tp,1+ex)
			local g2=Duel.GetDecktopGroup(1-tp,1+ex)
			g:Merge(g2)
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1+ex,nil)
			if Duel.Destroy(g,REASON_EFFECT)~=0 then
				local sg=Duel.GetOperatedGroup():Filter(cm.dfil,nil)
				if sg then 
					local damage=sg:GetSum(Card.GetBaseAttack)/2
					Duel.Damage(1-tp,damage,REASON_EFFECT)
				end
			end
		elseif op==3 then
			local closeloc=0
			local checkloc={true,true,true,true}
			for i=1,1+ex do
				if closeloc==1 then return end
				local b1=checkloc[1] and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil)
				local b2=checkloc[2] and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
				local b3=checkloc[3] and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil)
				local b4=checkloc[4] and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_GRAVE,1,nil)
				local lop=aux.SelectFromOptions(tp,
					{b1,aux.Stringid(m,6)},
					{b2,aux.Stringid(m,7)},
					{b3,aux.Stringid(m,8)},
					{b4,aux.Stringid(m,9)},
					{true,aux.Stringid(m,5)})
				local loc=0
				if lop==1 then
					loc=LOCATION_HAND
				elseif lop==2 then
					loc=LOCATION_ONFIELD
				elseif lop==3 then
					loc=LOCATION_DECK
				elseif lop==4 then
					loc=LOCATION_GRAVE
				elseif lop==5 then
					closeloc=1
				end
				if closeloc==1 then return end
				local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,loc,nil):RandomSelect(tp,1)
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				if loc==LOCATION_HAND then Duel.ShuffleHand(1-tp) end
				checkloc[lop]=false
			end
		elseif op==4 then
			close=1
		end
		ex=ex+1
		choice[op]=false
	end
	if item==3 then Duel.ResetFlagEffect(tp,m) end
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local exe=Effect.CreateEffect(e:GetHandler())
	exe:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	exe:SetCode(EVENT_ADJUST)
	exe:SetLabel(Duel.GetLP(1-e:GetHandlerPlayer()))
	exe:SetOperation(cm.lbtop)
	exe:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(exe,tp)
end
function cm.lbtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(1-e:GetHandlerPlayer())~=e:GetLabel() then
		Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
		e:Reset()
	end
end


function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetFlagEffect(tp,m+10000000)~=0
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m+20000000)==0 end
	Duel.RegisterFlagEffect(tp,m+20000000,0,0,1)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local i=math.random(14,15)
	Duel.Hint(24,0,aux.Stringid(60001310,i))
	
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		--damage reduce
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_REPLACE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.damval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetOperation(cm.ndop)
		Duel.RegisterEffect(e3,tp)
		local ee1=Effect.CreateEffect(c)
		ee1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ee1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		ee1:SetCountLimit(1)
		ee1:SetOperation(cm.llop)
		Duel.RegisterEffect(ee1,tp)
	end
end
function cm.ndop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(e:GetHandlerPlayer(),m+30000000)~=0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.ResetFlagEffect(e:GetHandlerPlayer(),m+30000000)
		Duel.Draw(e:GetHandlerPlayer(),1,REASON_EFFECT)
		local i=math.random(14,15)
		Duel.Hint(24,0,aux.Stringid(60001310,i))
	end
end

function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m+30000000,0,0,1)
		return 0
	end
	return val
end
function cm.llop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)

	local i=math.random(14,15)
	Duel.Hint(24,0,aux.Stringid(60001310,i))
	
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
	local sg=g:Filter(cm.sgfil,nil)
	if #sg~=0 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		Duel.SetLP(tp,Duel.GetLP(tp)-2000*#Duel.GetOperatedGroup())
	else
		Duel.ResetFlagEffect(tp,m+20000000)
	end
end
function cm.sgfil(c)
	return (c:IsType(TYPE_MONSTER) and c:IsSummonable(false,nil)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetActivateEffect():IsActivatable(tp))
end





