--方舟骑士-阿米娅
c29065500.named_with_Arknight=1
function c29065500.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065500,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,29065500)
	e1:SetTarget(c29065500.thtg)
	e1:SetOperation(c29065500.thop)
	c:RegisterEffect(e1)   
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065500,0)) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29065503)
	e2:SetCost(c29065500.cocost)
	e2:SetTarget(c29065500.cotg)
	e2:SetOperation(c29065500.coop)
	c:RegisterEffect(e2) 
end
function c29065500.thfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c29065500.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065500.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065500.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065500.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29065500.efil(c,e,tp,eg,ep,ev,re,r,rp) 
	if not (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and not c:IsCode(29065500) then return false end 
	local m=_G["c"..c:GetCode()]
	if not m then return false end 
	local te=m.summon_effect	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c29065500.cocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065500.efil,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	local tc=Duel.SelectMatchingCard(tp,c29065500.efil,tp,LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,re,r,rp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabelObject(tc)
end
function c29065500.cotg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	tc:CreateEffectRelation(e)
	local m=_G["c"..tc:GetCode()]
	local te=m.summon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c29065500.coop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
		local m=_G["c"..tc:GetCode()]
		local te=m.summon_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) 
	end
end



