--咒箱女王·娜哈特·娜哈特
local m=60002252
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.spcon(e,c)
	local num=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if c==nil then return true end
	return num>=4
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.thfilter(c)
	return c:IsCode(60002254)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetHandler():IsPreviousLocation(LOCATION_HAND) then
			--overlay
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetCode(EVENT_BATTLE_START)
			e4:SetRange(LOCATION_MZONE)
			e4:SetTarget(cm.tgtg)
			e4:SetOperation(cm.tgop)
			e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e4)
			--destroy replace
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EFFECT_DESTROY_REPLACE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTarget(cm.reptg)
			c:RegisterEffect(e2)
		end
	end
end
function cm.ofilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsCanOverlay()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttackTarget()
	if chk==0 then return tc~=nil end
	Duel.SetTargetCard(tc)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			og:AddCard(tc)
			Duel.Overlay(c,og)
		else
			Duel.Overlay(c,tc)
		end
	end
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
