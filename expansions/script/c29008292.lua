--方舟骑士-苇草·焰影
c29008292.named_with_Arknight=1
function c29008292.initial_effect(c)
	aux.AddCodeList(c,29091651)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c29008292.splimit)
	c:RegisterEffect(e0)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29008292,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_RECOVER)
	e2:SetCountLimit(1,29008292)
	e2:SetCondition(c29008292.thcon)
	e2:SetCost(c29008292.thcost)
	e2:SetTarget(c29008292.thtg)
	e2:SetOperation(c29008292.thop)
	c:RegisterEffect(e2)
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29008292,2))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,29008293)
	e1:SetCondition(c29008292.necon)
	e1:SetTarget(c29008292.netg)
	e1:SetOperation(c29008292.neop)
	c:RegisterEffect(e1)
c29008292.assault_name=29025585
end
function c29008292.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return (sc:IsSetCard(0x87af) or (_G["c"..sc:GetCode()] and  _G["c"..sc:GetCode()].named_with_Arknight)) 
end
function c29008292.necon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c29008292.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	if dam<0 then dam=0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,dam)
end
function c29008292.neop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local dam=e:GetHandler():GetAttack()
		Duel.Damage(1-tp,dam,REASON_EFFECT)
		Duel.Recover(tp,dam,REASON_EFFECT)
	end
end
--
function c29008292.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c29008292.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c29008292.thfilter(c)
	return c:IsCode(29091651) and c:IsAbleToHand()
end
function c29008292.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29008292.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,800)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29008292.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,800,REASON_EFFECT)<=0 then return end
		if Duel.IsExistingMatchingCard(c29008292.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29008292,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c29008292.thfilter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				end
		end
end