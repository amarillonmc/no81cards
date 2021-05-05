--恶路程式 冻结
function c40008588.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008588,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c40008588.cost)
	e1:SetCondition(c40008588.spcon)
	e1:SetTarget(c40008588.target)
	e1:SetOperation(c40008588.operation)
	c:RegisterEffect(e1)
	if not c40008588.global_check then
		c40008588.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(40008588)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(40008588)
		Duel.RegisterEffect(ge2,0)
	end 
	--special summon 2
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(40008588,1))
	e8:SetCategory(CATEGORY_DRAW)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCountLimit(1,40008588)
	e8:SetCondition(c40008588.spcon2)
	e8:SetTarget(c40008588.sptg2)
	e8:SetOperation(c40008588.lpop)
	c:RegisterEffect(e8)   
end
function c40008588.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(40008588)>0
end
function c40008588.costfilter(c)
	return c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c40008588.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008588.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local rt=Duel.GetTargetCount(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,c40008588.costfilter,tp,LOCATION_HAND,0,1,rt,nil)
	Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
	e:SetLabel(cg:GetCount())
end
function c40008588.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,ct,0,0)
end
function c40008588.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
function c40008588.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c40008588.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c40008588.lpop(e,tp,eg,ep,ev,re,r,rp)
		 Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)*2))
		 local p1=Duel.GetLP(tp)
		 local p2=Duel.GetLP(1-tp)
		 local s=p2-p1
		 if s<0 then s=p1-p2 end
		 local d=math.floor(s/2000)
		 Duel.Draw(tp,d,REASON_EFFECT)
end