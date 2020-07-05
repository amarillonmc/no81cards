local m=82206024
local cm=_G["c"..m]
cm.name="植占师4-阳光"
function cm.initial_effect(c)
	--special summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.spcon)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2) 
	--recover  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_RECOVER)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetCountLimit(1,82216024)  
	e3:SetTarget(cm.rectg)  
	e3:SetOperation(cm.recop)  
	c:RegisterEffect(e3) 
end
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end  
function cm.cfilter2(c)  
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_EXTRA,0,1,1,nil)  
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then  
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			e1:SetValue(LOCATION_DECKSHF)  
			c:RegisterEffect(e1,true) 
		end
	end  
end  
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(800)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)  
end  
function cm.recop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Recover(p,d,REASON_EFFECT)  
end  