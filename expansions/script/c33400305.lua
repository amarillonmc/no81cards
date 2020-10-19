--夜刀神十香 剑之王者
function c33400305.initial_effect(c)
	 --xyz summon
	 aux.AddXyzProcedureLevelFree(c,c33400305.mfilter,c33400305.xyzcheck,2,2,c33400305.ovfilter,
	 aux.Stringid(33400305,2),nil)
	c:EnableReviveLimit()  
	--Battle!!
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400305,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400305)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c33400305.bacost)
	e1:SetTarget(c33400305.batg)
	e1:SetOperation(c33400305.baop)
	c:RegisterEffect(e1)
	 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400305,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33400305+10000)
	e2:SetCondition(c33400305.thcon)
	e2:SetTarget(c33400305.thtg)
	e2:SetOperation(c33400305.thop)
	c:RegisterEffect(e2)
end
function c33400305.mfilter(c)
	return c:IsLevel(4)
end
function c33400305.xyzcheck(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_RITUAL)
end
function c33400305.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5341) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c33400305.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c33400305.bacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400305.bafilter1(c)
	return c:IsAttackable() and c:IsSetCard(0x5341) and c:IsFaceup()
end
function c33400305.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c33400305.bafilter1,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c33400305.bafilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c33400305.baop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=2 then return end
	local ac=tg:Filter(Card.IsControler,nil,tp):GetFirst()
	local at=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	Duel.CalculateDamage(ac,at)
end

function c33400305.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33400305.thfilter(c)
	return c:IsSetCard(0x5341) and c:IsAbleToHand()
end
function c33400305.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c33400305.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400305.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33400305.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33400305.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end