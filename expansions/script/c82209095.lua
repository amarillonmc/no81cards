--天璀司·升汰人
local m=82209095
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO)),1)  
	c:EnableReviveLimit()  
	--spsummon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(aux.synlimit)  
	c:RegisterEffect(e0)  
	--disable summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCode(EVENT_SUMMON)  
	e1:SetCost(cm.discost)
	e1:SetCondition(cm.discon) 
	e1:SetTarget(cm.distg)  
	e1:SetOperation(cm.disop)  
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_COIN+CATEGORY_DAMAGE+CATEGORY_RECOVER)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)  
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.damcost)  
	e4:SetTarget(cm.damtg)  
	e4:SetOperation(cm.damop)  
	c:RegisterEffect(e4)  
	--to hand 2 
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,3))  
	e5:SetCategory(CATEGORY_TOHAND)  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetCode(EVENT_BATTLE_START)  
	e5:SetCondition(cm.thcon2)  
	e5:SetTarget(cm.thtg2)  
	e5:SetOperation(cm.thop2)  
	c:RegisterEffect(e5)  
end
cm.toss_coin=true 

--disable summon
function cm.filter(c,tp)  
	return c:GetSummonPlayer()==tp  
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentChain()==0 and eg:IsExists(cm.filter,1,nil,1-tp)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local g=eg:Filter(cm.filter,nil,1-tp)  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	local g=eg:Filter(cm.filter,nil,1-tp)  
	Duel.NegateSummon(g)  
	Duel.SendtoHand(g,tp,REASON_EFFECT)  
end  

--damage
function cm.damfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsSetCard(0x9298) or c:GetControler()~=c:GetOwner())
end
function cm.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.damfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.damfilter,tp,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()>0 then
		e:SetLabel(Duel.Remove(g,POS_FACEUP,REASON_COST))
	end
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*1000)   
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local coin
	if Duel.IsPlayerAffectedByEffect(tp,82209091) and Duel.GetFlagEffect(tp,82219091)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,82209091)
		coin=1
		Duel.RegisterFlagEffect(tp,82219091,RESET_PHASE+PHASE_END,0,1)
	else
		coin=Duel.TossCoin(tp,1)
	end
	local ct=e:GetLabel()
	local dam=Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
	if coin==1 and dam>0 then  
		Duel.Recover(tp,dam,REASON_EFFECT)
	end
end

--to hand 2
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return bc
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