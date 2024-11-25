--匹诺康尼-盛会之星-
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.accon)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_FZONE) 
	--e2:SetTarget(cm.srtg) 
	e2:SetOperation(cm.srop) 
	c:RegisterEffect(e2)  
	--local e3=e2:Clone() 
	--e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	--c:RegisterEffect(e3) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end

function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0
end

function cm.srop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.GetFlagEffect(rp,m)==0 then 
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1)
	end 
end 

function cm.fselect(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount()
		and g:GetClassCount(Card.GetAttribute)==g:GetCount()
end

function cm.costfilter(c)
	return c:IsType(TYPE_MONSTER)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND,0,nil,nil)
	return g:CheckSubGroup(cm.fselect,3,99)
end

function cm.rcheck(c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND,0,nil,nil)
	local tf=false
	--if g:CheckSubGroup(cm.fselect,3,99)then
		--g:AddCard(c)
		if g:CheckSubGroup(cm.fselect,3,99) then
			tf=true
		end
	--end
	return tf
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rcheck,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	Duel.ConfirmCards(1-tp,lg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	--选择怪兽--
	local bg=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND,0,nil,nil)
	local g=Group.SelectSubGroup(bg,tp,cm.fselect,0,nil)
	local dg=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_DECK,0,nil,nil)
	local ac=dg:GetFirst()
	local cg=Group.CreateGroup()
	for i=1,#dg do
		g:AddCard(ac)
		if g:GetClassCount(Card.GetRace)==g:GetCount() and g:GetClassCount(Card.GetAttribute)==g:GetCount() then
			cg:AddCard(ac)
			Debug.Message("1")
		end
		g:RemoveCard(ac)
		ac=dg:GetNext()
	end
	local mg=cg:Select(tp,1,1,nil)
	if mg:GetCount()>0 then
		Duel.SendtoHand(mg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	end
end