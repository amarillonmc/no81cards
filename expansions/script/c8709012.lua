--端午节的觉醒小袖之手
function c8709012.initial_effect(c)
		  --xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c8709012.ovfilter,aux.Stringid(8709012,0),3,c8709012.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c8709012.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c8709012.defval)
	c:RegisterEffect(e2)	
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8709012,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCountLimit(1)
	e3:SetCondition(c8709012.dscon)
	e3:SetCost(c8709012.cost)
	e3:SetTarget(c8709012.dstg)
	e3:SetOperation(c8709012.dsop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
 
end

function c8709012.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xafa) and not c:IsCode(8709012)
end
function c8709012.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,8709012)==0 end
	Duel.RegisterFlagEffect(tp,8709012,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c8709012.atkfilter(c)
	return c:IsSetCard(0xafa) and c:GetAttack()>=0
end
function c8709012.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709012.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c8709012.deffilter(c)
	return c:IsSetCard(0xafa) and c:GetDefense()>=0
end
function c8709012.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709012.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end

function c8709012.dscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c8709012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8709012.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c8709012.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end









