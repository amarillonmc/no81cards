--狂之数码兽 钢铁悟空兽
function c50223140.initial_effect(c)
	--synchro summon
	aux.AddMaterialCodeList(c,50223135)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c50223140.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsCode,50223135),1,1)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,50223140)
	e1:SetTarget(c50223140.tgtg)
	e1:SetOperation(c50223140.tgop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c50223140.discon)
	e2:SetCost(c50223140.discost)
	e2:SetTarget(c50223140.distg)
	e2:SetOperation(c50223140.disop)
	c:RegisterEffect(e2)
end
function c50223140.matfilter1(c,syncard)
	return c:IsTuner(syncard) or (c:IsSynchroType(TYPE_NORMAL) and c:IsSetCard(0xcb1))
end
function c50223140.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c50223140.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c50223140.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c50223140.cfilter(c)
	return c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c50223140.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50223140.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c50223140.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	local removedcard=g:GetFirst()
	local cardtype=0
	if removedcard:IsType(TYPE_RITUAL) then
		cardtype=TYPE_RITUAL 
		else if removedcard:IsType(TYPE_FUSION) then
			cardtype=TYPE_FUSION 
			else if removedcard:IsType(TYPE_SYNCHRO) then
				cardtype=TYPE_SYNCHRO 
				else if removedcard:IsType(TYPE_XYZ) then
					cardtype=TYPE_XYZ 
					else if removedcard:IsType(TYPE_LINK) then
						cardtype=TYPE_LINK 
					end
				end
			end
		end
	end
	e:SetLabel(cardtype)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50223140.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c50223140.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c50223140.rmlimit)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c50223140.rmlimit(e,c,tp,r,re)
	return c:IsType(e:GetLabel()) and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(50223140) and r==REASON_COST
end