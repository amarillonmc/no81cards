--勇武炎樱之化龙
function c95101214.initial_effect(c)
	aux.AddMaterialCodeList(c,95101211)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.FilterBoolFunction(Card.IsCode,95101211),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101214)
	e1:SetTarget(c95101214.destg)
	e1:SetOperation(c95101214.desop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--cannot bp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BP)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c95101214.bpcon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101214,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,95101214)
	e2:SetCondition(c95101214.descon)
	e3:SetTarget(c95101214.destg)
	e3:SetOperation(c95101214.desop)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
end
function c95101214.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c95101214.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	local ct=e:GetLabel()==1 and #g or 1
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c95101214.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if e:GetLabel()~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=g:Select(tp,1,1,nil)
		Duel.HintSelection(g)
	end
	Duel.Destroy(g,REASON_EFFECT)
end
function c95101214.bpcon(e)
	return e:GetHandler():GetEquipTarget()
end
