--解放之魂
function c21401020.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c21401020.lcheck)
	c:EnableReviveLimit()
	
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21401020,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,21401020)
	e3:SetCondition(c21401020.accon)
	e3:SetCost(c21401020.accst)
	e3:SetTarget(c21401020.actg)
	e3:SetOperation(c21401020.acop)
	c:RegisterEffect(e3)
end

function c21401020.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end

function c21401020.accst(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_COST)
end

function c21401020.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end

function c21401020.accon(e)
	local c = e:GetHandler()
	if c:GetLocation() & LOCATION_GRAVE == 0 then
		return true
	end
	
	if c:GetReason() & REASON_EFFECT >0 and c:GetReasonPlayer() == c:GetControler() then
	return  Duel.GetTurnCount()~=c:GetTurnID() or c:IsReason(REASON_RETURN) end
	
	return true
		
end

function c21401020.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g = Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

