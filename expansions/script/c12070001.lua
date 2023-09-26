--永燃的薪炎 无名游侠的旅途
function c12070001.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12070001,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c12070001.ntcon)
	c:RegisterEffect(e1) 
	--Gains Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER) 
	e2:SetCondition(c12070001.efcon)
	e2:SetOperation(c12070001.efop)
	c:RegisterEffect(e2)
end 
c12070001.SetCard_NeoK_Flame=true 
function c12070001.cfilter(c)
	return c:IsFaceup() and c.SetCard_NeoK_Flame 
end
function c12070001.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c12070001.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) 
end
function c12070001.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard().SetCard_NeoK_Flame and c:GetReasonCard():IsType(TYPE_XYZ)
end
function c12070001.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(12070001,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c12070001.thtg)
	e1:SetOperation(c12070001.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c12070001.thfilter(c)
	return c.SetCard_NeoK_Flame and (c:IsAbleToHand() or c:IsCanOverlay())
end
function c12070001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12070001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
end
function c12070001.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.SelectMatchingCard(tp,c12070001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
	local tc=g:GetFirst()   
	local op=0  
	if tc:IsAbleToHand() and tc:IsCanOverlay() then 
	op=Duel.SelectOption(tp,aux.Stringid(12070001,2),aux.Stringid(12070001,3)) 
	elseif tc:IsAbleToHand() then 
	op=Duel.SelectOption(tp,aux.Stringid(12070001,2))
	elseif tc:IsCanOverlay() then 
	op=Duel.SelectOption(tp,aux.Stringid(12070001,3))+1  
	end 
	if op==0 then 
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)  
	elseif op==1 then 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	Duel.Overlay(c,tc)
	end 
	end 
	end
end




