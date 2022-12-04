--渡 神 水 桥 帕 露 西
local m=22348120
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c22348120.ovfilter,aux.Stringid(22348120,0),99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348120,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e1:SetCode(EVENT_DETACH_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c22348120.atktg)
	e1:SetOperation(c22348120.atkop)
	c:RegisterEffect(e1)
	--RECOVER
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348120,2))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c22348120.recon)
	e2:SetTarget(c22348120.retg)
	e2:SetOperation(c22348120.reop)
	c:RegisterEffect(e2)
end
function c22348120.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x704) and c:IsLevel(4)
end
function c22348120.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c22348120.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	local aa=math.abs(tc:GetAttack()-c:GetAttack())
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(aa)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	local d=math.floor(aa/1200)
	Duel.Draw(tp,d,REASON_EFFECT)
	end
	end
end
function c22348120.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c22348120.refilter(c)
	return c:IsSetCard(0x704) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22348120.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local aaaa=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	if chk==0 then return aaaa>0 and Duel.IsExistingMatchingCard(c22348120.refilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetTargetParam(aaaa)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,aaaa)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348120.reop(e,tp,eg,ep,ev,re,r,rp)
	local aaaa=math.floor(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))/2)
	Duel.Recover(tp,aaaa,REASON_EFFECT)
	if aaaa>0 then
	   Duel.BreakEffect()
	   local g=Duel.GetMatchingGroup(c22348120.refilter,tp,LOCATION_DECK,0,nil)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   if g:CheckWithSumEqual(Card.GetAttack,aaaa,1,99) then
		 local sg=g:SelectWithSumEqual(tp,Card.GetAttack,aaaa,1,99)
		 if sg and sg:GetCount()>0 then
		   Duel.SendtoHand(sg,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,sg)
		 end
	   else
	   local tg=Duel.SelectMatchingCard(tp,c22348120.refilter,tp,LOCATION_DECK,0,1,1,nil)
	   if tg:GetCount()>0 then
		   Duel.SendtoHand(tg,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,tg)
	   end
	   end
	end
end






















