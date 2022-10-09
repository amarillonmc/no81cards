--精英化
local m=88802032
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88802032)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsFaceup() and (c:IsOriginalSetCard(0x9d41) and not c:IsOriginalSetCard(0x9d44))
end
function cm.filter2(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thfilter(c)
	return c:IsSetCard(0x9d41) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(Card.IsCode,nil,tc:GetCode())
		if tg:GetCount()>0 then
		   local sg=tg:Select(tp,1,1,nil)
		   local tz=sg:GetFirst()
		   if tz:IsType(TYPE_FUSION) then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			  local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
			  if g:GetCount()>0 then
				 Duel.SendtoHand(g,nil,REASON_EFFECT)	  
				 Duel.ConfirmCards(1-tp,g) 
				 if Duel.SelectYesNo(tp,aux.Stringid(88802032,0)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local vg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
					if vg:GetCount()>0 then
						Duel.SendtoHand(vg,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,vg)
					end
				  end
			  end
		   end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x9d41)
end