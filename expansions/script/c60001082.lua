local m=60001082
local cm=_G["c"..m]
cm.name="闪刀姬-耀世零衣"
function cm.initial_effect(c)
	c:SetSPSummonOnce(60001082)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,1,1)
	aux.AddXyzProcedureLevelFree(c,cm.xfilter,nil,2,2)
	--rkchange
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_RANK)
	e0:SetValue(4)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.rkchange then
		cm.rkchange=true
		_ace2GetRank=Card.GetRank
		function Card.GetRank(c)
			if (c:GetOriginalCode()==60001082 and c:IsLocation(LOCATION_EXTRA)) then return 4 end
			return _ace2GetRank(c)
		end
		_ace2GetOriginalRank=Card.GetOriginalRank
		function Card.GetOriginalRank(c)
			if c:GetOriginalCode()==60001082 then return 4 end
			return _ace2GetOriginalRank(c)
		end
		_ace2IsRank=Card.IsRank
		Card.IsRank=function(c,rk1,...)
			if not (c:GetOriginalCode()==60001082 and c:IsLocation(LOCATION_EXTRA)) then return _ace2IsRank(c,rk1,...) end
			if rk1==4 then return true end
			local t={...}
			for _,rk in pairs(t) do
				if rk==4 then return true end
			end
			return false
		end
		_ace2IsRankAbove=Card.IsRankAbove
		function Card.IsRankAbove(c,rk)
			if (c:GetOriginalCode()==60001082 and c:IsLocation(LOCATION_EXTRA)) and rk<=4 then return true end
			return _ace2IsRankAbove(c,rk)
		end
		_ace2IsRankBelow=Card.IsRankBelow
		function Card.IsRankBelow(c,rk)
			if (c:GetOriginalCode()==60001082 and c:IsLocation(LOCATION_EXTRA)) and rk>=4 then return true end
			return _ace2IsRankBelow(c,rk)
		end
	end
end
function cm.lfilter(c)
	return c:IsLinkSetCard(0x1115) and not c:IsLinkAttribute(ATTRIBUTE_DARK)
end
function cm.xfilter(c,sc)
	return c:IsCanOverlay() and c:IsXyzLevel(sc,4)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(60001082,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(60001082)~=0
end
function cm.thfilter(c)
	return c:IsSetCard(0x115) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsLevel(4)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end