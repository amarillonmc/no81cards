local s, id = GetID()--诛仙剑阵·破解版
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)	   
	c:RegisterEffect(e0)


	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.immtg)
	e1:SetValue(aux.indoval)
	e1:SetCondition(s.effcon)
	e1:SetLabel(2)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.aclimit)
	e2:SetCondition(s.effcon)
	e2:SetLabel(3)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.disable)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetCondition(s.effcon)
	e3:SetLabel(4)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.deson)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)		
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)   
	c:RegisterEffect(e4)

   

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(s.descon)
	c:RegisterEffect(e5)
	

end
--1
function s.immtg(e,c)
	return c:IsSetCard(0x954)
end
--2
function s.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return (loc==LOCATION_GRAVE) and re:IsActiveType(TYPE_MONSTER)
end
--3
function s.disable(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0
end
--4
function s.deson(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)   
	 if chk==0 then return true end
	  local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end

function s.ff(c)
	return c:IsFaceup() and c:IsCode(95040020)
end
function s.descon(e)
	return not Duel.IsExistingMatchingCard(s.ff,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.confilter(c)
	return c:IsSetCard(0x953)
end
function s.effcon(e)
	local g=Duel.GetMatchingGroup(s.confilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil)   
	return g:GetClassCount(Card.GetCode)>=e:GetLabel()
end
