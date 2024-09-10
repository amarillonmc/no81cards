--圣兽装骑·鲨-波纹
local m=60001114
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),3,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.crcon)
	e2:SetTarget(cm.crtg)
	e2:SetOperation(cm.crop)
	c:RegisterEffect(e2)
	--Checkgrave
	local e27=Effect.CreateEffect(c)
	e27:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e27:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e27:SetCode(EVENT_ADJUST)
	e27:SetOperation(cm.gravecheckop)
	Duel.RegisterEffect(e27,0)
end

function cm.gravecheckop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then
		e:GetHandler():RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60001111,0))
	end
end

function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function cm.ophfilter(c)
	return c:IsSetCard(0x62e) and c:IsAbleToGrave()
end

function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if c:GetOverlayCount()~=0 then
			c:RemoveOverlayCard(tp,c:GetOverlayCount(),c:GetOverlayCount(),REASON_EFFECT)
		end
		c:RegisterFlagEffect(600011140,RESET_PHASE+PHASE_END,0,1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetCondition(cm.negcon)
		e3:SetOperation(cm.negop)
		Duel.RegisterEffect(e3,tp)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp) 
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and 
	c:GetFlagEffect(600011141)<c:GetFlagEffect(600011140)
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(600011141,RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function cm.crcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) or Duel.GetFlagEffect(tp,m)==0
end

function cm.tgcfilter(c)
	return not c:IsRace(RACE_ZOMBIE)
end

function cm.crtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and 
	(c:IsLocation(LOCATION_MZONE) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) end
	c:ResetFlagEffect(m)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(tp,m,0,0,1)
		c:RegisterFlagEffect(m,0,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.crop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if Duel.Draw(tp,1,REASON_EFFECT) then
		Duel.ConfirmCards(1-tp,tc)
		if not tc:IsSetCard(0x62e) then Duel.SendtoGrave(tc,REASON_EFFECT) end
		if c:IsRelateToEffect(e) and c:GetFlagEffect(m)~=0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end