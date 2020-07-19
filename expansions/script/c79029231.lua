--罗德岛·部署-君影轻灵
function c79029231.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,79029230) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCost(c79029231.cost)
	e1:SetTarget(c79029231.tg)
	e1:SetOperation(c79029231.op)
	c:RegisterEffect(e1) 
end
function c79029231.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	 Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79029231.tfil(c)
	 return c:IsType(TYPE_RITUAL) and c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79029231.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingMatchingCard(c79029231.tfil,tp,LOCATION_DECK,0,1,nil) end
	Debug.Message("我们都可以做到的，嗯！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029231,0))   
	 local g=Duel.SelectMatchingCard(tp,c79029231.tfil,tp,LOCATION_DECK,0,1,1,nil)
	 Duel.SetTargetCard(g)
	 Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029231.op(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetFirstTarget()
	 Duel.SendtoHand(tc,tp,REASON_EFFECT)
	 Duel.ConfirmCards(1-tp,tc)
end