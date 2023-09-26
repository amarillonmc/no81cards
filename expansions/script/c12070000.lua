--永燃的薪炎 薪炎之律者
function c12070000.initial_effect(c) 
	c:SetUniqueOnField(1,0,12070000)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,5,c12070000.ovfilter,aux.Stringid(12070000,0))
	c:EnableReviveLimit()   
	--ov 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(12070000,5))
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1)  
	e1:SetTarget(c12070000.ovtg) 
	e1:SetOperation(c12070000.ovop) 
	c:RegisterEffect(e1)  
	--to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOEXTRA) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetCondition(c12070000.tdcon)
	e2:SetTarget(c12070000.tdtg)
	e2:SetOperation(c12070000.tdop)
	c:RegisterEffect(e2) 
	--xx 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetCountLimit(1,32070000)
	e3:SetCondition(c12070000.xxcon)
	e3:SetOperation(c12070000.xxop)
	c:RegisterEffect(e3)
end 
c12070000.SetCard_NeoK_Flame=true 
function c12070000.ovfilter(c)
	return c.SetCard_NeoK_Flame and c:IsLevel(7) and c:IsFaceup()
end 
function c12070000.ovfil(c) 
	return c.SetCard_NeoK_Flame and c:IsCanOverlay()   
end 
function c12070000.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12070000.ovfil,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetChainLimit(c12070000.chlimit)
end
function c12070000.chlimit(e,ep,tp)
	return tp==ep
end
function c12070000.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c12070000.ovfil,tp,LOCATION_GRAVE,0,nil) 
	if c:IsRelateToEffect(e) and c:IsFaceup() and g:GetCount()>0 then 
	Duel.Overlay(c,g) 
	end 
end 
function c12070000.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()==1-tp and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c12070000.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToExtra() end 
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)  
end 
function c12070000.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end 
end 
function c12070000.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end
function c12070000.xxop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.Hint(HINT_CARD,0,12070000)  
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(12070000,1))  
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(12070000,1)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(12070000,2))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(12070000,2)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(12070000,3))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(12070000,3)) 
end 






