--动物朋友 土狼
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700093.initial_effect(c)
	   --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700093.cost)
	e1:SetTarget(c33700093.target)
	e1:SetOperation(c33700093.operation)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c33700093.spcon)
	c:RegisterEffect(e2)
	--return
	 local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_REMOVE)
	e4:SetTarget(c33700093.tg)
	e4:SetOperation(c33700093.op)
	c:RegisterEffect(e4)  
end
function c33700093.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700093.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700093)
end
function c33700093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700093.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(33700093,0))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700093.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700093.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
	end
end
function c33700093.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetMZoneCount(c:GetControler())>0
end
function c33700093.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c33700093.filter(c)
	return c:IsSetCard(0x442)  and c:IsFaceup()
end
function c33700093.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33700093.filter,tp,LOCATION_REMOVED,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
