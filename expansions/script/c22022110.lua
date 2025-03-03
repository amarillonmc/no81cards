--人理之基 幼吉尔
function c22022110.initial_effect(c)
	--code
	aux.EnableChangeCode(c,22022090,LOCATION_MZONE+LOCATION_GRAVE)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022110,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,22022110)
	e1:SetCost(c22022110.rmcost)
	e1:SetTarget(c22022110.tftg)
	e1:SetOperation(c22022110.tfop)
	c:RegisterEffect(e1)
end
c22022110.effect_canequip_hogu=true
function c22022110.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22022110.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsCode(22022100)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c22022110.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c22022110.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c22022110.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c22022110.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end