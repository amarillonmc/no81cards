--阿里乌斯的支配者 多目女
function c72421340.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c72421340.ffilter,3,true)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72421340.tgcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indestructable
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72421340,0))
	e1:SetCountLimit(1)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c72421340.target)
	e1:SetOperation(c72421340.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72421340,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c72421340.destg)
	e4:SetOperation(c72421340.desop)
	c:RegisterEffect(e4)
	
end
function c72421340.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x9725) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c72421340.tgcon(e,c)
	return Duel.IsExistingMatchingCard(c72421340.ffilter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c72421340.ffilter2(c)
	return c:IsCode(72421510) and c:IsFaceup()
end
function c72421340.tffilter(c,tp)
	return c:IsCode(72421510) and not c:IsType(TYPE_FIELD+TYPE_MONSTER) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end

function c72421340.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
		return ft>0 and Duel.IsExistingMatchingCard(c72421340.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
end

function c72421340.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c72421340.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c72421340.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c72421340.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end