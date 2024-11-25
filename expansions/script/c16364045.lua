--X抗体 多路暴龙兽
function c16364045.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c16364045.mfilter,nil,2,2)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16364045,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,16364045)
	e1:SetCondition(c16364045.tgcon)
	e1:SetTarget(c16364045.tgtg)
	e1:SetOperation(c16364045.tgop)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16364045,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CUSTOM+16364045)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16364045+1)
	e2:SetCondition(c16364045.xyzcon)
	e2:SetOperation(c16364045.xyzop)
	c:RegisterEffect(e2)
	--attack twice
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	if not c16364045.mataddcheck then
		c16364045.mataddcheck=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(card,param)
			_Overlay(card,param)
			if card:IsCode(16364045) then
				Duel.RaiseEvent(param,EVENT_CUSTOM+16364045,nil,REASON_EFFECT,0,0,0)
			end
		end
	end
end
function c16364045.mfilter(c,xyzc)
	return c:IsLevelAbove(1) and c:IsSetCard(0xdc3)
end
function c16364045.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c16364045.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c16364045.filter(c)
	return c:IsSetCard(0xdc3) and c:IsType(TYPE_MONSTER)
end
function c16364045.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c16364045.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(16364045,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c16364045.filter,1,1,nil)
			local tc=sg:GetFirst()
			if tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(16364045,4)) then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			else 
				Duel.Overlay(e:GetHandler(),tc)
			end
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end
function c16364045.matcheck(c,g)
	return g:IsContains(c)
end
function c16364045.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetCount()>0 and eg:IsExists(c16364045.matcheck,1,nil,g)
end
function c16364045.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
	end
end