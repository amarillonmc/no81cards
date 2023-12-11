--魔军的圣骑士 佐灵
Duel.LoadScript("c64800046.lua")
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,s.ckfilter1,s.ckfilter2,2,2,true)
 --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
 --negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)

end
s.setname="Devildiocese"
function s.ffilter(c)
	return c.setname=="Devildiocese"
end
function s.ckfilter1(c)
	return c.setname=="Devildiocese" and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsType(TYPE_MONSTER)
end
function s.ckfilter2(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,nil)  end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
