--蚀茧骆驼
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771001.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetDescription(aux.Stringid(53771001,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetCountLimit(1,53771001)
	e1:SetCondition(c53771001.thcon)
	e1:SetCost(c53771001.thcost)
	e1:SetTarget(c53771001.thtg)
	e1:SetOperation(c53771001.thop)
	c:RegisterEffect(e1)
	--spsummon-self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53771001,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	--e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e2:SetTarget(c53771001.spstg)
	e2:SetOperation(c53771001.spsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,53771001)
	e3:SetCondition(c53771001.spscon)
	c:RegisterEffect(e3)
	c53771001.gravetop_effect=e2
end
function c53771001.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(53771001)==0
end
function c53771001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(c)
		e0:SetCountLimit(1)
		e0:SetOperation(c53771001.retop)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(53771001,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(53771001)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e1)
	end
end
function c53771001.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject(),POS_FACEDOWN_DEFENSE)
end
function c53771001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	e:GetHandler():RegisterFlagEffect(53771001,RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE-RESET_REMOVE-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53771001,0))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c53771001.thfilter(c,g)
	return c:IsAbleToHand() and not c:IsLocation(LOCATION_HAND) and g:IsExists(c53771001.tgfilter,1,nil)
end
function c53771001.tgfilter(c)
	return c:IsSetCard(0xa53b) and c:IsAbleToGrave()
end
function c53771001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()==0 then return end
	g:Merge(Duel.GetMatchingGroup(c53771001.tgfilter,tp,LOCATION_HAND,0,nil))
	if g:IsExists(c53771001.thfilter,1,nil,g) and Duel.SelectYesNo(tp,aux.Stringid(53771001,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c53771001.thfilter,1,1,nil,g)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:FilterSelect(tp,c53771001.tgfilter,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c53771001.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)==e:GetHandler()
end
function c53771001.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=c:IsRelateToChain() and c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if not (b1 or b2) then return end
	Duel.Hint(HINT_CARD,0,53771001)
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(53771001,3),1152)==0) then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
