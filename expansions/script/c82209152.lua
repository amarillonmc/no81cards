--光子幻蝶刺客
local m=82209152
local cm=c82209152
function cm.initial_effect(c)
	--xyz effect  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)  
	e1:SetCondition(cm.sccon)  
	e1:SetTarget(cm.sctg)  
	e1:SetOperation(cm.scop)  
	c:RegisterEffect(e1)  
	--tohand
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.mttg)  
	e2:SetOperation(cm.mtop)  
	c:RegisterEffect(e2)  
	--act in hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e3:SetCondition(cm.handcon)  
	c:RegisterEffect(e3)
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetTurnPlayer()==tp then return false end  
	local ph=Duel.GetCurrentPhase()  
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2  
end  
function cm.mfilter(c)  
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsFaceup() 
end  
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil)  
		return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,mg)  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.scop(e,tp,eg,ep,ev,re,r,rp)  
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil)  
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,mg)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.XyzSummon(tp,sg:GetFirst(),mg,1,mg:GetCount())
	end  
end  
function cm.tgfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRank(4) and c:IsFaceup() and c:GetOverlayCount()==0
end
function cm.mtfilter(c)
	return c:IsSetCard(0x6a) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter(chkc) end  
	if chk==0 then return c:IsAbleToHand() and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)   
end  
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.mtfilter),tp,LOCATION_GRAVE,0,1,1,nil)  
		if g:GetCount()>0 then  
			Duel.HintSelection(g)
			Duel.Overlay(tc,g)  
			if tc:GetOverlayGroup():IsContains(g:GetFirst()) and c:IsRelateToEffect(e) then
				Duel.SendtoHand(c,nil,REASON_EFFECT)
			end
		end
	end  
end
function cm.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function cm.handfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x6a)
end