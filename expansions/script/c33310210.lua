--空想夜王 月天
function c33310210.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x551),aux.FilterBoolFunction(Card.IsLevelBelow,6),true)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,33311210)
	e0:SetCondition(c33310210.sprcon)
	e0:SetOperation(c33310210.sprop)
	c:RegisterEffect(e0)
	--public
	--local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_DRAW)
	--e1:SetType(EFFECT_TYPE_IGNITION)
   -- e1:SetRange(LOCATION_MZONE)
	--e1:SetCountLimit(1,33310210)
   -- e1:SetTarget(c33310210.pubtg)
	--e1:SetOperation(c33310210.pubop)
   -- c:RegisterEffect(e1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33310210,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,33310210)
	e1:SetTarget(c33310210.thtg)
	e1:SetOperation(c33310210.thop)
	c:RegisterEffect(e1)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33310210,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCountLimit(1,33311211)
	e5:SetCondition(c33310210.spcon)
	e5:SetTarget(c33310210.sptg)
	e5:SetOperation(c33310210.spop)
	c:RegisterEffect(e5)
end

function c33310210.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c33310210.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c33310210.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33310210.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and e:GetHandler():GetFlagEffect(33310210)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33310210.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33310210.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c33310210.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) 
end
function c33310210.spfilter(c)
	return c:IsCode(33310200) and c:IsAbleToHand()
end
function c33310210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310210.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33310210.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33310210.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33310210.pubfil1(c)
	return not c:IsPublic()
end
function c33310210.pubfil2(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c33310210.pubtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c33310210.pubfil1,tp,0,LOCATION_HAND,nil)>0 and e:GetHandler():GetFlagEffect(33310210)==0 end
end
function c33310210.pubop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(1-tp,c33310210.pubfil2,tp,0,LOCATION_HAND,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local gc=g:GetFirst()
		 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		gc:RegisterEffect(e1)
		gc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33310210,1))
	elseif Duel.IsPlayerCanDraw(tp) and Duel.SelectYesNo(tp,aux.Stringid(33310210,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c33310210.sprfilter(c)
	return c:IsSetCard(0x551) and c:IsPublic() and c:IsAbleToGraveAsCost()
end
function c33310210.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c33310210.sprfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,33310210)==0
end
function c33310210.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,33310210,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SelectMatchingCard(tp,c33310210.sprfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
	 e:GetHandler():RegisterFlagEffect(33310210,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end