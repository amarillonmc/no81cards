--千夜 女王
function c60150617.initial_effect(c)
	c:EnableReviveLimit()
	--fusion summon
	aux.AddFusionProcFunRep(c,c60150617.ffilter,3,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60150617.splimit)
	c:RegisterEffect(e1)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150617,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c60150617.tgcon)
	e4:SetTarget(c60150617.tgtg)
	e4:SetOperation(c60150617.tgop)
	c:RegisterEffect(e4)
	--cannot be target/battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3b21))
	e5:SetValue(c60150617.tgvalue)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(60150617,3))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c60150617.thtg)
	e7:SetOperation(c60150617.thop)
	c:RegisterEffect(e7)
end
function c60150617.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3b21) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c60150617.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c60150617.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c60150617.tgfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM) 
		and ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()) or c:IsLocation(LOCATION_DECK)) and c:IsAbleToGrave()
end
function c60150617.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150617.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c60150617.tgop(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetHandler():GetMaterialCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60150617.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,sc,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c60150617.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c60150617.thfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER)
end
function c60150617.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c60150617.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60150617.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c60150617.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60150617.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_PENDULUM) and Duel.SelectYesNo(tp,aux.Stringid(60150617,0)) then
			if Duel.SendtoExtraP(tc,nil,REASON_EFFECT)>0 then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		elseif tc:IsAbleToDeck() then
			if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end