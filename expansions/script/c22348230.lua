--银 河 眼 辉 煌 光 子 龙
local m=22348230
local cm=_G["c"..m]
function cm.initial_effect(c)
	--特 殊 召 唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348230,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348230)
	e1:SetCondition(c22348230.spcon)
	e1:SetTarget(c22348230.sptg)
	e1:SetOperation(c22348230.spop)
	c:RegisterEffect(e1)
	--除 外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348230,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)  
	e2:SetCountLimit(1,20228231)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22348230.recon)
	e2:SetCost(c22348230.recos)
	e2:SetTarget(c22348230.retg)
	e2:SetOperation(c22348230.reop)
	c:RegisterEffect(e2)
	--检 索
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348230,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,22348230)
	e3:SetTarget(c22348230.sctg)
	e3:SetOperation(c22348230.scop)
	c:RegisterEffect(e3)

end

function c22348230.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>0 and Duel.GetTurnPlayer()~=tp
end
function c22348230.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348230.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end





function c22348230.recon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)

end
function c22348230.recos(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c22348230.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22348230.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c22348230.reop(e,tp,eg,ep,ev,re,r,rp)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
end
function c22348230.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end


function c22348230.filter(c)
	return c:IsSetCard(0x7b) and not c:IsCode(22348230) and c:IsAbleToHand()
end
function c22348230.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348230.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348230.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348230.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

