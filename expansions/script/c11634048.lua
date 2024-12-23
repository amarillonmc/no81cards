--冥府结晶龙
local cm,m=GetID()

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.TRUE,1,2,nil,nil,99)
	c:EnableReviveLimit()
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetOperation(cm.baop)
	c:RegisterEffect(e4)
end

function cm.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,0x1)
	if #g==0 then return false end
	return g:GetSum(Card.GetAttack)
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end

function cm.tgsfilter(c,e,tp)
	return Duel.IsPlayerCanSendtoHand(tp,c) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.mzctcheck(nil,tp))
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.tgsfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgsfilter,tp,0,0x10,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgsfilter,tp,0,0x10,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		local b1=Duel.IsPlayerCanSendtoHand(tp,tc)
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.mzctcheck(nil,tp)
		if b1 or b2 then
			if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
				Duel.SendtoHand(tc,tp,REASON_EFFECT,tp)
				if tc:IsLocation(0x02) then Duel.ConfirmCards(1-tp,tc) end
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function cm.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	if d and c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and d:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(cm.reptg)
		e1:SetOperation(cm.repop)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		d:RegisterEffect(e1)
	end
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE) and not c:IsImmuneToEffect(e) end
	return true
end

function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
		 if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		 end
	Duel.Overlay(e:GetLabelObject(),Group.FromCards(c))
end