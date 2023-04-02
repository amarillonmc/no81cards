--天斗辉巧核
function c11533709.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) end) 
	c:RegisterEffect(e1)
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_RELEASE) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11533709)  
	e1:SetCondition(function(e) 
	return e:GetHandler():GetReasonEffect():GetHandler():IsSetCard(0x163,0x154) and e:GetHandler():IsReason(REASON_COST) end)
	e1:SetTarget(c11533709.thtg) 
	e1:SetOperation(c11533709.thop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21533709) 
	e2:SetCost(c11533709.spcost)
	e2:SetTarget(c11533709.sptg) 
	e2:SetOperation(c11533709.spop)  
	c:RegisterEffect(e2) 
end 
function c11533709.thfil(c) 
	return c:IsCode(89771220) and c:IsAbleToHand()  
end  
function c11533709.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533709.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11533709.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11533709.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11533709.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return not c:IsPublic() and c:IsCode(89771220) end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return not c:IsPublic() and c:IsCode(89771220) end,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.ConfirmCards(1-tp,g)
end 
function c11533709.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c11533709.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local code=e:GetHandler():GetCode() 
		getmetatable(e:GetHandler()).announce_filter={89264428,OPCODE_ISCODE,27693363,OPCODE_ISCODE,OPCODE_OR,58793369,OPCODE_ISCODE,OPCODE_OR,97148796,OPCODE_ISCODE,OPCODE_OR} 
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter)) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_CODE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(ac) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
		local lv=Duel.AnnounceNumber(tp,1,8) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_LEVEL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(lv)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)	
	end 
end 
	






