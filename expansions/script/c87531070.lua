--新春破魔焰
function c87531070.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),7,2,c87531070.ovfilter,aux.Stringid(87531070,0),2,c87531070.xyzop)
	c:EnableReviveLimit()
	--remove material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87531070,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c87531070.rmcon)
	e1:SetTarget(c87531070.rmtg)
	e1:SetOperation(c87531070.rmop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87531070,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,87531070)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c87531070.tga)
	e2:SetOperation(c87531070.opa)
	c:RegisterEffect(e2)
	--change target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87531070,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,87531071)
	e3:SetCondition(c87531070.tgcon1)
	e3:SetOperation(c87531070.tgop1)
	c:RegisterEffect(e3)
	if not c87531070.global_check then
		c87531070.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(c87531070.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c87531070.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c87531070.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,87531070)>0 and Duel.GetFlagEffect(tp,87531071)==0 end
	Duel.RegisterFlagEffect(tp,87531071,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c87531070.checkop(e,tp,eg,ep,ev,re,r,rp)
	--local dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER)
	Duel.RegisterFlagEffect(ep,87531070,RESET_PHASE+PHASE_END,0,1)
end
function c87531070.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c87531070.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c87531070.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function c87531070.filter(c,cod)
	return c:IsOriginalCodeRule(cod) and c:IsAbleToHand()
end
function c87531070.filtera(c,tp)
	local cod=c:GetOriginalCode()
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(c87531070.filter,tp,LOCATION_DECK,0,1,nil,cod)
end
function c87531070.tga(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c87531070.filtera(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c87531070.filtera,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local g=Duel.SelectTarget(tp,c87531070.filtera,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87531070.opa(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c87531070.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetOriginalCode())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g) 
		end
	end
end
function c87531070.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc==c or not tc:IsLocation(LOCATION_ONFIELD) then return false end
	return Duel.CheckChainTarget(ev,c)
end
function c87531070.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.CheckChainTarget(ev,c) then
			local g=Group.CreateGroup()
			g:AddCard(c)
			if Duel.ChangeTargetCard(ev,g)~=0 and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and rc:IsCanOverlay() and c:IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(87531070,4)) then 
			rc:CancelToGrave()
			Duel.Overlay(c,Group.FromCards(rc))
			end
		end
	end
end