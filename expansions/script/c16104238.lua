--天命真王 驭龙王
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104238)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(cm.sync),1)
	--copy and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)   
	local e2=rkch.PenAdd(c,{m,1},{1,m+1},{cm.cost,nil,cm.addtarget,cm.addop},false)
	local e3=rkch.MonzToPen(c,m,nil,0)   
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(cm.actlimit)
	c:RegisterEffect(e4) 
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetCondition(cm.discon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_PIERCE)
	e7:SetCondition(cm.discon)
	e7:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,2))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCategory(CATEGORY_EQUIP)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(cm.target)
	e8:SetOperation(cm.op)
	c:RegisterEffect(e8)
end
function cm.sync(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.copyfilter(c,tp)
	return c:IsRace(RACE_DRAGON) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and cm.copyfilter(chkc,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(cm.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.copyfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if tc:IsRelateToEffect(e) then
				if not Duel.Equip(tc,tc,c) then return end
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(c)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(2000)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e3)
			end
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.cost(e)
	e:SetLabel(1)
	return true
end
function cm.addfilter(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0xccd)
end
function cm.addtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()==1 then
			return Duel.IsExistingMatchingCard(cm.addfilter,tp,LOCATION_EXTRA,0,1,nil) 
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,cm.addfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:GetFirst()
	Duel.SetTargetCard(tc)
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.thfilter(c)
	return (c:IsSetCard(0xccd) or rk.check(c,"DAIOU")) and c:IsAbleToHand()
end
function cm.addop(e,tp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	Debug.Message(tc:GetCode())
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) or not tc:IsAbleToHand() then return end
	if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT,nil)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
function cm.actlimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function cm.check(c)
	return c:GetOriginalRace()&RACE_DRAGON~=0 and c:IsFaceup()
end
function cm.discon(e,tp)
	return e:GetHandler():GetEquipGroup() and e:GetHandler():GetEquipGroup():IsExists(cm.check,1,nil)
end
function cm.eqfilter22(c,tp)
	return c:IsRace(RACE_DRAGON) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfilter22,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.eqfilter22,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,cm.eqfilter22,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if not Duel.Equip(tp,tc,c) then return end
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(2000)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e3)
			c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,0)
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end