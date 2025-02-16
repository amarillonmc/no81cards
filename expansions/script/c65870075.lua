--Protoss·龙骑士
function c65870075.initial_effect(c)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65870075+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65870075.spcon)
	e1:SetTarget(c65870075.sptg)
	e1:SetOperation(c65870075.spop)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65870075,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c65870075.destg)
	e3:SetOperation(c65870075.desop)
	c:RegisterEffect(e3)
end

function c65870075.filter(c)
	return c:IsRace(RACE_WARRIOR) and Duel.GetMZoneCount(tp,c,tp)>0 and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceupEx()
end
function c65870075.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c65870075.filter,c:GetControler(),LOCATION_REMOVED+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c65870075.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c65870075.filter,tp,LOCATION_REMOVED+LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=g:SelectUnselect(tc,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c65870075.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,2,REASON_SPSUMMON)
end

function c65870075.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65870075.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end