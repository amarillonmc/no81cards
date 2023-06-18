--天璀司·早临
local m=82209088
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(0x12)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetCondition(cm.spcon)  
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)  
	--enable
	
	--to hand 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_COIN)  
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_SUMMON_SUCCESS) 
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--to hand 2 
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,1))  
	e5:SetCategory(CATEGORY_TOHAND)  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetCode(EVENT_BATTLE_START)  
	e5:SetCondition(cm.thcon2)  
	e5:SetTarget(cm.thtg2)  
	e5:SetOperation(cm.thop2)  
	c:RegisterEffect(e5)  
end
cm.toss_coin=true  

--special summon
function cm.spfilter(c)
	return c:IsDiscardable(REASON_COST)
end
function cm.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,c)
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,c)  
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetReset(RESET_EVENT+0x47e0000)  
	e1:SetValue(LOCATION_REMOVED)  
	c:RegisterEffect(e1,true)  
end  

--enable

--to hand
function cm.thfilter(c)
	return c:IsSetCard(0x9298) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp) 
	local coin
	if Duel.IsPlayerAffectedByEffect(tp,82209091) and Duel.GetFlagEffect(tp,82219091)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,82209091)
		coin=1
		Duel.RegisterFlagEffect(tp,82219091,RESET_PHASE+PHASE_END,0,1)
	else
		coin=Duel.TossCoin(tp,1)
	end
	if coin~=1 then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end  
end  

--to hand 2
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return bc and bc:IsLevelAbove(7) and bc:IsFaceup()
end  
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc:IsAbleToHand() end 
	local g=Group.FromCards(bc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end  
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)  
	local bc=e:GetHandler():GetBattleTarget()  
	if bc:IsRelateToBattle() then  
		Duel.SendtoHand(bc,tp,REASON_EFFECT)
	end  
end  