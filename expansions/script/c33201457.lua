--混沌圣堂的行刑官
local s,id,o=GetID()
Duel.LoadScript("c33201450.lua")
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,VHisc_HDST.nck,2,2)
	c:EnableReviveLimit()
	--Position+Negate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetLabel(0)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.VHisc_hdst=true

function s.filter(c)
	return c:IsFaceup() and not c:IsAttack(0)
end
function s.setfilter(c)
	return VHisc_HDST.nck(c) and not c:IsForbidden()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local og=e:GetHandler():GetOverlayGroup()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and not chkc:IsAttack(0) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and og:FilterCount(s.setfilter,nil)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=Duel.GetFirstTarget()
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,nil)
	if VHisc_HDST.nck(tc) then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local og=e:GetHandler():GetOverlayGroup():Filter(s.setfilter,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and og:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=og:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(24,0,aux.Stringid(id,0))
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsAttack(0) and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if e:GetLabel()==1 then 
				local c=e:GetHandler()
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetValue(RESET_TURN_SET)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	end
end


--e3
function s.thfilter(c)
	return VHisc_HDST.nck(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(24,0,aux.Stringid(id,1))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end