--罗德岛·医疗干员-清流
function c79029175.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c79029175.drtg)
	e1:SetOperation(c79029175.drop)
	c:RegisterEffect(e1)  
	--serch
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029175)
	e2:SetCost(c79029175.srcost)
	e2:SetTarget(c79029175.srtg)
	e2:SetOperation(c79029175.srop)
	c:RegisterEffect(e2)  
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029175.splimit)
	c:RegisterEffect(e2) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65518099,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029175.thcost1)
	e3:SetTarget(c79029175.thtg1)
	e3:SetOperation(c79029175.thop1)
	c:RegisterEffect(e3) 
end
function c79029175.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029175.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c79029175.drop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("突击检查！抓住那个往水槽里倒颜料的家伙！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029175,1))
	Duel.Draw(tp,1,REASON_EFFECT)
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	if dc:IsType(TYPE_MONSTER) then
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	if dc:IsType(TYPE_MONSTER) then
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	end
end
function c79029175.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function c79029175.srfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa900) and c:IsAbleToRemove()
end
function c79029175.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029175.srfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c79029175.srop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("罗德岛治污小队，出发！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029175,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79029175.srfil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc==nil then return end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	tc:RegisterFlagEffect(79029175,RESET_EVENT+RESETS_STANDARD,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	e1:SetCondition(c79029175.thcon)
	e1:SetOperation(c79029175.thop)
	e1:SetLabel(0)
	tc:RegisterEffect(e1)
end
function c79029175.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Recover(tp,e:GetHandler():GetAttack(),REASON_EFFECT)
	else e:SetLabel(1) end
end
function c79029175.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function c79029175.thfil1(c,lsc,rsc)
	local lv=c:GetLevel()
	return c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and lv>lsc and lv<rsc 
end
function c79029175.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)~=2 then return false end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if chk==0 then return Duel.IsExistingMatchingCard(c79029175.thfil1,tp,LOCATION_DECK,0,1,nil,lsc,rsc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029175.thop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)~=2 then return end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Debug.Message("责任重大呀......我会努力的！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029175,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029175.thfil1,tp,LOCATION_DECK,0,1,1,nil,lsc,rsc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end












