--替身使者-丹尼尔·J·达比
function c9300329.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
   --Coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9300329,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+EFFECT_TYPE_SINGLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9300329)
	e1:SetTarget(c9300329.mattg)
	e1:SetOperation(c9300329.mtop)
	c:RegisterEffect(e1)
	--Toss Again
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetCondition(c9300329.coincon)
	e2:SetOperation(c9300329.coinop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9300329.imcon)
	e3:SetValue(c9300329.efilter)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	--attack limit
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e6)
   --to hand/spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9300329,2))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,9302329)
	e5:SetCondition(c9300329.recon)
	e5:SetTarget(c9300329.regtg)
	e5:SetOperation(c9300329.regop)
	c:RegisterEffect(e5)
end
c9300329.pendulum_level=4
function c9300329.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	c:RegisterFlagEffect(9300329,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9300329.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
		local coin=Duel.AnnounceCoin(tp)
		local res=Duel.TossCoin(tp,1)
		if coin~=res then
			if g:GetCount()>0 then
			   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
			   local sg=g:Select(1-tp,1,1,nil)
			   Duel.HintSelection(sg)
			   Duel.Overlay(c,sg)
			end
		else
			local og=e:GetHandler():GetOverlayGroup()
			if og:GetCount()>0 
			   then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			   local bg=og:Select(tp,1,1,nil)
			   Duel.SendtoDeck(bg,nil,2,REASON_EFFECT)
			else
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
	end
c9300329.toss_coin=true
function c9300329.coincon(e,tp,eg,ep,ev,re,r,rp)
local ph=Duel.GetCurrentPhase()
	return ep==tp and Duel.GetFlagEffect(tp,9301329)==0 and e:GetHandler():GetFlagEffect(9300329)>0 and ph==PHASE_STANDBY
			and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c9300329.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9301329)~=0 then return end
	if  Duel.SelectYesNo(tp,aux.Stringid(9300329,0)) then
		Duel.Hint(HINT_CARD,0,9300329)
		Duel.RegisterFlagEffect(tp,9301329,RESET_PHASE+PHASE_END,0,1)
		Duel.TossCoin(tp,ev)
	end
end
function c9300329.matfil(c,e)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c9300329.imcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c9300329.matfil,1,nil,e)
end
function c9300329.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function c9300329.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c9300329.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9300329.thfilter(c)
	return c:IsLevelBelow(6) and c:IsSetCard(0x1f99) and c:IsType(TYPE_MONSTER) and c:GetCode()~=9300329 and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9300329.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9300329.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9300329.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c9300329.thcon)
	e1:SetOperation(c9300329.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9300329.thfilter2(c)
	return c9300329.thfilter(c) and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c9300329.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9300329.thfilter2,tp,LOCATION_DECK,0,1,nil)
end
function c9300329.thop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_CARD,0,9300329)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c9300329.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,res):GetFirst()
	if tc then
		if tc:GetLeftScale()==9 and res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

