--Protoss·执政官
function c65870055.initial_effect(c)
	c:SetSPSummonOnce(65870055)
	aux.AddCodeList(c,65870030,65870040)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65870055.ffilter,2,true)
	aux.AddContactFusionProcedure(c,c65870055.cfilter,LOCATION_MZONE+LOCATION_GRAVE,0,aux.tdcfop(c))
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870055,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c65870055.destg)
	e1:SetOperation(c65870055.desop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65870055,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c65870055.spcon)
	e3:SetTarget(c65870055.sptg)
	e3:SetOperation(c65870055.spop)
	c:RegisterEffect(e3)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c65870055.adval)
	c:RegisterEffect(e4)
	local e2=e4:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end

function c65870055.ffilter(c,fc,sub,mg,sg)
	return c:IsCode(65870030,65870040) and c:IsType(TYPE_MONSTER)
end
function c65870055.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and c:IsCode(65870030,65870040)
end

function c65870055.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,g:GetCount(),1-tp,LOCATION_ONFIELD)
end
function c65870055.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end	
end

function c65870055.spfilter(c,fc,sub,mg,sg)
	return c:IsAbleToRemove()
end
function c65870055.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c65870055.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870055.spfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c65870055.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65870055.spfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,tp)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

function c65870055.filter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x3a37)
end
function c65870055.adval(e,c)
	return Duel.GetMatchingGroupCount(c65870055.filter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*500
end