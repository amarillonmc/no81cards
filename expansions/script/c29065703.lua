--钢铁方舟·深洋巨神号
function c29065703.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065703,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c29065703.ntcon)
	c:RegisterEffect(e1)	
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,29065703)
	e3:SetCondition(c29065703.efcon)
	e3:SetTarget(c29065703.eftg)
	e3:SetOperation(c29065703.efop)
	c:RegisterEffect(e3)  
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_MOVE)
	e4:SetCondition(c29065703.xefcon)
	c:RegisterEffect(e4)
end
function c29065703.ntfilter(c)
	return c:IsFaceup() and c:IsLevel(12) or c:IsRank(12)
end
function c29065703.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29065703.ntfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c29065703.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return bit.band(r,REASON_MATERIAL)~=0 and bit.band(r,REASON_SUMMON)==0
end 
function c29065703.xefcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY)  and (c:IsReason(REASON_COST) or c:IsReason(REASON_EFFECT))
end
function c29065703.tgfil(c)
	return c:IsAbleToRemove()
end
function c29065703.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065703.tgfil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c29065703.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29065703.tgfil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end