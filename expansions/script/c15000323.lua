local m=15000323
local cm=_G["c"..m]
cm.name="内核异常 拉芒戈"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_TO_GRAVE)  
	e1:SetCountLimit(1,15000323)  
	e1:SetCondition(cm.spcon)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetCondition(cm.spcon2)  
	c:RegisterEffect(e2)
	--remove overlay replace  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,15010323)  
	e3:SetCondition(cm.rcon)  
	e3:SetOperation(cm.rop)  
	c:RegisterEffect(e3)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return re and re:IsActivated() and e:GetHandler():IsReason(REASON_COST) and (re:GetHandler():IsSetCard(0xf39) or (re:GetHandler():IsRace(RACE_FIEND) and re:GetHandler():IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER)))
end  
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()  
	return (e:GetHandler():IsReason(REASON_BATTLE) or e:GetHandler():IsReason(REASON_EFFECT)) and Duel.IsPlayerAffectedByEffect(tp,15000330)  
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()  
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)  
end  
function cm.thfilter(c,e,tp)  
	return c:IsSetCard(0xf39) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandler():GetControler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end  
	Duel.ConfirmDecktop(tp,5)  
	local g=Duel.GetDecktopGroup(tp,5)  
	local ct=g:GetCount()  
	if ct>0 and g:FilterCount(cm.thfilter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then  
		Duel.DisableShuffleCheck()  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)  
		local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil,e,tp) 
		if sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not sg:GetFirst():IsAbleToHand() then
			Duel.SpecialSummon(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		end
		if sg:GetFirst():IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)) then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		if sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:GetFirst():IsAbleToHand() then 
			if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.SpecialSummon(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(sg,nil,REASON_EFFECT)  
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end
		end
		g:RemoveCard(sg:GetFirst()) 
		ct=g:GetCount()
	end  
	if ct>0 then  
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(tp)  
	end  
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToGraveAsCost() and ep==e:GetOwnerPlayer() and re:GetHandler():IsSetCard(0xf39)
end  
function cm.rop(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end