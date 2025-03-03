local m=15005920
local cm=_G["c"..m]
cm.name="龙芯残机-传动黄琮"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.xdncon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.xdncon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(cm.rtcon)
	e3:SetTarget(cm.rttg)
	e3:SetOperation(cm.rtop)
	c:RegisterEffect(e3)
end
function cm.cfilter2(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function cm.xdncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetOverlayCount()==0
end
function cm.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.rtfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f43)
end
function cm.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.rtfilter,tp,LOCATION_REMOVED,0,1,nil) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.rtfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.HintSelection(g)
		if tc and (not tc:IsAbleToDeck() or Duel.SelectOption(tp,1191,1193)==0) then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
		else
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end