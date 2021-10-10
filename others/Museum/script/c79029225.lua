--格拉斯哥帮·先锋干员-推进之王·跃空锤
function c79029225.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c79029225.ovfilter,aux.Stringid(79029022,1))
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029225,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c79029225.stgtarget)
	e1:SetOperation(c79029225.stgoperation)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029225)
	e2:SetCost(c79029225.thcost)
	e2:SetTarget(c79029225.thtg)
	e2:SetOperation(c79029225.thop)
	c:RegisterEffect(e2)   
end
function c79029225.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_LINK)
end
function c79029225.dfil(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c79029225.stgtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetMatchingGroupCount(c79029225.dfil,tp,0,LOCATION_MZONE,nil,atk)>=1 end
	local g=Duel.GetMatchingGroup(c79029225.dfil,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029225.stgoperation(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local x=Duel.GetMatchingGroupCount(c79029225.dfil,tp,0,LOCATION_MZONE,nil,atk)
	local x1=Duel.Destroy(g,REASON_EFFECT)
	e:GetHandler():AddCounter(0x1099,x1)
	Debug.Message("对拒绝投降者无需怜悯。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029225,0))
end
function c79029225.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029225.tdfil(c,e)
	return c:IsAbleToHand() and (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e))
end
function c79029225.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetMatchingGroupCount(c79029225.tdfil,tp,LOCATION_DECK,0,nil,e)>=1 end
	local g=Duel.SelectMatchingCard(tp,c79029225.tdfil,tp,LOCATION_DECK,0,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029225.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	Debug.Message("准备好了吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029225,1))	
end





